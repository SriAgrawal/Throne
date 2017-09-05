//
//  ISStoreDetailVC.h
//  Instasneaks
//
//  Created by Shridhar Agarwal on 10/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@class ISDetailHeaderView;

@interface ISStoreDetailVC : UIViewController
@property(nonatomic,strong) NSString *storeId;
@property(nonatomic,strong) NSString *isMyStore;
@property (strong, nonatomic) ISDetailHeaderView *headerView;
@end
