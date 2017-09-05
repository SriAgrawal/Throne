//
//  ISBrandDetailsVC.m
//  Throne
//
//  Created by Shridhar Agarwal on 15/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISBrandDetailsVC.h"
#import "Header.h"


@interface ISBrandDetailsVC ()<sortVCDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>
{
    NSInteger selectedTag;
    ISUserInfo *modalObj;
    NSMutableArray *dataSourceArray;
    int pageNumber;
    BOOL isDoneHide;
}
@property (strong, nonatomic) IBOutlet UIImageView *conditionArrowImage;
@property (strong, nonatomic) IBOutlet UIImageView *colorArrowImage;
@property (strong, nonatomic) IBOutlet UIImageView *brandArrowImage;
@property (strong, nonatomic) IBOutlet UIImageView *sizeArrowImage;
@property (strong, nonatomic) IBOutlet UIImageView *downArrowImage;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UITableView *sizeTableView;

@property (strong, nonatomic) IBOutlet UIView *sizeTableHeaderView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *containerBottomCons;
@property (strong, nonatomic) IBOutlet UITableView *tableViewCategoryDetails;

@property (strong, nonatomic) IBOutlet UILabel *sizeLbl;
@property (strong, nonatomic) IBOutlet UILabel *brandLbl;
@property (strong, nonatomic) IBOutlet UILabel *colorLbl;
@property (strong, nonatomic) IBOutlet UILabel *conditionLbl;

@property (strong, nonatomic) NSMutableArray *arrayCondition;
@property (strong, nonatomic) NSMutableArray *arraySizeItems;
@property (strong, nonatomic) NSMutableArray *arrayColors;
@property (strong, nonatomic) NSMutableArray *arrayBrands;
@property (strong, nonatomic) NSMutableArray *arrayGender;

@property (strong, nonatomic) UIRefreshControl  * refreshControl;
@property (strong, nonatomic) ISPagination      * pagination;

@property (strong, nonatomic) NSMutableArray        * popularStoresdataArray;
@property (strong, nonatomic) NSMutableArray        * trendingItemsdataArray;

@end

@implementation ISBrandDetailsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [ self apiCallForSelection];
    [self initialSetUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FireNotificationToSelectSizeTable" object:nil];
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}

-(void)initialSetUp
{
    self.containerBottomCons.constant = WIN_HEIGHT-self.containerView.frame.origin.y;
    [self.sizeTableView setHidden:YES];
    [self.tableViewCategoryDetails setHidden:YES];
    self.popularStoresdataArray = [[NSMutableArray alloc] init];
    self.trendingItemsdataArray = [[NSMutableArray alloc] init];
    modalObj = [[ISUserInfo alloc] init];
    self.arrayBrands = [[NSMutableArray alloc] init];
    self.arrayColors = [[NSMutableArray alloc] init];
    self.arraySizeItems = [[NSMutableArray alloc] init];
    dataSourceArray = [[NSMutableArray alloc] init];
    self.arrayGender = [[NSMutableArray alloc] init];

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableViewCategoryDetails addSubview:self.refreshControl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSizeTable:) name:@"FireNotificationToSelectSizeTable" object:nil];
    
    [self.sizeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ISFilterCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ISFilterCell class])];
  //  [self.sizeTableView setTableHeaderView:self.sizeTableHeaderView];
    
    [self.tableViewCategoryDetails registerNib:[UINib nibWithNibName:@"ISHomeTableCell" bundle:nil] forCellReuseIdentifier:@"ISHomeTableCell"];
    
    [self.tableViewCategoryDetails registerNib:[UINib nibWithNibName:NSStringFromClass([ISSeactionHeaderCell class]) bundle:nil] forHeaderFooterViewReuseIdentifier:@"ISSeactionHeaderCell"];
    
    self.sizeTableView.delegate = self;
    self.sizeTableView.dataSource = self;
}

- (void)handleRefresh:(UIRefreshControl *)refreshControl {
    
    [refreshControl endRefreshing];
    pageNumber = 1;
    [self makeWebApiCallToGetSearchResult:1];
}

