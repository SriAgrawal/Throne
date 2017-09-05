//
//  ISBrandDetailsVC.h
//  Throne
//
//  Created by Shridhar Agarwal on 15/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
@class ISBrandDetailHeaderView;

@interface ISBrandDetailsVC : UIViewController
@property(nonatomic,strong) NSString * brandName;
@property(nonatomic,strong) NSString * brandType;
@property(nonatomic,strong) NSString * categoryId;

@property (strong, nonatomic) ISBrandDetailHeaderView     *headerView;

@end
