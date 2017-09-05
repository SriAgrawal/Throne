//
//  ISLockerVC.m
//  Instasneaks
//
//  Created by Suresh patel on 03/08/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISLockerVC.h"

@interface ISLockerVC ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSInteger purchageItemPageNumber, itemPageNumber, storePageNumber;
}

@property (strong, nonatomic) IBOutlet UIView *noItemView;
@property (strong, nonatomic) IBOutlet UILabel *noItemLbl;
@property (weak, nonatomic) IBOutlet UICollectionView   * collectionView_collectionsItem;


@end

@implementation ISLockerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialMethod];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.collectionView_collectionsItem reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods

-(void)initialMethod
{
    if (_isFromFavorite == YES && self.favoriteArray.count == 0)
    {
         self.collectionView_collectionsItem.hidden = YES;
        self.noItemLbl.text = @"You haven't favorited any stores yet,pick up some dope gear";
    }
    else if (_isFromTrack == YES && self.trackArray.count == 0)
    {
        self.collectionView_collectionsItem.hidden = YES;
         self.noItemLbl.text = @"You haven't tracked any items yet,pick up some dope gear";
    }
    else if(_isFromPurchase == YES && self.purchaseArray.count == 0)
    {
        self.collectionView_collectionsItem.hidden = YES;
        self.noItemLbl.text = @"You haven't purchased any items yet, pick up some dope gear";
    }
    else
    {
        self.noItemView.hidden = YES;
         self.collectionView_collectionsItem.hidden = NO;
        UINib *cellNib = [UINib nibWithNibName:@"ISShopCollectionsCell" bundle:nil];
        [self.collectionView_collectionsItem registerNib:cellNib forCellWithReuseIdentifier:@"shopCollectionsCell"];
    }
    
    purchageItemPageNumber = 1;
    storePageNumber = 1;
    itemPageNumber = 1;
}
#pragma collectionView Delgate and DataSource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    
    if (self.indexPage == 0)
        return self.purchaseArray.count;
    else if (self.indexPage == 1)
        return self.favoriteArray.count;
    else
        return self.trackArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ISShopCollectionsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"shopCollectionsCell" forIndexPath:indexPath];
    ISUserInfo *imageInfo;
    NSString * imageUrlString;
    if (self.indexPage == 0){
        imageInfo = [self.purchaseArray objectAtIndex:indexPath.row];
        imageUrlString = imageInfo.image;
    }
    else if (self.indexPage == 1){
        imageInfo = [self.favoriteArray objectAtIndex:indexPath.row];
        imageUrlString = imageInfo.store_logo;
    }
    else{
        imageInfo = [self.trackArray objectAtIndex:indexPath.row];
        imageUrlString = imageInfo.image;
    }
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:@"image-not-available"] options:SDWebImageProgressiveDownload];

    [cell setBackgroundColor:[UIColor whiteColor]];
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((WIN_WIDTH-4)/3+1,(WIN_WIDTH-4)/3);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ISUserInfo *infObj;
    if (self.indexPage == 0)
    {
        infObj = [self.purchaseArray objectAtIndex:indexPath.row];
        ISCollectionsContainerVC *storeVC = [[ISCollectionsContainerVC alloc] initWithNibName:@"ISCollectionsContainerVC" bundle:nil];
        [storeVC setIsForItemDetail:YES];
        [storeVC setItemId:[NSString stringWithFormat:@"%lud",(unsigned long)infObj.id]];
        [self.navigationController pushViewController:storeVC animated:YES];
    }
    else if (self.indexPage == 1)
    {
        infObj = [self.favoriteArray objectAtIndex:indexPath.row];
        ISDetailContainerVC *storeVC = [[ISDetailContainerVC alloc] initWithNibName:@"ISDetailContainerVC" bundle:nil];
        storeVC.storeId = [NSString stringWithFormat:@"%ld",(unsigned long)infObj.id ];
        [self.navigationController pushViewController:storeVC animated:YES];
    }
    else
    {
        infObj = [self.trackArray objectAtIndex:indexPath.row];
        ISCollectionsContainerVC *storeVC = [[ISCollectionsContainerVC alloc] initWithNibName:@"ISCollectionsContainerVC" bundle:nil];
        [storeVC setIsForItemDetail:YES];
        [storeVC setItemId:[NSString stringWithFormat:@"%lud",(unsigned long)infObj.id]];
        [self.navigationController pushViewController:storeVC animated:YES];
    }
}
#pragma mark - Scroll View Delegate Methods
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (currentOffset - maximumOffset >= SCROLLUPREFRESHHEIGHT) {
        
        if (self.indexPage == 0){
            if (self.purchageItemPagination.total_pages > purchageItemPageNumber) {
                purchageItemPageNumber++;
                [self makeApiCallToGetPurchageitems];
            }
        }
        else if (self.indexPage == 1){
            if (self.storePagination.total_pages > storePageNumber) {
                storePageNumber++;
                [self makeApiCallToGetFavouriteStore];
            }
        }
        else{
            if (self.itemPagination.total_pages > itemPageNumber) {
                itemPageNumber++;
                [self makeApiCallToGetFavouriteItem];
            }
        }
    }
}

