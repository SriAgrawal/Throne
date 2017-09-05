//
//  ISOtherProfileVC.m
//  Instasneaks
//
//  Created by Shridhar Agarwal on 11/08/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISOtherProfileVC.h"
#import "Header.h"

static NSString *CellIdentifier = @"profileCell";
@interface ISOtherProfileVC ()<CarbonTabSwipeNavigationDelegate>
{
    ISUserInfo *infoUser;
    NSMutableArray *purchaseItemArray,*favouriteItemArray,*trackedItemArray;
}

@property (weak, nonatomic) IBOutlet UITableView        * tableView_Otherprofile;
@property (strong, nonatomic) IBOutlet UILabel          * label_userName;
@property (strong, nonatomic) IBOutlet UIImageView      * imageView_userImage;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_StoreBackground;
@property (weak, nonatomic) IBOutlet UIView *sepratorView;
@property (weak, nonatomic) IBOutlet UIImageView *storeImageView;
@property (weak, nonatomic) IBOutlet UIButton *storeBtn;
@property (weak, nonatomic) IBOutlet UILabel *itemLbl;

@property (strong, nonatomic) IBOutlet UIView           * containerView;
@property (strong, nonatomic) CarbonTabSwipeNavigation  * pageVC;
@property (strong, nonatomic) NSArray                   * arrayItems;
@property (weak, nonatomic) IBOutlet UILabel *navLbl;

@property (strong, nonatomic) ISPagination      * purchageItemPagination;
@property (strong, nonatomic) ISPagination      * storePagination;
@property (strong, nonatomic) ISPagination      * itemPagination;

@end

@implementation ISOtherProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    infoUser = [[ISUserInfo alloc] init];
    [self callApiForOtherProfile:self.otherUserId];
    [self.containerView setFrame:CGRectMake(0, 0, WIN_WIDTH, WIN_HEIGHT-70)];
//    [self initialMethod];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Helper Methods

-(void)initialMethod
{
    self.arrayItems = @[@"PURCHASES", @"FAVORITE STORE", @"TRACKED ITMES"];
    
    self.pageVC = [[CarbonTabSwipeNavigation alloc]initWithItems:self.arrayItems delegate:self];
    //[self.pageVC insertIntoRootViewController:self];
    [self.pageVC.view setFrame:self.containerView.bounds];
    [self.containerView addSubview:self.pageVC.view];
    [self addChildViewController:self.pageVC];
    
    // set up page style
    
    [self.pageVC setTabExtraWidth:0];
    [self.pageVC setTabBarHeight:48];
    
    [self.pageVC.carbonSegmentedControl setWidth:[[UIScreen mainScreen]bounds].size.width/self.arrayItems.count forSegmentAtIndex:0];
    [self.pageVC.carbonSegmentedControl setWidth:[[UIScreen mainScreen]bounds].size.width/self.arrayItems.count forSegmentAtIndex:1];
    [self.pageVC.carbonSegmentedControl setWidth:[[UIScreen mainScreen]bounds].size.width/self.arrayItems.count forSegmentAtIndex:2];
    
    // Custimize segmented control
    
    [self.pageVC setNormalColor:[UIColor colorWithRed:150/255.0f green:150/255.0f  blue:150/255.0f  alpha:1.0f] font:NEO_SANS_PRO_REGULAR((WIN_WIDTH == 320) ? 12 : 13)];
    [self.pageVC setSelectedColor:[UIColor colorWithRed:48/255.0f green:48/255.0f  blue:48/255.0f  alpha:1.0f] font:NEO_SANS_PRO_REGULAR((WIN_WIDTH == 320) ? 12 : 13)];
    [self.pageVC setIndicatorColor:[UIColor colorWithRed:180/255.0f green:155/255.0f  blue:91/255.0f  alpha:1.0f]];
    [self.pageVC setIndicatorHeight:4];
    [self setUpView];
}

-(void)setUpView
{
    self.label_userName.text = infoUser.string_UserName;
      self.navLbl.text = infoUser.string_UserName;
    
    [self.imageView_userImage sd_setImageWithURL:[NSURL URLWithString:infoUser.image] placeholderImage:[UIImage imageNamed:@"image-not-available"] options:SDWebImageProgressiveDownload];
    [self.storeImageView sd_setImageWithURL:[NSURL URLWithString:infoUser.store_logo] placeholderImage:[UIImage imageNamed:@"image-not-available"] options:SDWebImageProgressiveDownload];
    [self.imageView_StoreBackground sd_setImageWithURL:[NSURL URLWithString:infoUser.store_background] placeholderImage:[UIImage imageNamed:@"img_profile_background"] options:SDWebImageProgressiveDownload];
    [self.itemLbl setAttributedText:[self getAttributrdTextForItemPrice:infoUser.item_count]];
}

