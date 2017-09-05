//
//  ISLockerVC.h
//  Instasneaks
//
//  Created by Suresh patel on 03/08/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
@class ISPagination;

@interface ISLockerVC : UIViewController

@property (strong, nonatomic) NSMutableArray *favoriteArray;
@property (strong, nonatomic) NSMutableArray *trackArray;
@property (strong, nonatomic) NSMutableArray *purchaseArray;
@property (assign, nonatomic) BOOL isFromOtherprofile;
@property (assign, nonatomic) BOOL isFromFavorite;
@property (assign, nonatomic) BOOL isFromPurchase;
@property (assign, nonatomic) BOOL isFromTrack;
@property (assign, nonatomic) NSUInteger indexPage;

@property (strong, nonatomic) ISPagination      * purchageItemPagination;
@property (strong, nonatomic) ISPagination      * storePagination;
@property (strong, nonatomic) ISPagination      * itemPagination;

@end