#pragma mark - Web Service Method
-(void)makeApiCallToGetPurchageitems
{
    NSString *apiSearch = [NSString stringWithFormat:@"items/purchase_items?page=%ld", (long)purchageItemPageNumber];
    [[ISServiceHelper helper] request:nil apiName:apiSearch method:GET completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             if (error == nil) {
                 [self.purchaseArray addObjectsFromArray:[self parseDataForPurchaseItem:[resultDict objectForKeyNotNull:@"purchased_items" expectedObj:[NSArray array]]]];

                 self.purchageItemPagination = [ISPagination parseDataFromDict:[resultDict objectForKeyNotNull:@"purchase_view_page" expectedObj:[NSDictionary dictionary]]];
                 [self.collectionView_collectionsItem reloadData];
             }
         });
     }];
}

-(void)makeApiCallToGetFavouriteStore
{
    NSString *apiSearch = [NSString stringWithFormat:@"stores/my_favourites?page=%ld", (long)storePageNumber];
    [[ISServiceHelper helper] request:nil apiName:apiSearch method:GET completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             [self.favoriteArray addObjectsFromArray:[self parseDataForPurchaseItem:[resultDict objectForKeyNotNull:@"favourite_stores" expectedObj:[NSArray array]]]];
             self.storePagination = [ISPagination parseDataFromDict:[resultDict objectForKeyNotNull:@"stores_view_page" expectedObj:[NSDictionary dictionary]]];
             [self.collectionView_collectionsItem reloadData];
         });
     }];
}

-(void)makeApiCallToGetFavouriteItem
{
    NSString *apiSearch = [NSString stringWithFormat:@"items/my_favourites?page=%ld", (long)itemPageNumber];
    [[ISServiceHelper helper] request:nil apiName:apiSearch method:GET completionBlock:^(NSDictionary *resultDict, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             [self.trackArray addObjectsFromArray:[self parseDataForPurchaseItem:[resultDict objectForKeyNotNull:@"favourite_items" expectedObj:[NSArray array]]]];
             self.itemPagination = [ISPagination parseDataFromDict:[resultDict objectForKeyNotNull:@"items_view_page" expectedObj:[NSDictionary dictionary]]];
             [self.collectionView_collectionsItem reloadData];
         });
     }];
}

-(NSMutableArray *)parseDataForPurchaseItem:(NSMutableArray *)purchaseArray
{
    NSMutableArray * purchaseItemArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in purchaseArray)
    {
        ISUserInfo *purchaseObj = [ISUserInfo parseDataFromDict:dic];
        [purchaseItemArray addObject: purchaseObj];
    }
    return purchaseItemArray;
}
@end
