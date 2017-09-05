//
//  ISProfileVC.m
//  Instasneaks
//
//  Created by Suresh patel on 15/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISProfileVC.h"

#import <FBSDKShareKit/FBSDKSharingContent.h>
#import "Social/SocialDefines.h"

static NSString *CellIdentifier = @"profileCell";

@interface ISProfileVC ()<CarbonTabSwipeNavigationDelegate>
{
    ISUserInfo *infoUser;
    NSMutableArray *purchaseItemArray,*favouriteItemArray,*trackedItemArray;
}

@property (weak, nonatomic) IBOutlet UITableView        * tableView_profile;
@property (strong, nonatomic) IBOutlet UILabel          * label_userName;
@property (strong, nonatomic) IBOutlet UILabel          * label_itemCount;
@property (strong, nonatomic) IBOutlet UIImageView      * imageView_userImage;
@property (strong, nonatomic) IBOutlet UIImageView *storeImageView;
@property (strong, nonatomic) IBOutlet UIButton *applyBtn;
@property (strong, nonatomic) IBOutlet UIImageView      * imageView_StoreBackground;
@property (weak, nonatomic) IBOutlet UIButton *sharingBtn;

@property (strong, nonatomic) IBOutlet UIView           * containerView;
@property (strong, nonatomic) CarbonTabSwipeNavigation  * pageVC;
@property (strong, nonatomic) NSArray                   * arrayItems;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) UIDocumentInteractionController *document;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seperatorViewUpperContraints;
@property (weak, nonatomic) IBOutlet UIView *sepratorView;


@property (strong, nonatomic) ISPagination      * purchageItemPagination;
@property (strong, nonatomic) ISPagination      * storePagination;
@property (strong, nonatomic) ISPagination      * itemPagination;

@end

@implementation ISProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    infoUser = [[ISAppUserData sharedObject] objectUserInfo];
    purchaseItemArray = [[NSMutableArray alloc] init];
     favouriteItemArray = [[NSMutableArray alloc] init];
     trackedItemArray = [[NSMutableArray alloc] init];
    [self.containerView setFrame:CGRectMake(0, 0, WIN_WIDTH, WIN_HEIGHT-62)];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self callApiForProfile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods

-(void)initialMethod
{
//   
//    Mixpanel *mixpanel = [Mixpanel sharedInstance];
//    [mixpanel track:@"Profile opened"
//         properties:@{ @"Background color": @"Moody pink",
//                       @"Profile opened": @"absolutetly"
//                       }];
    
    self.arrayItems = @[@"PURCHASES", @"FAVORITE STORE", @"TRACKED ITEMS"];
    if (self.pageVC != nil) {
        [self.pageVC.view removeFromSuperview];
    }
    
    // set up page style
    self.pageVC = [[CarbonTabSwipeNavigation alloc]initWithItems:self.arrayItems delegate:self];
    [self.pageVC.view setFrame:self.containerView.bounds];
    [self.containerView addSubview:self.pageVC.view];
    [self addChildViewController:self.pageVC];

    [self.pageVC setTabExtraWidth:0];
    [self.pageVC setTabBarHeight:48];
    
    if (self.isFromTabBar)
        [self.pageVC setCurrentTabIndex:2];
    else
     [self.pageVC setCurrentTabIndex:0];
    
//    
    [self.pageVC.carbonSegmentedControl setWidth:[[UIScreen mainScreen]bounds].size.width/self.arrayItems.count forSegmentAtIndex:0];
    [self.pageVC.carbonSegmentedControl setWidth:[[UIScreen mainScreen]bounds].size.width/self.arrayItems.count forSegmentAtIndex:1];
    [self.pageVC.carbonSegmentedControl setWidth:[[UIScreen mainScreen]bounds].size.width/self.arrayItems.count forSegmentAtIndex:2];
    
    // Custimize segmented control
    [self.pageVC setNormalColor:[UIColor colorWithRed:150/255.0f green:150/255.0f  blue:150/255.0f  alpha:1.0f] font:NEO_SANS_PRO_REGULAR((WIN_WIDTH == 320) ? 12 : 13)];
    [self.pageVC setSelectedColor:[UIColor colorWithRed:48/255.0f green:48/255.0f  blue:48/255.0f  alpha:1.0f] font:NEO_SANS_PRO_REGULAR((WIN_WIDTH == 320) ? 12 : 13)];
    [self.pageVC setIndicatorColor:[UIColor colorWithRed:180/255.0f green:155/255.0f  blue:91/255.0f  alpha:1.0f]];
    [self.pageVC setIndicatorHeight:4];
    [self.view layoutSubviews];
    [self setUpProfile];
}

