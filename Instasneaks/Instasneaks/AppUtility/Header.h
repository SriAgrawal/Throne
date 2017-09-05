//
//  Header.h
//  Instasneaks
//
//  Created by Suresh patel on 15/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#ifndef Header_h
#define Header_h


#define USERDEFAULT  [NSUserDefaults standardUserDefaults]
#define APPDELEGATE (AppDelegate *)[[UIApplication sharedApplication] delegate]
#define TRIM_SPACE(str) [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
#define BDTextField(tag)     (UITextField*)[self.view viewWithTag:tag]
#define WIN_HEIGHT [[UIScreen mainScreen]bounds].size.height
#define WIN_WIDTH [[UIScreen mainScreen]bounds].size.width
#define IS_IPHONE4 [[UIScreen mainScreen]bounds].size.height == 480

#define lblTag(tag)         (UILabel *)[self.view viewWithTag:tag]
#define KTextField(tag)       (UITextField*)[self.view viewWithTag:tag]
#define ButtonTag(tag)         (UIButton *)[self.view viewWithTag:tag]
#define NEO_SANS_PRO_REGULAR(X) [UIFont fontWithName:@"NeoSansPro-Regular" size:X]


#define KAlert_InValid_Address                      @"Please enter valid address."
#define KAlert_Empty_Name                           @"Please enter first name."
#define KAlert_InValid_Name                         @"Please enter valid first name."
#define KAlert_Empty_Phone                          @"Please enter phone no."
#define KAlert_Invalid_Phone                        @"Please enter valid phone no."
#define KAlert_Empty_Address                        @"Please enter address."
#define KAlert_Empty_City                           @"Please enter city."
#define KAlert_Empty_State                          @"Please enter state."
#define KAlert_Empty_Country                        @"Please select country."
#define KAlert_Empty_Zipcode                        @"Please enter zip code."
#define KAlert_Invalid_Zipcode                      @"Please enter valid zip code."

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <SYPhotoBrowser/SYPhotoBrowser.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import  "Mixpanel/Mixpanel.h"
#import "HelpStack/HSHelpStack.h"
#import "HelpStack/HSGear.h"
#import <SDWebImage/UIImageView+WebCache.h>

//***************************External Classes *********************************//

#import "ISConstant.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "ISServiceHelper.h"
#import "MJPopupBackgroundView.h"
#import "NSDictionary+NullChecker.h"
#import "UIViewController+MJPopupViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MXSegmentedPager.h"
#import "MXSegmentedPagerController.h"
#import "DatePickerSheetView.h"
#import "BDVCountryNameAndCode.h"
//**************************CategoryClass*************************//

#import "UIView+Addition.h"
#import "PlaceholderTextView.h"
#import "PATextField.h"
#import "NSString+Validator.h"
//**************************CustomClass*************************//

#import "CarbonKit.h"
#import "TPKeyboardAvoidingTableView.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UIScrollView+TPKeyboardAvoidingAdditions.h"
#import "OptionsPickerSheetView.h"
#import "CameraSessionView.h"
#import "CameraToggleButton.h"
#import "CameraFlashButton.h"
#import "CameraDismissButton.h"
#import "CameraFocalReticule.h"
#import "Constants.h"
#import "CaptureSessionManager.h"
#import "CameraShutterButton.h"
#import "YActionSheet.h"
#import "TTTAttributedLabel.h"
#import "JTSImageInfo.h"
#import "JTSImageViewController.h"
#import "JTSAnimatedGIFUtility.h"
#import "UIApplication+JTSImageViewController.h"
#import "HCSStarRatingView.h"
#import "DropDownListView.h"

//***************************View Controllers*************************//

