//
//  HappyViewController.h
//  Instasneaks
//
//  Created by Ankurgupta148 on 06/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@interface HappyViewController : UIViewController
@property (assign, nonatomic) NSInteger     index;
@property (strong, nonatomic) ISBrandDetailHeaderView   * headerView;
@property (strong, nonatomic) IBOutlet UIView           * view_topBarView;
@property(nonatomic, strong) NSMutableArray * categoryArrayId;
@property (strong, nonatomic) NSString                  * searchString;

@end