-(void)setUpProfile
{
    self.sepratorView.hidden = NO;
    switch (infoUser.isStore)
    {
        case 0: case 1: case 3:
        {
            CGRect newFrame = self.headerView.frame;
            newFrame.size.height = 364;
            self.headerView.frame = newFrame;
            self.tableView_profile.tableHeaderView = self.headerView;
            self.seperatorViewUpperContraints.constant = 70.0f;
            self.applyBtn.hidden = NO;
            self.storeImageView.hidden = YES;
        }
            break;
        case 2:
        {
            self.applyBtn.hidden = YES;
            self.storeImageView.hidden = NO;
        }
            break;
        default:
            break;
    }
    self.label_userName.text = infoUser.string_UserName;

    [self.imageView_userImage sd_setImageWithURL:[NSURL URLWithString:infoUser.image] placeholderImage:[UIImage imageNamed:@"image-not-available"] options:SDWebImageProgressiveDownload];
       [self.storeImageView sd_setImageWithURL:[NSURL URLWithString:infoUser.store_logo] placeholderImage:[UIImage imageNamed:@"image-not-available"] options:SDWebImageProgressiveDownload];
      [self.imageView_StoreBackground sd_setImageWithURL:[NSURL URLWithString:infoUser.store_background] placeholderImage:[UIImage imageNamed:@"img_profile_background"] options:SDWebImageProgressiveDownload];
    [self.label_itemCount setAttributedText:[self getAttributrdTextForItemPrice:infoUser.item_count]];
}

-(NSAttributedString *)getAttributrdTextForItemPrice:(NSString *)string
{
    NSMutableAttributedString *coloredText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"ITEMS %@", string]];
    [coloredText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:118.0/255.0f green:118.0/255.0f blue:118.0/255.0f alpha:1.0f] range:NSMakeRange(0,5)];
    return coloredText;
}

#pragma mark - UIButton Actions

- (IBAction)moneyButtonAction:(id)sender
{
    ISWalletVC *walletVC = [[ISWalletVC alloc]initWithNibName:@"ISWalletVC" bundle:nil];
    [self.navigationController pushViewController:walletVC animated:YES];
}
- (IBAction)settingButtonAction:(id)sender {
    
    ISSettingVC * settingVC = [[ISSettingVC alloc] initWithNibName:@"ISSettingVC" bundle:nil];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (IBAction)addToLockerButtonAction:(id)sender
{
    if (infoUser.isStore == 1)
    {
        [self showErrorAlertWithTitle:@"You are already applied for the store"];
    }
    
    ISBecameSellerVC *controller = [[ISBecameSellerVC alloc] initWithNibName:@"ISBecameSellerVC" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - CustomMethod

- (IBAction)storeBtnAction:(id)sender
{
    if ([infoUser.string_State isEqualToString:@"active"]) {
        ISDetailContainerVC *storeVC = [[ISDetailContainerVC alloc] initWithNibName:@"ISDetailContainerVC" bundle:nil];
        storeVC.storeId = infoUser.store_id;
        storeVC.isMyStore = @"Mine";
        [self.navigationController pushViewController:storeVC animated:YES];
    }
    else{
     [[AlertView sharedManager] presentAlertWithTitle:@"" message:@"Please fill store details first" andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle){}];
    }
}
#pragma mark - CarbonTabSwipeNavigation Delegate
// required
- (UIViewController *)carbonTabSwipeNavigation:(CarbonTabSwipeNavigation *)carbontTabSwipeNavigation viewControllerAtIndex:(NSUInteger)index
{
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
- (UIBarPosition)barPositionForCarbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation {
    return UIBarPositionTop; // default UIBarPositionTop
}
#pragma mark-Api Method

-(void)callApiForProfile
{
    [[ISServiceHelper helper]request:nil apiName:[NSString stringWithFormat:@"user/my_profile"] method:GET completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
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
                 [infoUser setString_State:[storeInfoDic objectForKeyNotNull:@"status" expectedObj:@""]];
                [infoUser setStore_background:[storeInfoDic objectForKeyNotNull:kStore_Background expectedObj:@""]];
                [infoUser setStore_logo:[storeInfoDic objectForKeyNotNull:kStore_Logo expectedObj:@""]];
                [infoUser setItem_count:[storeInfoDic objectForKeyNotNull:kItemCount expectedObj:@""]];
                
                [purchaseItemArray removeAllObjects];
                [favouriteItemArray removeAllObjects];
                [trackedItemArray removeAllObjects];
                
                purchaseItemArray = [self parseDataForPurchaseItem:[resultDict objectForKeyNotNull:kPurchaseItem expectedObj:[NSArray array]]];
                favouriteItemArray = [self parseDataForPurchaseItem:[resultDict objectForKeyNotNull:kFavouriteStore expectedObj:[NSArray array]]];
                trackedItemArray = [self parseDataForPurchaseItem:[resultDict objectForKeyNotNull:kFavouriteItem expectedObj:[NSArray array]]];
                
                self.purchageItemPagination = [ISPagination parseDataFromDict:[resultDict objectForKeyNotNull:@"purchase_view_page" expectedObj:[NSDictionary dictionary]]];
                self.storePagination = [ISPagination parseDataFromDict:[resultDict objectForKeyNotNull:@"stores_view_page" expectedObj:[NSDictionary dictionary]]];
                self.itemPagination = [ISPagination parseDataFromDict:[resultDict objectForKeyNotNull:@"items_view_page" expectedObj:[NSDictionary dictionary]]];

                [self initialMethod];
                
                [self.tableView_profile reloadData];
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

-(void)showErrorAlertWithTitle:(NSString*)error{
    [[AlertView sharedManager] presentAlertWithTitle:@"" message:error andButtonsWithTitle:@[@"OK"] onController:self dismissedWith:^(NSInteger index, NSString *buttonTitle){}];
}
@end
