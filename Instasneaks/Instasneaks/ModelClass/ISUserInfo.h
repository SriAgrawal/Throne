//
//  ISUserInfo.h
//  Instasneaks
//
//  Created by Suresh patel on 20/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ISParserModel.h"
#import "Header.h"

@interface ISUserInfo : ISParserModel

@property (strong, nonatomic) NSString * string_title;
@property (strong, nonatomic) NSString * string_detail;
@property (strong, nonatomic) NSString * string_UserName;
@property (strong, nonatomic) NSString * string_FirstName;
@property (strong, nonatomic) NSString * string_LastName;
@property (strong, nonatomic) NSString * string_DOB;
@property (strong, nonatomic) NSString * string_AccountNumber;
@property (strong, nonatomic) NSString * string_RoutingNumber;
@property (strong, nonatomic) NSString * string_Address;
@property (strong, nonatomic) NSString * string_ZipCode;
@property (strong, nonatomic) NSString * string_ContactNumber;
@property (strong, nonatomic) NSString * string_State;
@property (strong, nonatomic) NSString * string_StateCode;
@property (strong, nonatomic) NSString * string_Country;
@property (strong, nonatomic) NSString * string_City;
@property (strong, nonatomic) NSString * string_CVV;
@property (strong, nonatomic) NSString * string_CardNumber;
@property (strong, nonatomic) NSString * string_ExpiryDate;
@property (strong, nonatomic) NSString * string_paymentMode;
@property (strong, nonatomic) NSString * string_nonuce;
@property (strong, nonatomic) NSString * string_reviewTotal;
@property (strong, nonatomic) NSString * string_promoCode;

@property (strong, nonatomic) NSString * string_Purchase_FinalPrice;
@property (strong, nonatomic) NSString * string_Purchase_WorldPrice;
@property (strong, nonatomic) NSString * string_Purchase_NationalPrice;
@property (strong, nonatomic) NSString * string_Purchase_WhereToShip;
@property (strong, nonatomic) NSString * string_Lockers_WhereToShip;

@property (strong, nonatomic) NSString * string_Product_Name;
@property (strong, nonatomic) NSString * string_Product_Id;
@property (strong, nonatomic) NSString * string_Product_image;
@property (strong, nonatomic) NSString * string_Product_Color;
@property (strong, nonatomic) NSString * string_Product_Modal;
@property (strong, nonatomic) NSString * string_Product_Retail;
@property (strong, nonatomic) NSString * string_Product_AvgDcPrice;
@property (strong, nonatomic) NSString * string_Product_AvgUsedPrice;
@property (strong, nonatomic) NSString * string_Product_DsRangeLow;
@property (strong, nonatomic) NSString * string_Product_DsRangeHigh;
@property (strong, nonatomic) NSString * string_Product_PayoutPrice;
@property (strong, nonatomic) NSString * string_Product_Ptype;
@property (strong, nonatomic) NSString * string_Product_Favourite;
@property (strong, nonatomic) NSString * string_Product_Price;
@property (strong, nonatomic) NSString * string_Product_Category;

@property (assign, nonatomic) BOOL isTapped;
@property (assign, nonatomic) BOOL isSelected;
@property (assign, nonatomic) BOOL isItemSelected;


// User Related Parameter

@property (assign, nonatomic) NSUInteger id;
@property (strong, nonatomic) NSString * userId;
@property (strong, nonatomic) NSString * email;
@property (strong, nonatomic) NSString * role;
@property (strong, nonatomic) NSString * full_name;
@property (strong, nonatomic) NSString * user_image;
@property (strong, nonatomic) NSString * name;

@property (strong, nonatomic) NSString * image;
@property (strong, nonatomic) NSString * promo_code;
@property (strong, nonatomic) NSString * color_code;
@property (assign, nonatomic) CGFloat    wallet;
@property (strong, nonatomic) NSString * authentication_token;
@property (strong, nonatomic) NSString * social_link;
@property (strong, nonatomic) NSString * closet_Value;
@property (strong, nonatomic) NSString *invites_Accepted ;
@property (strong, nonatomic) NSString * string_shipping_id;

