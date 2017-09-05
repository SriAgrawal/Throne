//
//  ISHappyThingViewController.h
//  Instasneaks
//
//  Created by Ankurgupta148 on 06/10/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

@protocol ISHappyThingViewControllerDelegate <NSObject>

- (void) didSelectItem:(NSString *)string atIndex:(NSUInteger)index;

@end

@class ISBrandDetailHeaderView;

@interface ISHappyThingViewController : UIViewController
@property (strong, nonatomic) NSString     *segmentType;
@property (strong, nonatomic) ISBrandDetailHeaderView   * headerView;
@property (strong, nonatomic) NSString     *searchString;
@property(nonatomic, strong) NSMutableArray * categoryArrayId;

@property (weak, nonatomic) id <ISHappyThingViewControllerDelegate> delegate;
@end
