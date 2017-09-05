//
//  ISBrandDetailContainerVC.h
//  Instasneaks
//
//  Created by Suresh patel on 13/09/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
@class ISBrandDetailHeaderView;
@interface ISBrandDetailContainerVC : MXSegmentedPagerController

@property(nonatomic, strong) NSString * brandName;
@property(nonatomic, strong) NSString * brandType;
@property(nonatomic, strong) NSString * categoryId;
@property(nonatomic, strong) NSMutableArray * categoryArrayId;
@property (strong, nonatomic) ISBrandDetailHeaderView     * headerView;
@property(nonatomic, assign) BOOL isFromSeacrh;
@end
