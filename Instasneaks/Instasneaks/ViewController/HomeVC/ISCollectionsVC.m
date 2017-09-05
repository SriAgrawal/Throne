//
//  ISCollectionsVC.m
//  Instasneaks
//
//  Created by Suresh patel on 15/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISCollectionsVC.h"

static NSString *CellIdentifier = @"ISHomeTableCell";
static NSString *HeaderCellIdentifier = @"ISSeactionHeaderCell";
@interface ISCollectionsVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    int pageNumber;
}

@property (strong, nonatomic) IBOutlet UITableView      * tableView_collections;
@property (strong, nonatomic) IBOutlet UIButton         * button_createCollections;
@property (strong, nonatomic) IBOutlet UIView           * view_topBarView;
@property (strong, nonatomic) IBOutlet UIView           * tableHeaderView;
@property (strong, nonatomic) IBOutlet UICollectionView * homeHeaderCollectionView;
@property (strong, nonatomic) IBOutlet UIPageControl    * pageControl;

@property (strong, nonatomic) UIRefreshControl          * refreshControl;

@property (strong, nonatomic) NSMutableArray        * imageDataArray;
@property (strong, nonatomic) NSMutableArray        * popularStoresdataArray;
@property (strong, nonatomic) NSMutableArray        * trendingItemsdataArray;
@property (strong, nonatomic) ISPagination      * pagination;

@end

@implementation ISCollectionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
       [self initialMethod];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods

-(void)initialMethod
{
    [[Mixpanel sharedInstance] track:@"Latest Drop opened" properties:@{ @"Background color": @"Moody blue", @"Latest Drop opened": @"absolutetly"}];
    
    self.imageDataArray = [[NSMutableArray alloc] init];
    self.popularStoresdataArray = [[NSMutableArray alloc] init];
    self.trendingItemsdataArray = [[NSMutableArray alloc] init];

    [self.popularStoresdataArray addObject:[[ISUserInfo alloc] init]];
    self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _pageControl.transform = CGAffineTransformMakeScale(0.7, 0.7);
    self.tableView_collections.tableHeaderView = self.tableHeaderView;
    
    [self.tableView_collections registerNib:[UINib nibWithNibName:@"ISHomeTableCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    [self.homeHeaderCollectionView registerNib:[UINib nibWithNibName:@"ISBuyCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"ISBuyCollectionCell"];
    [self.tableView_collections registerNib:[UINib nibWithNibName:NSStringFromClass([ISSeactionHeaderCell class]) bundle:nil] forHeaderFooterViewReuseIdentifier:HeaderCellIdentifier];
    [self addRefreshController];
    [self.tableView_collections setHidden:YES];
    pageNumber = 1;
    [self performSelector:@selector(makeWebApiCallToGetResult:) withObject:nil afterDelay:1.0];
}

-(void)addRefreshController{
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView_collections addSubview:self.refreshControl];
}

- (void)handleRefresh:(UIRefreshControl *)refreshControl {

    [self.refreshControl endRefreshing];
    pageNumber = 1;
    [self makeWebApiCallToGetResult:1];
}

#pragma mark - TableView Delegate and DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section)
        return self.trendingItemsdataArray.count ? 1 : 0;
    else
        return self.popularStoresdataArray.count ? 1 : 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
        return (self.trendingItemsdataArray.count/2 + self.trendingItemsdataArray.count%2)*244+10;
    else
        return 230.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ISSeactionHeaderCell *sectionHeaderCell = (ISSeactionHeaderCell *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderCellIdentifier];
    
    //Custom section header view
    sectionHeaderCell.sepreatorView.hidden = YES;
    sectionHeaderCell.seactionLbl.text = [@[@"Popular Stores",@"Trending items"] objectAtIndex:section];
    sectionHeaderCell.seactionLbl.font = NEO_SANS_PRO_REGULAR(15);
    [sectionHeaderCell.seeAllBtn addTarget:self action:@selector(seeAllAction:) forControlEvents:UIControlEventTouchUpInside];
    sectionHeaderCell.seeAllBtn.hidden = (section == 1) ? YES : NO;
    return sectionHeaderCell;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ISHomeTableCell *cell = (ISHomeTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.homeCollectionView.tag = indexPath.section+100;

    if (indexPath.section == 0)
    {
        cell.backgroundColor = [UIColor whiteColor];
        [cell.homeCollectionView registerNib:[UINib nibWithNibName:@"ISHomeCollectionCells"bundle:nil]forCellWithReuseIdentifier:@"ISHomeCollectionCells"];
        if (self.popularStoresdataArray.count > 2)
        {
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
            flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            cell.homeCollectionView.collectionViewLayout = flowLayout;
        }
        [cell.homeCollectionView setBackgroundColor:[UIColor whiteColor]];
    }
    else
    {
        [cell.homeCollectionView registerNib:[UINib nibWithNibName:@"ISFeaturedCololectionCell"bundle:nil]forCellWithReuseIdentifier:@"ISFeaturedCololectionCell"];
        [cell.homeCollectionView setBackgroundColor:[UIColor colorWithRed:241/255.0f green:244/255.0f blue:247/255.0f alpha:1.0f]];
    }
    cell.homeCollectionView.delegate = self;
    cell.homeCollectionView.dataSource = self;
    [cell.homeCollectionView reloadData];

    return cell;
}

