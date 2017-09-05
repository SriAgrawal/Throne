//
//  ISAddToDropViewController.m
//  Throne
//
//  Created by Ankurgupta148 on 04/08/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISAddToDropViewController.h"

@interface ISAddToDropViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,ISLogoutPopupDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    int count, likePageNumber, recentlyPageNumber, lastRecentlyPageNumber, lastLikePageNumber;
    BOOL isSearch, isFirstTimeLoading;
    ISUserInfo * userInfo,*selectInfo;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
;
@property (weak, nonatomic) IBOutlet UITableView *uploadListTableView;
@property (strong, nonatomic) NSMutableArray     * uploadListData;

@property (strong, nonatomic) UIRefreshControl  * refreshControl;
@property (strong, nonatomic) ISPagination      * recentlyPagination;
@property (strong, nonatomic) ISPagination      * likePagination;

@property (strong, nonatomic) NSMutableArray *arrayRecentView;
@property (strong, nonatomic) NSMutableArray *arrayLikeView;
@end
@implementation ISAddToDropViewController

#pragma mark-View Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
      [self initialMethod];
    [self makeApiCallToGetResult];
}
#pragma mark-Memory warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-cell Initilize Method
-(void)initialMethod
{
    userInfo = [[ISUserInfo alloc] init];
    
    UINib *cellNib = [UINib nibWithNibName:@"ISSeachTableCell" bundle:nil];
    [self.uploadListTableView registerNib:cellNib forCellReuseIdentifier:@"ISSeachTableCell"];

    self.arrayRecentView = [[NSMutableArray alloc] init];
    self.arrayLikeView = [[NSMutableArray alloc] init];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.uploadListTableView addSubview:self.refreshControl];
    recentlyPageNumber = 1;
    likePageNumber = 1;
    lastRecentlyPageNumber = 0;
    lastLikePageNumber = 0;
    isFirstTimeLoading = YES;
}
- (void) dismissKeyboard
{   [self.view endEditing:YES];
}

- (void)handleRefresh:(UIRefreshControl *)refreshControl {
    
    [self.uploadListTableView reloadData];
    [self.uploadListTableView layoutIfNeeded];
    [refreshControl endRefreshing];
    recentlyPageNumber = 1;
    likePageNumber = 1;
    lastRecentlyPageNumber = 0;
    lastLikePageNumber = 0;
    isFirstTimeLoading = YES;
}

#pragma mark- UITableViewDataSource and Delegate Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
      return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ISSeachTableCell  *cell = (ISSeachTableCell *)[tableView dequeueReusableCellWithIdentifier:@"ISSeachTableCell"];
    
    cell.button_SeaAll.hidden = YES;
    cell.labelCellHeader.text = [@[@"Recently Viewed",@"You May Like"] objectAtIndex:indexPath.row];
    [cell.homeCollectionView registerNib:[UINib nibWithNibName:@"ISFeaturedCololectionCell"bundle:nil]forCellWithReuseIdentifier:@"ISFeaturedCololectionCell"];
    cell.homeCollectionView.delegate = self;
    cell.homeCollectionView.dataSource = self;
    cell.homeCollectionView.tag = indexPath.row+100;
    [cell.homeCollectionView reloadData];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
}
#pragma mark - UICollectionViewDelegate and UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   return (collectionView.tag == 100)? _arrayRecentView.count : _arrayLikeView.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ISFeaturedCololectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ISFeaturedCololectionCell" forIndexPath:indexPath];
    
    ISUserInfo *infoObj = (collectionView.tag == 100)? [_arrayRecentView objectAtIndex:indexPath.item]:[_arrayLikeView objectAtIndex:indexPath.item];
    
    [cell.imageview_ProductImage sd_setImageWithURL:[NSURL URLWithString:infoObj.image] placeholderImage:[UIImage imageNamed:@"image-not-available"] options:SDWebImageProgressiveDownload];
    cell.label_ProductName.text = infoObj.title;
    cell.label_PricelLabel.text = [NSString stringWithFormat:@"$%ld",(long)[infoObj.price integerValue]];
    cell.label_StoreName.text = infoObj.store_name;
    
    CGSize offset = CGSizeMake(2, 1);
    
    cell.view_Subview.layer.shadowOffset =  offset;
    cell.view_Subview.layer.shadowOpacity = 0.4;
    cell.view_Subview.layer.shadowRadius = 10.0;
    [cell.view_Subview.layer setMasksToBounds:NO];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width/2-10,collectionView.frame.size.height);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ISUserInfo *info;
    if (collectionView.tag == 100)
        info = [_arrayRecentView objectAtIndex:indexPath.item];
    else
        info = [_arrayLikeView objectAtIndex:indexPath.item];
    ISCollectionsContainerVC *shopVC = [[ISCollectionsContainerVC alloc] initWithNibName:@"ISCollectionsContainerVC" bundle:nil];
    [shopVC setIsForItemDetail:YES];
    shopVC.itemId = [NSString stringWithFormat:@"%d",(int)info.id];
    [self.navigationController pushViewController:shopVC animated:YES];
}

