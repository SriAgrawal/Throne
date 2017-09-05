//
//  ISFeaturedViewController.m
//  Instasneaks
//
//  Created by Ankurgupta148 on 07/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISFeaturedViewController.h"
#import "ISFeatureCell.h"
#import "ISFeaturedCololectionCell.h"
#import "ISShopCollectionViewCell.h"
#import "Header.h"
@interface ISFeaturedViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate>{
    int pageNumber;
}
@property (strong, nonatomic) IBOutlet UITableView *tableview_Features;
@property (strong, nonatomic) ISPagination      * pagination;
@property (strong, nonatomic) UIRefreshControl  * refreshControl;
@property (strong, nonatomic) NSMutableArray        * storeListData;
@end

@implementation ISFeaturedViewController

#pragma mark - UIView Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.storeListData = [[NSMutableArray alloc]init];
    self.pagination = [[ISPagination alloc] init];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableview_Features addSubview:self.refreshControl];
    [self performSelector:@selector(makeAPIForFeature:) withObject:nil afterDelay:1.0];
    [self.tableview_Features registerNib:[UINib nibWithNibName:@"ISFeatureCell" bundle:nil] forCellReuseIdentifier:@"ISFeatureCell"];
    pageNumber = 1;

}
#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//Method for Refresh Handling
- (void)handleRefresh:(UIRefreshControl *)refreshControl {
    
    [self.tableview_Features reloadData];
    [self.tableview_Features layoutIfNeeded];
    [refreshControl endRefreshing];
    pageNumber = 1;
    [self makeAPIForFeature:pageNumber];
}
#pragma mark- Scroll View Delegate Method

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (currentOffset - maximumOffset >= SCROLLUPREFRESHHEIGHT) {
        
        if (self.pagination.total_pages > pageNumber) {
            pageNumber++;
            [self makeAPIForFeature:pageNumber];
        }
    }
}
#pragma mark - UITableViewDelegate and UITableViewDataSource Method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.storeListData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ISFeatureCell *cell = (ISFeatureCell *)[tableView dequeueReusableCellWithIdentifier:@"ISFeatureCell"];
    ISUserInfo * imageInfo = [self.storeListData objectAtIndex:indexPath.item];
    [cell.imageView_profile sd_setImageWithURL:[NSURL URLWithString:imageInfo.image] placeholderImage:[UIImage imageNamed:@"image-not-available"] options:SDWebImageProgressiveDownload];

    [cell.label_userName setText:imageInfo.string_UserName];
    [cell.label_detail setText:imageInfo.item_description];
    cell.button_profile.tag = indexPath.row + 2000;
    [cell.button_profile addTarget:self action:@selector(storeDetails:) forControlEvents:UIControlEventTouchUpInside];
    cell.collectionView_ISFeature.tag = indexPath.row+1000;
    [cell.collectionView_ISFeature registerNib:[UINib nibWithNibName:@"ISFeaturedCololectionCell"bundle:nil]forCellWithReuseIdentifier:@"ISFeaturedCololectionCell"];
    cell.collectionView_ISFeature.delegate = self;
    cell.collectionView_ISFeature.dataSource = self;
    [cell.collectionView_ISFeature reloadData];
    return cell;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 328;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    ISUserInfo *obj = [self.storeListData objectAtIndex:indexPath.item];
    ISDetailContainerVC *storeVC = [[ISDetailContainerVC alloc] initWithNibName:@"ISDetailContainerVC" bundle:nil];
    storeVC.storeId = [NSString stringWithFormat:@"%ld",(unsigned long)obj.id ];
    [self.navigationController pushViewController:storeVC animated:YES];
}
#pragma mark - UICollectionViewDelegate and UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    ISUserInfo * itemInfo = [self.storeListData objectAtIndex:collectionView.tag%1000];
    return itemInfo.storeItemArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ISFeaturedCololectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ISFeaturedCololectionCell" forIndexPath:indexPath];
    ISUserInfo * itemInfo = [self.storeListData objectAtIndex:collectionView.tag%1000];
    ISUserInfo *info = [itemInfo.storeItemArray objectAtIndex:indexPath.item];
    [cell.imageview_ProductImage sd_setImageWithURL:[NSURL URLWithString:info.image] placeholderImage:[UIImage imageNamed:@"image-not-available"] options:SDWebImageProgressiveDownload];
    [cell.label_PricelLabel setText:[NSString stringWithFormat:@"$%@", info.price]];
    [cell.label_StoreName setText:info.store_name];
    [cell.label_ProductName setText:info.title];
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
{   ISUserInfo * itemInfo = [self.storeListData objectAtIndex:collectionView.tag%1000];
    ISUserInfo *info = [itemInfo.storeItemArray objectAtIndex:indexPath.item];
    ISCollectionsContainerVC *shopVC = [[ISCollectionsContainerVC alloc] initWithNibName:@"ISCollectionsContainerVC" bundle:nil];
    shopVC.itemId = [NSString stringWithFormat:@"%lu", (unsigned long)info.id];
    shopVC.isForItemDetail = YES;
    [self.navigationController pushViewController:shopVC animated:YES];
}
#pragma mark- Cell Button Method
- (void)storeDetails:(UIButton *)sender{
ISUserInfo *info = [self.storeListData objectAtIndex:sender.tag-2000];
 ISDetailContainerVC *storeVC = [[ISDetailContainerVC alloc] initWithNibName:@"ISDetailContainerVC" bundle:nil];
    storeVC.storeId = info.store_id;
    storeVC.isMyStore = ([[USERDEFAULT valueForKey:kUserId] isEqualToString:info.userId])? @"Mine":@"Other";
    [self.navigationController pushViewController:storeVC animated:YES];

}
#pragma mark - Web service API For Feature
-(void)makeAPIForFeature:(int)pageNo
{
    if (!pageNo) {
        pageNo = pageNumber;
    }
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[NSNumber numberWithInt:pageNo] forKey:@"page"];
    [param setValue:self.categoryId forKey:@"q[categories_id_eq]"];
    [[ISServiceHelper helper] request:param apiName:@"stores" method:GET completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             if ([[resultDict objectForKey:kCode]integerValue] == 200)
             {
                 [self.storeListData removeAllObjects];
                 self.storeListData = [self parseDataFromResultDict:resultDict];
                 [self.tableview_Features reloadData];
             }
             else{
                 
                [self showErrorAlertWithTitle:[resultDict objectForKeyNotNull:kMessage expectedObj:@""]];
             }
         });
     }];
}
-(NSMutableArray *)parseDataFromResultDict:(NSDictionary *)dictionary{
    NSMutableArray *store = [dictionary objectForKeyNotNull:@"stores" expectedObj:@""];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (NSMutableDictionary *dict in store) {
        ISUserInfo *info = [[ISUserInfo alloc]init];
        [info setItem_description:[dict objectForKeyNotNull:@"description" expectedObj:@""]];
        [info setString_UserName:[dict objectForKeyNotNull:@"fullname" expectedObj:@""]];
        [info setImage:[dict objectForKeyNotNull:@"user_image" expectedObj:@""]];
        [info setStore_id:[dict objectForKeyNotNull:@"id" expectedObj:@""]];
        [info setUserId:[dict objectForKeyNotNull:@"user_id" expectedObj:@""]];
        info.storeItemArray = [self parseDataFromDict:[dict objectForKeyNotNull:@"items" expectedObj:[NSArray array]]];
        [array addObject:info];
    }
    self.pagination = [ISPagination parseDataFromDict:[dictionary objectForKeyNotNull:@"page_detail" expectedObj:[NSDictionary dictionary]]];
    return  array;
}

-(NSMutableArray *)parseDataFromDict:(NSArray *)items{
   NSMutableArray *itemArray = [[NSMutableArray alloc]init];
    for (NSDictionary *itemDict in items) {
        ISUserInfo *info = [ISUserInfo parseDataFromDict:itemDict];
        [itemArray addObject:info];
    }
    return itemArray;
}
#pragma mark - Alert Method
-(void)showErrorAlertWithTitle:(NSString*)error{
    [[AlertView sharedManager] presentAlertWithTitle:@"" message:error andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle) {}];
}

@end