#import "ISLoginVC.h"
#import "ISTabBarController.h"
#import "ISCollectionsVC.h"
#import "ISProfileVC.h"
#import "ISShopCollectionsVC.h"
#import "ISNewsListVC.h"
#import "ISBrandDetailsVC.h"
#import "ISBuyPaymentVC.h"
#import "ISEditProfileVC.h"
#import "ISSettingVC.h"
#import "ISNotificationVC.h"
#import "ISHelpFAQVC.h"
#import "ISSocialVC.h"
#import "ISRecentActivityVC.h"
#import "ISNewsDetailVC.h"
#import "ISHelpVC.h"
#import "ISFAQVC.h"
#import "ISPrivacyPolicyVC.h"
#import "ISSortVC.h"
#import "ISLogoutPopUpVC.h"
#import "ISSelectSizeVC.h"
#import "ISInviteFriendsVC.h"
#import "ISWalletVC.h"
#import "ISUploadListVC.h"
#import "ISSignupVC.h"
#import "ISLockerVC.h"
#import "ISSignUpInvitaitionVC.h"
#import "ISAddToDropViewController.h"
#import "ISAddToDropContainerVC.h"
#import "ISOtherProfileVC.h"
#import "ISBrandListContainerVC.h"
#import "ISBrandDetailContainerVC.h"
#import "ISNewsFeedContainerVC.h"
#import "ISDirectoryViewController.h"
#import "ISFeaturedViewController.h"
#import "ISShopByStoreContainorVC.h"
#import "ISSubmitCategoryVC.h"
#import "ISThankYouItemVC.h"
#import "ISBecameSellerVC.h"
#import "ISShopSearchVC.h"
#import "ISShopSearchHeaderVC.h"
#import "ISStoreDetailVC.h"
#import "ISHappyThingViewController.h"
#import "HappyViewController.h"
#import "ISShopViewController.h"
#import "ISDetailContainerVC.h"
#import "ISCollectionsContainerVC.h"

#import "ISAddToDropHeaderView.h"
#import "ISBrandListHeaderView.h"
#import "ISBrandDetailHeaderView.h"
#import "ISNewsHeaderView.h"
#import "ISShopByStoreHeaderView.h"
#import "ISShopCollectionHeaderView.h"
#import "ISDetailHeaderView.h"

//********************** Custom UITableViewCells*********************//
#import "ISPaymentHeaderCell.h"
#import "ISItemDetailCell.h"
#import "ISNewsFeedCell.h"
#import "ISBrandSizeTableCell.h"
#import "ISProfileCell.h"
#import "ISPaymentCardsCell.h"
#import "ISShipingAddressCell.h"
#import "ISShippingCell.h"
#import "ISNotificationCell.h"
#import "ISSettingTableCell.h"
#import "ISFAQCell.h"
#import "ISRecentActivityCell.h"
#import "ISFilterCell.h"
#import "ISSelectSizeCell.h"
#import "ISInviteFriendsCell.h"
#import "ISWalletCell.h"
#import "ISUploadListCell.h"
#import "ISBuyersCell.h"
#import "ISRecieverChatCell.h"
#import "ISSenderChatCell.h"
#import "UploadPriceCell.h"
#import "ISShippingDeliveryCell.h"
#import "ISFavouriteCell.h"
#import "ISProductDetailCell.h"
#import "ISHomeCollectionCells.h"
#import "ISHomeTableCell.h"
#import "ISFeaturedCololectionCell.h"
#import "ISSellerTableCell.h"
#import "ISSeactionHeaderCell.h"
#import "ISSeachTableCell.h"

//********************** Custom UICollectionViewCells*********************//

#import "ISCollectionsCell.h"
#import "ISShopCollectionsCell.h"
#import "ISBrandDetailsCollectionCell.h"
#import "ISBuyCollectionCell.h"
#import "ISUsedCollectionCell.h"
#import "ISStoreCollectionCell.h"
#import "ISShopCollectionViewCell.h"
#import "ThingCollectionViewCell.h"

//***************************Modal class*************************/
#import "ISUserInfo.h"
#import "ISPagination.h"

//***************************Utility class*************************/

#import "AppDelegate.h"
#import "FacebookLogin.h"
#import "KTSContactsManager.h"
#import "AlertView.h"
#import "ISAppUserData.h"

#endif /* Header_h */