-(void)showSizeTable:(NSNotification *)notificationInfo{
    
    NSDictionary * dict = notificationInfo.object;
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = [[dict objectForKey:@"buttonTag"] intValue];
    button.selected = [[dict objectForKey:@"select"] boolValue];
    [self commonBtnAction:button];
}

#pragma mark - TableView Delegate and DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.tableViewCategoryDetails)
        return 2;
    else
        return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.sizeTableView)
    {
        switch (selectedTag)
        {
            case 1:
                return self.arraySizeItems.count;
                break;
            case 2:
                return self.arrayCondition.count;
                break;
            case 3:
                return self.arrayBrands.count;
                break;
            case 4:
                return self.arrayColors.count;
                break;
            case 5:
                return self.arrayGender.count;
                break;
            default:
                return dataSourceArray.count;
        }
    }
    else
    {
        if (section)
            return self.trendingItemsdataArray.count ? 1 : 0;
        else
            return self.popularStoresdataArray.count ? 1 : 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.sizeTableView)
     return 50.0f;
    else{
        if(indexPath.section == 1)
            return (self.trendingItemsdataArray.count/2 + self.trendingItemsdataArray.count%2)*235+40;
        else
            return 230.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.sizeTableView)
        if (isDoneHide) {
            return 0;
        }else
        return 30.0;
    else
        return 60.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.sizeTableView){
        
        UIView *bView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH, 30)];
        UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIN_WIDTH-80, 10, 80, 20)];
        [doneBtn setTitleColor:[UIColor colorWithRed:173/255.0f green:141/255.0f blue:69/255.0f alpha:1.0] forState:UIControlStateNormal];
        [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(doneBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [bView addSubview:doneBtn];
        return bView;
        
    }else{
    ISSeactionHeaderCell *sectionHeaderCell = (ISSeactionHeaderCell *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ISSeactionHeaderCell"];
    
    //Custom section header view
    
    sectionHeaderCell.seactionLbl.text = [@[@"Popular Stores",@"Trending items"] objectAtIndex:section];
    sectionHeaderCell.seactionLbl.font = NEO_SANS_PRO_REGULAR(15);
    [sectionHeaderCell.seeAllBtn addTarget:self action:@selector(seeAllAction:) forControlEvents:UIControlEventTouchUpInside];
    sectionHeaderCell.seeAllBtn.hidden = (section == 1)?YES:NO;
    return sectionHeaderCell;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.sizeTableView)
    {
        ISFilterCell *cell = (ISFilterCell *)[self.sizeTableView dequeueReusableCellWithIdentifier:NSStringFromClass([ISFilterCell class])];
        cell.backgroundColor = [UIColor clearColor];
        switch (selectedTag)
        {
            case 1:
            {
               ISUserInfo* modalSizeObj =[self.arraySizeItems objectAtIndex:indexPath.row];
                cell.filterLbl.text = modalSizeObj.string_itemSize;
                cell.checkImageView.hidden = (modalSizeObj.isSelected == NO)? YES: NO;
            }
                break;
            case 2:{
                ISUserInfo* modalCondtionObj =[self.arrayCondition objectAtIndex:indexPath.row];
                    cell.filterLbl.text = modalCondtionObj.string_itemCondition;
                    cell.checkImageView.hidden = (modalCondtionObj.isSelected == NO)? YES: NO;
           }
                break;
            case 3:
            {
               ISUserInfo* modalBrandObj =[self.arrayBrands objectAtIndex:indexPath.row];
                cell.filterLbl.text = modalBrandObj.string_Product_Name;
                cell.checkImageView.hidden = (modalBrandObj.isSelected == NO)? YES: NO;
            }
                break;
            case 4:
            {
               ISUserInfo* modalColorObj =[self.arrayColors objectAtIndex:indexPath.row];
                cell.filterLbl.text = modalColorObj.string_itemColor;
                cell.checkImageView.hidden = (modalColorObj.isSelected == NO)? YES: NO;
            }
                break;
            case 5:
            {
                ISUserInfo* modalGenderObj =[self.arrayGender objectAtIndex:indexPath.row];
                cell.filterLbl.text = modalGenderObj.string_gender;
                cell.checkImageView.hidden = (modalGenderObj.isSelected == NO)? YES: NO;
            }
                break;
            default:
                break;
        }
        
        return  cell;
    }
    else
    {
        ISHomeTableCell *cell = (ISHomeTableCell *)[tableView dequeueReusableCellWithIdentifier:@"ISHomeTableCell"];
        
        if (indexPath.section == 0)
        {
            cell.backgroundColor = [UIColor whiteColor];
            [cell.homeCollectionView registerNib:[UINib nibWithNibName:@"ISHomeCollectionCells"bundle:nil]forCellWithReuseIdentifier:@"ISHomeCollectionCells"];
            if (self.popularStoresdataArray.count > 2) {
                UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
                flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
                cell.homeCollectionView.collectionViewLayout = flowLayout;
            }
        
            cell.homeCollectionView.tag = indexPath.section+100;
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
}

#pragma mark - collectionView Delgate and DataSource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
   if (view.tag == 100)
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
    if (collectionView.tag == 100)
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
 
    if (collectionView.tag == 100)
        return CGSizeMake(collectionView.frame.size.width/2 - 5, 230);
    else
        return CGSizeMake(collectionView.frame.size.width/2 - 5, 234);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView.tag == 100)
    {
        ISUserInfo * storeInfo = [self.popularStoresdataArray objectAtIndex:indexPath.item];
        ISDetailContainerVC *storeVC = [[ISDetailContainerVC alloc] initWithNibName:@"ISDetailContainerVC" bundle:nil];
        [storeVC setStoreId:[NSString stringWithFormat:@"%lu", (unsigned long)storeInfo.id]];
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
- (void)doneBtnAction:(UIButton *)sender {
    _headerView.genderArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
    _headerView.conditionArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
    _headerView.brandArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
    _headerView.colorArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
    _headerView.sizeArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
    [self closedAnimation];
    pageNumber = 1;
    [self makeWebApiCallToGetSearchResult:1];
}
- (void)showDetail:(UIButton *)sender{
    
    ISHomeCollectionCells * cell = (ISHomeCollectionCells *)[[[[sender superview] superview] superview] superview];
    UICollectionView * collectionView = (UICollectionView *)[self.tableViewCategoryDetails viewWithTag:100];
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
    containerVC.categoryId = self.categoryId;
    [self.navigationController pushViewController:containerVC animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    switch (selectedTag)
    {
        case 0:
            
            modalObj.string_itemSort = @"";

            break;
        case 1:{
           ISUserInfo* modalSizeObj =[_arraySizeItems objectAtIndex:indexPath.row];
            modalSizeObj.isSelected = !modalSizeObj.isSelected;
            self.headerView.sizeLbl.text = modalSizeObj.string_itemSize;
            if ([[modalSizeObj.string_itemSize lowercaseString] isEqualToString:[@"All" lowercaseString]] && indexPath.row == 0)
            {
                for (int all = 0; all < _arraySizeItems.count ;all++) {
                    ISUserInfo* obj = [_arraySizeItems objectAtIndex:all];
                    if (all == 0) {
                        obj.item_id = @"";
                        obj.isSelected = YES;
                    }
                    else
                        obj.isSelected = NO;
                }
            }else{
                ISUserInfo* obj = [_arraySizeItems objectAtIndex:0];
                obj.isSelected = NO;
            }
            [self.sizeTableView reloadData];
        }
            break;
        case 2:
        {
            ISUserInfo* conditionInfo = [self.arrayCondition objectAtIndex:indexPath.row];
            
            if ([[conditionInfo.string_itemCondition lowercaseString] isEqualToString:[@"New" lowercaseString]])
            {
                conditionInfo.isSelected = !conditionInfo.isSelected;
                self.headerView.conditionLbl.text = @"New";
            }
            else if ([[conditionInfo.string_itemCondition lowercaseString] isEqualToString:[@"Used" lowercaseString]])
            {conditionInfo.isSelected = !conditionInfo.isSelected;
                self.headerView.conditionLbl.text = @"Used";
            }
            else
            {
                conditionInfo.isSelected = !conditionInfo.isSelected;
                self.headerView.conditionLbl.text = @"All";
            }
            _headerView.genderArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            _headerView.conditionArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            _headerView.brandArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            _headerView.colorArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            _headerView.sizeArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            [self closedAnimation];
            pageNumber = 1;
            [self makeWebApiCallToGetSearchResult:1];
        }
            break;
        case 3:
        {
           ISUserInfo* modalBrandObj =[_arrayBrands objectAtIndex:indexPath.row];
            modalBrandObj.isSelected = !modalBrandObj.isSelected;
            self.headerView.brandLbl.text = modalBrandObj.string_Product_Name;
            if ([[modalBrandObj.string_Product_Name lowercaseString] isEqualToString:[@"All" lowercaseString]]){
                for (int all = 0; all < _arrayBrands.count ;all++) {
                     ISUserInfo* obj = [_arrayBrands objectAtIndex:all];
                    if (all == 0) {
                        obj.string_Product_Id = @"";
                        obj.isSelected = YES;
                    }
                    else
                        obj.isSelected = NO;
                }
            }
            else{
                ISUserInfo* obj = [_arrayBrands objectAtIndex:0];
                obj.isSelected = NO;
            }
            [self.sizeTableView reloadData];
        }
            break;
        case 4:
        {
           ISUserInfo* modalColorObj =[_arrayColors objectAtIndex:indexPath.row];
            modalColorObj.isSelected = !modalColorObj.isSelected;
            self.headerView.colorLbl.text = modalColorObj.string_itemColor;
            if ([[modalColorObj.string_itemColor lowercaseString] isEqualToString:[@"All" lowercaseString]]){
                for (int all = 0; all < _arrayColors.count ;all++) {
                     ISUserInfo* obj = [_arrayColors objectAtIndex:all];
                    if (all == 0) {
                        obj.store_id = @"";
                        obj.isSelected = YES;
                    }
                    else
                        obj.isSelected = NO;
                }
            }
            else{
                ISUserInfo* obj = [_arrayColors objectAtIndex:0];
                obj.isSelected = NO;
            }
            
            [self.sizeTableView reloadData];
        }

            break;
        case 5:{
            ISUserInfo* obj = [self.arrayGender objectAtIndex:indexPath.row];
            
            if ([[obj.string_gender lowercaseString] isEqualToString:[@"Male" lowercaseString]])
            {
                self.headerView.genderLbl.text = @"Male";
                obj.isSelected = !obj.isSelected;
                obj.string_gender = @"Male";
            }
            else
            {  obj.isSelected = !obj.isSelected;
                obj.string_gender = @"Female";
                self.headerView.genderLbl.text = @"Female";
            }
            _headerView.genderArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            _headerView.conditionArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            _headerView.brandArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            _headerView.colorArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            _headerView.sizeArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            [self closedAnimation];
            pageNumber = 1;
            [self makeWebApiCallToGetSearchResult:1];
        }
            break;
        default:
            break;
    }
    
}
- (IBAction)backBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)commonBtnAction:(UIButton *)sender
{
    isDoneHide = NO;
    switch (sender.tag)
    {
        case 100:
        {
            [self closedAnimation];
            _headerView.genderArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            _headerView.conditionArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            _headerView.brandArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            _headerView.colorArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            _headerView.sizeArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
            ISSortVC *sortVC = [[ISSortVC alloc] init];
            sortVC.delegate = self;
            sortVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:sortVC animated:YES completion:nil];
        }
            break;
        case 101:
        {
            if (sender.selected == NO)
            {
                _headerView.sizeArrowImage.image = [UIImage imageNamed:@"ico_disclosure_up"];
                _headerView.conditionArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.brandArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.colorArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.genderArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                [self setUpAnimation];
            }
            else
            {
                _headerView.sizeArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                [self closedAnimation];
            }
            selectedTag = 1;
            [self.sizeTableView reloadData];
        }
            break;
        case 102:
        {
            isDoneHide = YES;
            if (sender.selected == NO)
            {
                _headerView.conditionArrowImage.image = [UIImage imageNamed:@"ico_disclosure_up"];
                _headerView.genderArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.brandArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.colorArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.sizeArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                [self setUpAnimation];
            }
            else
            {
                _headerView.conditionArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                [self closedAnimation];
            }
            selectedTag = 2;
            [self.sizeTableView reloadData];
        }
            break;
        case 103:
        {
            if (sender.selected == NO)
            {
                _headerView.brandArrowImage.image = [UIImage imageNamed:@"ico_disclosure_up"];
                _headerView.genderArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.conditionArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.colorArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.sizeArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                [self setUpAnimation];
            }
            else
            {
                _headerView.brandArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                [self closedAnimation];
            }
            selectedTag = 3;
            [self.sizeTableView reloadData];
        }
            break;
        case 104:
        {
            if (sender.selected == NO)
            {
                _headerView.colorArrowImage.image = [UIImage imageNamed:@"ico_disclosure_up"];
                _headerView.genderArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.conditionArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.brandArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.sizeArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                [self setUpAnimation];
            }
            else
            {
                _headerView.colorArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                [self closedAnimation];
            }
            selectedTag = 4;
            [self.sizeTableView reloadData];
        }
            break;
        case 105:
        {
            //self.sizeTableHeaderView.hidden = YES;
            isDoneHide = YES;
            if (sender.selected == NO)
            {
                _headerView.genderArrowImage.image = [UIImage imageNamed:@"ico_disclosure_up"];
                _headerView.conditionArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.brandArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.sizeArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                _headerView.colorArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                [self setUpAnimation];
            }
            else
            {
                _headerView.genderArrowImage.image = [UIImage imageNamed:@"ico_disclosure_down"];
                [self closedAnimation];
            }
            selectedTag = 5;
            [self.sizeTableView reloadData];
        }
            break;
            
        default:
            break;
    }
}
//Setup the animation
-(void)setUpAnimation
{
    self.containerBottomCons.constant = 0.0;
    [self.sizeTableView setHidden:NO];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}
-(void)closedAnimation
{
    self.containerBottomCons.constant = WIN_HEIGHT-self.containerView.frame.origin.y;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Scroll View Delegate Methods
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (currentOffset - maximumOffset >= SCROLLUPREFRESHHEIGHT) {
        
        if (self.pagination.total_pages > pageNumber) {
            pageNumber++;
            [self makeWebApiCallToGetSearchResult:pageNumber];
        }
    }
}

#pragma mark - Web Service Method For Signup

-(void)apiCallForSelection
{
    [[ISServiceHelper helper] request:nil apiName:[NSString stringWithFormat:@"stores/filterlist_bycategory?category_id=%@", self.categoryId] method:GET completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             pageNumber = 1;
             [self makeWebApiCallToGetSearchResult:1];
             if (error == nil) {
                 
                 [_arrayColors removeAllObjects];
                 [_arraySizeItems removeAllObjects];
                 [_arrayBrands removeAllObjects];
                 [_arrayCondition removeAllObjects];
                 [_arrayGender removeAllObjects];
                 [self parseFilterData:[resultDict objectForKeyNotNull:@"filter" expectedObj:[NSDictionary dictionary]]];
                 [self.sizeTableView reloadData];
             }
        });
     }];
}