-(NSAttributedString *)getAttributrdTextForItemPrice:(NSString *)string
{
    NSMutableAttributedString *coloredText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"ITEMS %@", string]];
    [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:118.0/255.0f green:118.0/255.0f blue:118.0/255.0f alpha:1.0f] range:NSMakeRange(0,5)];
    return coloredText;
}
#pragma mark - CarbonTabSwipeNavigation Delegate
// required
- (UIViewController *)carbonTabSwipeNavigation:(CarbonTabSwipeNavigation *)carbontTabSwipeNavigation viewControllerAtIndex:(NSUInteger)index {
    switch (index)
    {
        case 0:{
            
            ISLockerVC *lockerVC = [[ISLockerVC alloc] initWithNibName:@"ISLockerVC" bundle:nil];
            lockerVC.isFromPurchase = YES;
            lockerVC.purchaseArray = [purchaseItemArray mutableCopy];
            [lockerVC setIndexPage:0];
            [lockerVC setPurchageItemPagination:self.purchageItemPagination];
            return lockerVC;
        }
        case 1:{
            
            ISLockerVC *purchasedItemsVC= [[ISLockerVC alloc] initWithNibName:@"ISLockerVC" bundle:nil];
            purchasedItemsVC.favoriteArray = [favouriteItemArray mutableCopy];
            purchasedItemsVC.isFromFavorite  = YES;
            [purchasedItemsVC setIndexPage:1];
            [purchasedItemsVC setStorePagination:self.storePagination];
            return purchasedItemsVC;
        }
        case 2:{
            
            ISLockerVC *purchasedItemsVC= [[ISLockerVC alloc] initWithNibName:@"ISLockerVC" bundle:nil];
            purchasedItemsVC.trackArray = [trackedItemArray mutableCopy];
            purchasedItemsVC.isFromTrack = YES;
            [purchasedItemsVC setIndexPage:2];
            [purchasedItemsVC setItemPagination:self.itemPagination];
            return purchasedItemsVC;
        }
        default:
        {
            return nil;
        }
    }
}
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIBarPosition)barPositionForCarbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation {
    return UIBarPositionTop; // default UIBarPositionTop
}

#pragma mark-Api Method

-(void)callApiForOtherProfile:(NSString *)otherUserId
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:self.otherUserId forKey:@"id"];
    [[ISServiceHelper helper]request:param apiName:[NSString stringWithFormat:@"user"] method:GET completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if([[resultDict objectForKey:@"code"] integerValue ]==200)
            {
                
                NSMutableDictionary *userInfoDic = [resultDict objectForKeyNotNull:kUser expectedObj:[NSDictionary dictionary]];
                [infoUser setUserId:[userInfoDic objectForKeyNotNull:@"id" expectedObj:@""]];
                [infoUser setString_UserName:[userInfoDic objectForKeyNotNull:@"full_name" expectedObj:@""]];
                [infoUser setImage:[userInfoDic objectForKeyNotNull:kImage expectedObj:@""]];
                [infoUser setIsStore:[[userInfoDic objectForKeyNotNull:@"is_store" expectedObj:@"0"] integerValue]];
                NSMutableDictionary *storeInfoDic = [resultDict objectForKeyNotNull:kStore expectedObj:[NSDictionary dictionary]];
                [infoUser setStore_id:[storeInfoDic objectForKeyNotNull:@"id" expectedObj:@""]];
                [infoUser setStore_background:[storeInfoDic objectForKeyNotNull:kStore_Background expectedObj:@""]];
                [infoUser setStore_logo:[storeInfoDic objectForKeyNotNull:kStore_Logo expectedObj:@""]];
                [infoUser setItem_count:[storeInfoDic objectForKeyNotNull:kItemCount expectedObj:@""]];
                
                [purchaseItemArray removeAllObjects];
                [favouriteItemArray removeAllObjects];
                [trackedItemArray removeAllObjects];
                
                purchaseItemArray = [self parseDataForPurchaseItem:[resultDict objectForKeyNotNull:kPurchaseItem expectedObj:[NSArray array]]];
                favouriteItemArray = [self parseDataForPurchaseItem:[resultDict objectForKeyNotNull:kFavouriteStore expectedObj:[NSArray array]]];
                trackedItemArray = [self parseDataForPurchaseItem:[resultDict objectForKeyNotNull:kFavouriteItem expectedObj:[NSArray array]]];
                [self tableView_Otherprofile];
                
                self.purchageItemPagination = [ISPagination parseDataFromDict:[resultDict objectForKeyNotNull:@"purchase_view_page" expectedObj:[NSDictionary dictionary]]];
                self.storePagination = [ISPagination parseDataFromDict:[resultDict objectForKeyNotNull:@"stores_view_page" expectedObj:[NSDictionary dictionary]]];
                self.itemPagination = [ISPagination parseDataFromDict:[resultDict objectForKeyNotNull:@"items_view_page" expectedObj:[NSDictionary dictionary]]];

                [self initialMethod];
            }
            else
            {
                NSLog(@"Error in response:%@",error);
                
            }
        });
    }];
}
-(NSMutableArray *)parseDataForPurchaseItem:(NSMutableArray *)purchaseArray
{
    NSMutableArray * itemArray = [NSMutableArray array];
    for (NSDictionary *dic in purchaseArray)
    {
        ISUserInfo *purchaseObj = [ISUserInfo parseDataFromDict:dic];
        [itemArray addObject: purchaseObj];
        
    }
    return itemArray;
}

@end
