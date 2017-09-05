//
//  ISDetailContainerVC.h
//  Instasneaks
//
//  Created by Suresh patel on 19/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@interface ISDetailContainerVC : MXSegmentedPagerController
@property(nonatomic,strong) NSString *storeId;
@property(nonatomic,strong) NSString *isMyStore;
@end