#pragma mark - collectionView Delgate and DataSource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    if (view == self.homeHeaderCollectionView)
    {
        return self.imageDataArray.count;
    }
    else if (view.tag == 100)
    {
        return self.popularStoresdataArray.count;
    }
    else
    {
       return self.trendingItemsdataArray.count;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    collectionView.scrollEnabled = YES;
    if (collectionView == self.homeHeaderCollectionView)
    {
        ISBuyCollectionCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ISBuyCollectionCell" forIndexPath:indexPath];
        
        ISUserInfo * imageInfo = [self.imageDataArray objectAtIndex:indexPath.item];
        [cell.buyProductImageView sd_setImageWithURL:[NSURL URLWithString:imageInfo.image] placeholderImage:[UIImage imageNamed:@"image-not-available"] options:SDWebImageProgressiveDownload];
         return cell;
    }
    else if (collectionView.tag == 100)
    {
        ISHomeCollectionCells  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ISHomeCollectionCells" forIndexPath:indexPath];
        
        ISUserInfo * storeInfo = [self.popularStoresdataArray objectAtIndex:indexPath.item];
        [cell.imageView_logo sd_setImageWithURL:[NSURL URLWithString:storeInfo.store_logo] placeholderImage:[UIImage imageNamed:@"image-not-available"] options:SDWebImageProgressiveDownload];
        [cell.imageView_background sd_setImageWithURL:[NSURL URLWithString:storeInfo.store_background] placeholderImage:[UIImage imageNamed:@"image-not-available"] options:SDWebImageProgressiveDownload];
        [cell.label_storeName setText:storeInfo.store_name];
        [cell.label_productCount setText:[NSString stringWithFormat:@"%@ Products",storeInfo.item_count]];
        [cell.itemOneBtn addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
        [cell.itemTwoBtn addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
        [cell.itemThreeBtn addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
        [cell.itemFourBtn addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
        [cell showProductImageWithData:storeInfo.buyersDataArray];
        return cell;
    }
    else
    {
        ISFeaturedCololectionCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ISFeaturedCololectionCell" forIndexPath:indexPath];
        collectionView.scrollEnabled = NO;
        ISUserInfo * storeInfo = [self.trendingItemsdataArray objectAtIndex:indexPath.item];
        [cell.label_StoreName setText:storeInfo.store_name];
        [cell.label_ProductName setText:storeInfo.title];
        [cell.label_PricelLabel setText:[NSString stringWithFormat:@"$%@", storeInfo.price]];
        [cell.imageview_ProductImage sd_setImageWithURL:[NSURL URLWithString:storeInfo.image] placeholderImage:[UIImage imageNamed:@"image-not-available"] options:SDWebImageProgressiveDownload];

         return cell;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.homeHeaderCollectionView)
    {
        return CGSizeMake(collectionView.frame.size.width, 230);
    }
    else if (collectionView.tag == 100)
    {
        return CGSizeMake(collectionView.frame.size.width/2, 230);
    }
    else
    {
        return CGSizeMake(collectionView.frame.size.width/2-5, 234);
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView == self.homeHeaderCollectionView)
    {
    }
    else if (collectionView.tag == 100)
    {
        ISUserInfo *obj = [_popularStoresdataArray objectAtIndex:indexPath.item];
        ISDetailContainerVC *storeVC = [[ISDetailContainerVC alloc] initWithNibName:@"ISDetailContainerVC" bundle:nil];
        storeVC.storeId = [NSString stringWithFormat:@"%ld",(unsigned long)obj.id ];
        [self.navigationController pushViewController:storeVC animated:YES];
    }
    else
    {
        ISUserInfo * storeInfo = [self.trendingItemsdataArray objectAtIndex:indexPath.item];
        ISCollectionsContainerVC *storeVC = [[ISCollectionsContainerVC alloc] initWithNibName:@"ISCollectionsContainerVC" bundle:nil];
        [storeVC setIsForItemDetail:YES];
        [storeVC setItemId:[NSString stringWithFormat:@"%lu", (unsigned long)storeInfo.id]];
        [self.navigationController pushViewController:storeVC animated:YES];
    }
}
#pragma mark - uibutton Action

- (void)showDetail:(UIButton *)sender{

    ISHomeCollectionCells * cell = (ISHomeCollectionCells *)[[[[sender superview] superview] superview] superview];
    UICollectionView * collectionView = (UICollectionView *)[self.tableView_collections viewWithTag:100];
    NSIndexPath *indexPath;
    if (collectionView) {
        indexPath = [collectionView indexPathForCell:cell];
        ISUserInfo * storeInfo = [self.popularStoresdataArray objectAtIndex:indexPath.item];
        ISUserInfo * itemInfo = [storeInfo.buyersDataArray objectAtIndex:sender.tag%2000];
        ISCollectionsContainerVC *storeVC = [[ISCollectionsContainerVC alloc] initWithNibName:@"ISCollectionsContainerVC" bundle:nil];
        [storeVC setIsForItemDetail:YES];
        [storeVC setItemId:[NSString stringWithFormat:@"%lu", (unsigned long)itemInfo.id]];
        [self.navigationController pushViewController:storeVC animated:YES];
    }
}
-(void)seeAllAction:(UIButton *)sender
{
    ISShopByStoreContainorVC * containerVC = [[ISShopByStoreContainorVC alloc] initWithNibName:@"ISShopByStoreContainorVC" bundle:nil];
    containerVC.categoryId = @"";
    [self.navigationController pushViewController:containerVC animated:YES];
}
- (IBAction)Changed:(id)sender
{
    UIPageControl *pageControl = sender;
    CGFloat pageWidth = self.homeHeaderCollectionView.frame.size.width;
    CGPoint scrollTo = CGPointMake(pageWidth * pageControl.currentPage, 0);
    [self.homeHeaderCollectionView setContentOffset:scrollTo animated:YES];
}
#pragma mark Delegate Method of ScrollView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((self.homeHeaderCollectionView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
}

#pragma mark - Scroll View Delegate Methods

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (currentOffset - maximumOffset >= SCROLLUPREFRESHHEIGHT) {
        
        if (self.pagination.total_pages > pageNumber) {
            pageNumber++;
            [self makeWebApiCallToGetResult:pageNumber];
        }
    }
}
- (IBAction)walletButtonAction:(id)sender {
    
    ISWalletVC *walletVC = [[ISWalletVC alloc] initWithNibName:@"ISWalletVC" bundle:nil];
    [self.navigationController pushViewController:walletVC animated:YES];
}

- (IBAction)searchButtonAction:(id)sender
{
    ISAddToDropContainerVC * uploadVC = [[ISAddToDropContainerVC alloc] initWithNibName:@"ISAddToDropContainerVC" bundle:nil];
    [self.navigationController pushViewController:uploadVC animated:YES];
}


#pragma mark - Web Service Method

-(void)makeWebApiCallToGetResult:(NSInteger)page
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    [[ISServiceHelper helper] request:param apiName:[NSString stringWithFormat:@"stores/home?page=%ld", (long)page] method:GET completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             [self.tableView_collections setHidden:NO];
             if (error == nil) {
                 
                 if (pageNumber == 1) {
                     [self.imageDataArray removeAllObjects];
                     [self.popularStoresdataArray removeAllObjects];
                     [self.trendingItemsdataArray removeAllObjects];
                     self.imageDataArray = [self parseSliderImageData:[resultDict objectForKeyNotNull:kSlider expectedObj:[NSArray array]]];
                     self.popularStoresdataArray = [self parsePopularStoresData:[resultDict objectForKeyNotNull:kPopular_Stores expectedObj:[NSArray array]]];
                 }

                 [self.trendingItemsdataArray addObjectsFromArray:[self parseTrendingItemsData:[resultDict objectForKeyNotNull:kTrending_Items expectedObj:[NSArray array]]]];
                 self.pagination = [ISPagination parseDataFromDict:[resultDict objectForKeyNotNull:@"page_detail" expectedObj:[NSDictionary dictionary]]];

                 [self.tableView_collections reloadData];
                 [self.homeHeaderCollectionView reloadData];
             }
             else{
                 
                 [self showErrorAlertWithTitle:[error localizedDescription]];
             }
         });
     }];
}