-(void)makeWebApiCallToGetSearchResult:(NSInteger)page{
    
    NSMutableDictionary *paramItem = [[NSMutableDictionary alloc] init];
//====================Item Array
    NSMutableArray* brandItemArray = [[NSMutableArray alloc] init];
    for(ISUserInfo* sizeInfo in _arrayBrands){
        if (sizeInfo.isSelected) {
            [brandItemArray addObject:sizeInfo.string_Product_Id];
        }
    }
    [paramItem setValue:brandItemArray forKey:@"brand_id_in"];
    
    [paramItem setValue:self.categoryId forKey:@"category_id_eq"];
   
    NSMutableArray* colorItemArray = [[NSMutableArray alloc] init];
    for(ISUserInfo* sizeInfo in _arrayColors){
        if (sizeInfo.isSelected) {
            [colorItemArray addObject:sizeInfo.store_id];
        }
    }
    [paramItem setValue:colorItemArray forKey:@"color_id_in"];
    
    if ([modalObj.string_itemCondition isEqualToString:@"New"]) {
         [paramItem setValue:@"0" forKey:@"condition_eq"];
    }
   else if ([modalObj.string_itemCondition isEqualToString:@"Used"]) {
        [paramItem setValue:@"1" forKey:@"condition_eq"];
    }
    else {
        [paramItem setValue:@"" forKey:@"condition_eq"];
    }
    [paramItem setValue: ([modalObj.string_gender isEqualToString:@"Male"]?@"0":@"1") forKey:@"gender_eq"];
    
    NSMutableArray* sizeItemArray = [[NSMutableArray alloc] init];
    
    for(ISUserInfo* sizeInfo in _arraySizeItems){
        if (sizeInfo.isSelected) {
            [sizeItemArray addObject:sizeInfo.item_id];
        }
    }
    [paramItem setValue:sizeItemArray forKey:@"size_id_in"];
    [paramItem setValue:modalObj.string_itemSort forKey:@"s"];
    [paramItem setValue:@"" forKey:@"title_cont"];
    
//====================Store Array
    NSMutableDictionary *paramStore = [[NSMutableDictionary alloc] init];
    [paramStore setValue:self.categoryId forKey:@"categories_id_eq"];
    
    NSMutableArray* brandStoreArray = [[NSMutableArray alloc] init];
    for(ISUserInfo* sizeInfo in _arrayBrands){
        if (sizeInfo.isSelected) {
            [brandStoreArray addObject:sizeInfo.string_Product_Id];
        }
    }
[paramStore setValue:brandStoreArray forKey:@"items_brand_id_in"];
    
    NSMutableArray* colorStoreArray = [[NSMutableArray alloc] init];
    for(ISUserInfo* sizeInfo in _arrayColors){
        if (sizeInfo.isSelected) {
            [colorStoreArray addObject:sizeInfo.store_id];
        }
    }
 [paramStore setValue:colorStoreArray forKey:@"items_color_id_in"];
    

    if ([modalObj.string_itemCondition isEqualToString:@"New"]) {
        [paramStore setValue:@"0" forKey:@"items_condition_eq"];
    }
    else if ([modalObj.string_itemCondition isEqualToString:@"Used"]) {
        [paramStore setValue:@"1" forKey:@"items_condition_eq"];
    }
    else {
        [paramStore setValue:@"" forKey:@"items_condition_eq"];
    }
    [paramStore setValue:([modalObj.string_gender isEqualToString:@"Male"]?@"0":@"1")  forKey:@"gender_eq"];
    
    //size
    NSMutableArray* sizeStoreArray = [[NSMutableArray alloc] init];
    for(ISUserInfo* sizeInfo in _arraySizeItems){
        if (sizeInfo.isSelected) {
            [sizeStoreArray addObject:sizeInfo.item_id];
        }
    }
    [paramStore setValue:sizeStoreArray forKey:@"items_size_id_in"];
    [paramStore setValue:@"" forKey:@"items_title_con"];
    
    
    NSDictionary * filerDict = [NSDictionary dictionaryWithObjectsAndKeys:paramItem, @"item_q", paramStore, @"store_q", nil];

    [[ISServiceHelper helper] request:[NSMutableDictionary dictionaryWithObjectsAndKeys:filerDict, @"filter", nil] apiName:[NSString stringWithFormat:@"items/home_search?page=%ld", (long)page] method:POST completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             [self.tableViewCategoryDetails setHidden:NO];
             if (error == nil) {
                 
                 if (pageNumber == 1) {
                     [self.popularStoresdataArray removeAllObjects];
                     [self.trendingItemsdataArray removeAllObjects];
                 }
                 
                 [self.tableViewCategoryDetails setDelegate:self];
                 [self.tableViewCategoryDetails setDataSource:self];

                 [self.popularStoresdataArray addObjectsFromArray:[self parsePopularStoresData:[resultDict objectForKeyNotNull:kPopular_Stores expectedObj:[NSArray array]]]];
                 [self.trendingItemsdataArray addObjectsFromArray:[self parseTrendingItemsData:[resultDict objectForKeyNotNull:kTrending_Items expectedObj:[NSArray array]]]];
                 self.pagination = [ISPagination parseDataFromDict:[resultDict objectForKeyNotNull:@"page_detail" expectedObj:[NSDictionary dictionary]]];
                 [self.tableViewCategoryDetails reloadData];
             }
         });
     }];
}