@property (strong, nonatomic) NSString * merchant_account_id;
@property (strong, nonatomic) NSString * merchant_account_status;
@property (strong, nonatomic) NSString * brain_tree_id;

@property (strong, nonatomic) NSString * string_Category_Name;
@property (strong, nonatomic) NSString * string_Category_image;
@property (strong, nonatomic) NSString * string_Category_id;

@property (strong, nonatomic) NSString * string_buyer_id;
@property (strong, nonatomic) NSString * string_seller_id;
@property (strong, nonatomic) NSString * string_listing_id;
@property (strong, nonatomic) NSString * string_created_at;

@property (strong, nonatomic) UIImage  * itemImage;

@property(strong, nonatomic) NSMutableArray     * buyersDataArray;

@property(strong, nonatomic) NSMutableArray     * buyersImageArray;
@property(strong, nonatomic) NSMutableArray     * storeItemArray;


// Filter Related Parameter

@property (strong, nonatomic) NSString * string_SearchText;
@property (strong, nonatomic) NSString * string_itemSize;
@property (strong, nonatomic) NSString * string_itemCondition;
@property (strong, nonatomic) NSString * string_itemColor;
@property (strong, nonatomic) NSString * string_gender;
@property (strong, nonatomic) NSString * string_itemSort;
@property (strong, nonatomic) NSString * string_itemBrandName;


// SelectSize Related Parameter

@property (strong, nonatomic) NSString * string_SelectSize;
@property (strong, nonatomic) NSString * string_SelectPrice;
@property (strong, nonatomic) NSString * string_SelectCondition;

// Community Screen Parameters

@property (strong, nonatomic) NSString * string_community_id;
@property (strong, nonatomic) NSString * string_community_title;
@property (strong, nonatomic) NSString * string_community_content;
@property (strong, nonatomic) NSString * string_community_media;
@property (strong, nonatomic) NSString * string_community_clicks;
@property (strong, nonatomic) NSString * string_community_vedioUrl;
@property (strong, nonatomic) NSString * string_community_Url;
@property (strong, nonatomic) NSString * string_community_createDate;
@property (strong, nonatomic) NSString * string_community_type;

// Static Data Parameters
@property (strong, nonatomic) NSString *contentFaq;
@property (strong, nonatomic) NSString *string_Comment;


// Notification Parameters
@property (assign, nonatomic) BOOL isNews;
@property (assign, nonatomic) BOOL isFriend_joint;
@property (assign, nonatomic) BOOL isItem_shipped;


// Recent Activity
@property (strong, nonatomic) NSString *recentId;
@property (strong, nonatomic) NSString *recentMessage;
@property (strong, nonatomic) NSString *recentNotiableId;
@property (strong, nonatomic) NSString *recentNotiableType;
@property (strong, nonatomic) NSString *recentSenderId;


// Became Seller Parameters
@property (strong, nonatomic) NSString *string_ItemType;
@property (strong, nonatomic) NSString *string_OtherType;
@property (strong, nonatomic) NSString *string_Facebook;
@property (strong, nonatomic) NSString *string_Twitter;
@property (strong, nonatomic) NSString *string_Website;
@property (strong, nonatomic) NSString *string_Ebay;
@property (strong, nonatomic) NSString *string_Instagram;



@property (assign, nonatomic) NSString*  purchase_count;
@property (assign, nonatomic) NSString*  item_count;
@property (strong, nonatomic) NSString * price;
@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSString * store_id;
@property (assign, nonatomic) NSUInteger isStore;
@property (strong, nonatomic) NSString * item_id;
@property (strong, nonatomic) NSString * store_name;
@property (strong, nonatomic) NSString * store_background;
@property (strong, nonatomic) NSString * store_logo;
@property (strong, nonatomic) NSString * item_description;
@property (strong, nonatomic) NSString * shipping_location;

@property (strong, nonatomic) NSString * string_Purchase_Id;
@property (strong, nonatomic) NSString * string_Purchase_image;
@property (strong, nonatomic) NSString * string_Favorite_Id;
@property (strong, nonatomic) NSString * string_Favorite_image;
@property (strong, nonatomic) NSString * string_Track_Id;
@property (strong, nonatomic) NSString * string_Track_image;
@property (strong, nonatomic) NSString *string_Star_Rating;
@end
