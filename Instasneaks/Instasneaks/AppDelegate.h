//
//  AppDelegate.h
//  Instasneaks
//
//  Created by Suresh patel on 15/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
#import "MBProgressHUD.h"
#import <CoreLocation/CoreLocation.h>

@class ISTabBarController;
@class MBProgressHUD;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) ISTabBarController *tabBarController;
@property(strong,nonatomic) NSString *latitude;
@property(strong,nonatomic) NSString *longitude;
@property (nonatomic, strong) CLLocation * currentLocation;
@property (nonatomic, assign) CLLocationCoordinate2D userLocation;
@property (nonatomic, assign) BOOL isReachable;

-(void)navigateToHome;
-(UIViewController *)setSelectedViewControllerWithIndex:(NSInteger)index;
@end