-(void)parseFilterData:(NSDictionary *)filterProductData
{
    for (NSMutableDictionary *dicColor in [filterProductData objectForKeyNotNull:@"colors" expectedObj:[NSArray array]]) {
        ISUserInfo* modalColorObj = [[ISUserInfo alloc] init];
        modalColorObj.store_id = [dicColor objectForKeyNotNull:@"id" expectedObj:@""];
        modalColorObj.isSelected = NO;
        if (_arrayColors.count == 0) {
            modalColorObj.string_itemColor = @"All";
            [_arrayColors addObject:modalColorObj];
        }
        else{
        modalColorObj.string_itemColor = [dicColor objectForKeyNotNull:@"name" expectedObj:@""];
            [_arrayColors addObject:modalColorObj];
        }
    }
    for (NSMutableDictionary *dicSize in [filterProductData objectForKeyNotNull:@"sizes" expectedObj:[NSArray array]]) {
        ISUserInfo* modalSizeObj = [[ISUserInfo alloc] init];
        modalSizeObj.item_id = [dicSize objectForKeyNotNull:@"id" expectedObj:@""];
         modalSizeObj.isSelected = NO;
        if (_arraySizeItems.count == 0) {
             modalSizeObj.string_itemSize = @"All";
            [_arraySizeItems addObject:modalSizeObj];
        }
        else{
        modalSizeObj.string_itemSize = [dicSize objectForKeyNotNull:@"name" expectedObj:@""];
        [_arraySizeItems addObject:modalSizeObj];
        }
       
    }
    for (NSMutableDictionary *dicBrand in [filterProductData objectForKeyNotNull:@"brands" expectedObj:[NSArray array]]) {
        ISUserInfo* modalBrandObj = [[ISUserInfo alloc] init];
        modalBrandObj.string_Product_Id = [dicBrand objectForKeyNotNull:@"id" expectedObj:@""];
        modalBrandObj.isSelected = NO;
        if(_arrayBrands.count == 0){
        
            modalBrandObj.string_Product_Name = @"All";
            [_arrayBrands addObject:modalBrandObj];
        }
        else{
        modalBrandObj.string_Product_Name= [dicBrand objectForKeyNotNull:@"name" expectedObj:@""];
            [_arrayBrands addObject:modalBrandObj];
        }
    }
      self.arrayCondition = [[NSMutableArray alloc] init];
    
    for (NSString * string in @[@"All",@"New",@"Used"]) {
        ISUserInfo* modalConditionObj = [[ISUserInfo alloc] init];
            modalConditionObj.isSelected = NO;
            modalConditionObj.string_itemCondition = string;
        [self.arrayCondition addObject:modalConditionObj];
    }

    for (NSString * string in [filterProductData objectForKeyNotNull:@"gender" expectedObj:[NSArray array]]) {
        
        ISUserInfo* modalGenderObj = [[ISUserInfo alloc] init];
        if ([[NSString stringWithFormat:@"%@", string] isEqualToString:@"0"]) {
            modalGenderObj.isSelected = NO;
            modalGenderObj.string_gender = @"Male";
            [self.arrayGender addObject:modalGenderObj];
        }
        else{
            modalGenderObj.isSelected = NO;
            modalGenderObj.string_gender = @"Female";
            [self.arrayGender addObject:modalGenderObj];
        }
    }
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

-(void)didSelectData:(NSString*)strText
{
    if ([strText isEqualToString:@"Popular"])
        modalObj.string_itemSort = @"clicks desc";
    else if ([strText isEqualToString:@"Newest"])
        modalObj.string_itemSort = @"created_at desc";
    else if ([strText isEqualToString:@"Price: High to Low"])
        modalObj.string_itemSort = @"price desc";
    else
        modalObj.string_itemSort = @"price asc";
    pageNumber = 1;
    [self makeWebApiCallToGetSearchResult:1];
}

-(void)showErrorAlertWithTitle:(NSString*)error{
    [[AlertView sharedManager] presentAlertWithTitle:@"" message:error andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {}];
}
@end
