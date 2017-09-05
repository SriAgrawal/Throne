//
//  ISCollectionsContainerVC.h
//  Instasneaks
//
//  Created by Suresh patel on 27/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@interface ISCollectionsContainerVC : MXSegmentedPagerController

@property (assign, nonatomic) BOOL  isForItemDetail;
@property (strong, nonatomic) NSString * itemId;

@end