#pragma mark- IBAction

- (void)doneBtnAction:(id)sender{
    
    
}

#pragma mark- Scrollable delegate Method

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    UICollectionView * collectionView = (UICollectionView *)scrollView;
    isFirstTimeLoading = NO;
    if ((collectionView.tag == 100)) {
        CGFloat currentOffset = scrollView.contentOffset.x;
        CGFloat maximumOffset = scrollView.contentSize.width - scrollView.frame.size.width;
        
        if (currentOffset - maximumOffset >= SCROLLUPREFRESHHEIGHT) {
            lastRecentlyPageNumber = recentlyPageNumber;
            if (self.recentlyPagination.total_pages > recentlyPageNumber) {
                recentlyPageNumber++;
                [self makeApiCallToGetResult];
            }
        }
    }
    else{
        CGFloat currentOffset = scrollView.contentOffset.x;
        CGFloat maximumOffset = scrollView.contentSize.width - scrollView.frame.size.width;
        
        if (currentOffset - maximumOffset >= SCROLLUPREFRESHHEIGHT) {
            lastLikePageNumber = likePageNumber;
            if (self.likePagination.total_pages > likePageNumber) {
                likePageNumber++;
                [self makeApiCallToGetResult];
            }
        }
    }
}
#pragma mark - Web Service Method For Signup
-(void)makeApiCallToGetResult
{
    NSString *apiSearchName = [NSString stringWithFormat:@"items/item_search?recent_view_page=%d&similar_item_page=%d", recentlyPageNumber, likePageNumber];
    
    [[ISServiceHelper helper] request:nil apiName:apiSearchName method:GET completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{

             if (error == nil) {
                 NSDictionary * recentlyPageDetailDict = [resultDict objectForKeyNotNull:@"recent_view_page" expectedObj:[NSDictionary dictionary]];
                 NSDictionary * likePageDetailDict = [resultDict objectForKeyNotNull:@"similar_item_page" expectedObj:[NSDictionary dictionary]];
                 self.recentlyPagination = [ISPagination parseDataFromDict:[recentlyPageDetailDict objectForKeyNotNull:@"page_detail" expectedObj:[NSDictionary dictionary]]];
                 self.likePagination = [ISPagination parseDataFromDict:[likePageDetailDict objectForKeyNotNull:@"page_detail" expectedObj:[NSDictionary dictionary]]];

                 if (isFirstTimeLoading) {
                     [self.arrayRecentView removeAllObjects];
                     [self.arrayLikeView removeAllObjects];
                 }
             }
              [self parseFilterData:resultDict];
             
             lastRecentlyPageNumber = recentlyPageNumber;
             lastLikePageNumber = likePageNumber;

             [self.uploadListTableView reloadData];
         });
     }];
}
-(void)parseFilterData:(NSDictionary *)filterProductData
{
    NSMutableArray *arrayRecentType = [filterProductData valueForKey:@"recent_views"];
    for ( NSDictionary *dic in arrayRecentType)
    {
        ISUserInfo *recentItem = [ISUserInfo parseDataFromDict:dic];
        if (lastRecentlyPageNumber < recentlyPageNumber)
            [_arrayRecentView addObject:recentItem];
    }
    
    NSMutableArray *arrayLikeType = [filterProductData valueForKey:@"similar_items"];
    for ( NSDictionary *dic in arrayLikeType)
    {
        ISUserInfo *likeItem = [ISUserInfo parseDataFromDict:dic];
        if (lastLikePageNumber < likePageNumber)
            [_arrayLikeView addObject:likeItem];
    }
}
-(void)didSelectData:(NSString*)strText
{
    selectInfo.string_itemSort = strText;
    //[self makeApiCallToSearch:pageNumber];
}

@end