-(NSMutableArray *)parseSliderImageData:(NSArray *)imageArray
{
    NSMutableArray *dropArray = [NSMutableArray array];
    for (NSDictionary *dic in imageArray)
    {
        ISUserInfo *imageInfo = [ISUserInfo parseDataFromDict:dic];
        [dropArray addObject:imageInfo];
    }
    return dropArray;
}
-(NSMutableArray*)parsePopularStoresData:(NSArray *)popularArray
{
    NSMutableArray *popularStoresArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic  in popularArray)
    {
        ISUserInfo *productInfo = [ISUserInfo parseDataFromDict:dic];
        [productInfo setBuyersDataArray:[self parseSliderImageData:[dic objectForKeyNotNull:kItems expectedObj:[NSArray array]]]];
        [popularStoresArray addObject:productInfo];
    }
    return popularStoresArray;
}

-(NSMutableArray*)parseTrendingItemsData:(NSArray *)itemsArray
{
    NSMutableArray *popularStoresArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic  in itemsArray)
    {
        ISUserInfo *productInfo = [ISUserInfo parseDataFromDict:dic];
        [popularStoresArray addObject:productInfo];
    }
    return popularStoresArray;
}
-(void)showErrorAlertWithTitle:(NSString*)error{
    [[AlertView sharedManager] presentAlertWithTitle:@"" message:error  andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {}];
}

@end
