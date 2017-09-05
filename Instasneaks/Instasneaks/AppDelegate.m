//
//  AppDelegate.m
//  Instasneaks
//
//  Created by Suresh patel on 15/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "AppDelegate.h"
#import "Branch.h"
#import "BTAppSwitch.h"
#import "Mixpanel/Mixpanel.h"
#import "HelpStack/HSHelpStack.h"
#import "HelpStack/HSGear.h"
#import "HelpStack/HSHappyFoxGear.h"
@interface AppDelegate ()<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    BOOL isAfterKill,isDeepLink;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    HSHelpStack *helpStack = [HSHelpStack instance];
    HSHappyFoxGear *hfGear = [[HSHappyFoxGear alloc] initWithInstanceUrl:@"https://mobiloitte.happyfox.com" apiKey:@"742e6ecb2ab541139b07953599497813" authCode:@"3bf801f53e8b45be97045e8c5cf49ec3" priorityID:@"1" categoryID:@"1"];
    helpStack.gear = hfGear;
    
     [Mixpanel sharedInstanceWithToken:@"25688a8e55635f99c3fe68f845cefd20"];
    
       Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"App Opened"
         properties:@{ @"Background color": @"Moody brown",
                       @"App open": @"absolutetly"
                       }];
    [BTAppSwitch setReturnURLScheme:@"com.mobiloitte.Instasneaks.payments"];
   
    Branch *branch = [Branch getInstance];
    //    [branch initSessionWithLaunchOptions:launchOptions andRegisterDeepLinkHandler:^(NSDictionary *params, NSError *error) {
    // if you want to specify isReferrable, then comment out the above line and uncomment this line:
    [branch initSessionWithLaunchOptions:launchOptions isReferrable:YES andRegisterDeepLinkHandler:^(NSDictionary *params, NSError *error) {
        if (!error)
        {
            if (isDeepLink == YES)
            {
                // params are the deep linked params associated with the link that the user clicked before showing up
                // params will be empty if no data found
                NSLog(@"param-->%@",params.description);
                [MBProgressHUD showHUDAddedTo:self.navController.view animated:YES];
                NSArray *linkData = [[params objectForKeyNotNull:@"~referring_link" expectedObj:@""] componentsSeparatedByString:@"="];
               
                [self performSelector:@selector(manageDeepLink:) withObject:[linkData lastObject] afterDelay:5.0];
            }
        }
    }];
    [self checkReachability];
    [self registerAppForPushNotification];
    [self getUserLocation];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    [Fabric with:@[[Twitter class]]];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    ISSignupVC * loginVC = [[ISSignupVC alloc] initWithNibName:@"ISSignupVC" bundle:nil];
    self.navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self.window setRootViewController:self.navController];
    [self.window makeKeyAndVisible];
    
    return YES;
}
-(void)checkReachability {
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        self.isReachable = [[AFNetworkReachabilityManager sharedManager] isReachable];
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

-(void)navigateToHome
{
    [self startLocation];
    self.tabBarController = [[ISTabBarController alloc] init];
    [self.navController pushViewController:self.tabBarController animated:NO];
}

-(void)registerAppForPushNotification{
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}
///*************** For Get Location ****************/
-(void)getUserLocation
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
    [self startLocation];
}
-(void)startLocation {
    [locationManager startUpdatingLocation];
}
-(void)stopLocation
{
    [locationManager stopUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
//     [[AlertView sharedManager] presentAlertWithTitle:@"" message:@"I want to get your location Information in background,please enable your location settings" andButtonsWithTitle:[NSArray arrayWithObject:@"Ok"] onController:self.navController dismissedWith:^(NSInteger index, NSString *buttonTitle)
//    {
//            [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
//        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: UIApplicationOpenSettingsURLString]];
////    [USERDEFAULT setValue:@"0" forKey:kLatitude];
////    [USERDEFAULT setValue:@"0" forKey:kLongitude];
////    [USERDEFAULT synchronize];
//     }];
 
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *location = [locations lastObject];
    self.userLocation = location.coordinate;
    self.currentLocation = location;
    
    [self getAdrressFromLatLong:location.coordinate.latitude lon:location.coordinate.longitude];
    [USERDEFAULT setValue:[NSString stringWithFormat:@"%.2f", location.coordinate.latitude] forKey:kLatitude];
    [USERDEFAULT setValue:[NSString stringWithFormat:@"%.2f", location.coordinate.longitude] forKey:kLongitude];
    [USERDEFAULT synchronize];
}
-(void)getAdrressFromLatLong:(CGFloat)lat lon:(CGFloat)lon {
    NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&amp;sensor=false",lat,lon];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    NSURLResponse *response = nil;
    NSError *requestError = nil;
    NSData *rep = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    //    NSData *responseData = [NSURLConnection sendSynchronousRequest:request error:&amp;requestError];
    NSDictionary *JSON;
    if (rep != nil) {
        JSON = [NSJSONSerialization JSONObjectWithData:rep options: NSJSONReadingMutableContainers error:nil];
    }
    
    NSArray *resultArray = [JSON objectForKeyNotNull:@"results" expectedObj:@""];
    NSDictionary *address = [resultArray firstObject];
    NSArray *arrayAddress = [[address objectForKeyNotNull:@"formatted_address" expectedObj:@""]componentsSeparatedByString:@","];
    [USERDEFAULT setValue:[arrayAddress lastObject] forKey:kCountryName];
    [USERDEFAULT synchronize];
       
}
//
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [FBSDKAppEvents activateApp];

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken{
    
    NSString * token= [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [USERDEFAULT setValue:token forKey:kDevice_Token];
    [USERDEFAULT synchronize];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [USERDEFAULT setValue:@"96ac623b87e95df72c3cce02bf6232f316a493b2c84d6c4ac54d89897d0da50f" forKey:kDevice_Token];
    [USERDEFAULT synchronize];
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
   
    [[Branch getInstance] handlePushNotification:userInfo];
    if (isAfterKill)
    {
        isAfterKill = NO;
    }else if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground || [UIApplication sharedApplication].applicationState == UIApplicationStateInactive)
    {
        [self manageNavigationForNotification:userInfo];
    }
    else if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        [self manageNavigationForNotification:userInfo];
    }
}

-(void)manageNavigationForNotification:(NSDictionary *)userInfo
{
    UIViewController * controller = [[[self.tabBarController selectedViewController] navigationController] visibleViewController];
    UINavigationController * navigationCont = [[self.tabBarController selectedViewController] navigationController];

    if ([[userInfo objectForKeyNotNull:@"alert_type" expectedObj:@""] isEqualToString:@"item_fav"] || [[userInfo objectForKeyNotNull:@"alert_type" expectedObj:@""] isEqualToString:@"product_sold"]) {
        
        [[AlertView sharedManager] presentAlertWithTitle:@"" message:[userInfo objectForKeyNotNull:@"message" expectedObj:@""] andButtonsWithTitle:@[@"Cancel", @"View"] onController:controller dismissedWith:^(NSInteger index, NSString *buttonTitle){
            
            if (index) {
                if ([controller isKindOfClass:[ISCollectionsContainerVC class]]){
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshScreenForTheItem" object:userInfo];
                }
                else{
                    
                    ISCollectionsContainerVC *storeVC = [[ISCollectionsContainerVC alloc] initWithNibName:@"ISCollectionsContainerVC" bundle:nil];
                    [storeVC setIsForItemDetail:YES];
                    [storeVC setItemId:[NSString stringWithFormat:@"%@", [userInfo objectForKeyNotNull:@"item_id" expectedObj:@""]]];
                    [navigationCont pushViewController:storeVC animated:YES];
                }
            }
        }];
    }
    else if ([[userInfo objectForKeyNotNull:@"alert_type" expectedObj:@""] isEqualToString:@"store_fav"]){
        
        [[AlertView sharedManager] presentAlertWithTitle:@"" message:[userInfo objectForKeyNotNull:@"message" expectedObj:@""] andButtonsWithTitle:@[@"Cancel", @"View"] onController:controller dismissedWith:^(NSInteger index, NSString *buttonTitle){
            
            if (index) {
                if ([controller isKindOfClass:[ISDetailContainerVC class]]){
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshScreenForTheStore" object:userInfo];
                }
                else{
                    
                    ISDetailContainerVC *storeVC = [[ISDetailContainerVC alloc] initWithNibName:@"ISDetailContainerVC" bundle:nil];
                    storeVC.storeId = [NSString stringWithFormat:@"%@", [userInfo objectForKeyNotNull:@"store_id" expectedObj:@""]];
                    [navigationCont pushViewController:storeVC animated:YES];
                }
            }
        }];
    }
    else{
        
        [[AlertView sharedManager] presentAlertWithTitle:@"" message:[userInfo objectForKeyNotNull:@"message" expectedObj:@""] andButtonsWithTitle:@[@"Ok"] onController:controller dismissedWith:^(NSInteger index, NSString *buttonTitle){
            
        }];
    }
}

-(UIViewController *)setSelectedViewControllerWithIndex:(NSInteger)index{
    
    [self.tabBarController setSelectedIndex:index];
    return [self.tabBarController selectedViewController];
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *restorableObjects))restorationHandler {
    BOOL handledByBranch = [[Branch getInstance] continueUserActivity:userActivity];
    
    return handledByBranch;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
    BOOL isFacebook;
    isFacebook = [[FBSDKApplicationDelegate sharedInstance] application:app openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    
    if ([url.scheme localizedCaseInsensitiveCompare:@"com.mobiloitte.Instasneaks.payments"] == NSOrderedSame) {
        return [BTAppSwitch handleOpenURL:url options:(NSDictionary *)options];
    }
    
    isDeepLink = [[Branch getInstance] handleDeepLink:url];
    return YES;
}
-(void)manageDeepLink:(NSString *) Id
{
    isDeepLink = NO;
    if ([Id isEqualToString:@"news"])
    {
        [self manageDeepLinkNews];
    }
    else if([Id containsString:@"Store"])
    {
        [self manageDeepLinkStore:Id];
    }
    else
    {
        UIViewController * controller = [[[self.tabBarController selectedViewController] navigationController] visibleViewController];
        UINavigationController * navigationCont = [[self.tabBarController selectedViewController] navigationController];
        
        if (isAfterKill)
        {
            isAfterKill = NO;
            
        }
        else if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground || [UIApplication sharedApplication].applicationState == UIApplicationStateInactive)
        {
            if ([controller isKindOfClass:[ISCollectionsContainerVC class]])
            {
                [MBProgressHUD hideHUDForView:self.navController.view animated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshChatScreen object:Id];
            }
            else
            {
                [MBProgressHUD hideHUDForView:self.navController.view animated:YES];
                ISCollectionsContainerVC *storeVC = [[ISCollectionsContainerVC alloc] initWithNibName:@"ISCollectionsContainerVC" bundle:nil];
                [storeVC setIsForItemDetail:YES];
                [storeVC setItemId:Id];
                [navigationCont pushViewController:storeVC animated:YES];
            }
        }
        else if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
        {
            UIViewController * controller = [[[self.tabBarController selectedViewController] navigationController] visibleViewController];
            if ([controller isKindOfClass:[ISCollectionsContainerVC class]])
            {
            [MBProgressHUD hideHUDForView:self.navController.view animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshChatScreen object:Id];
            }
            else
            {
                [MBProgressHUD hideHUDForView:self.navController.view animated:YES];
                ISCollectionsContainerVC *storeVC = [[ISCollectionsContainerVC alloc] initWithNibName:@"ISCollectionsContainerVC" bundle:nil];
                [storeVC setIsForItemDetail:YES];
                [storeVC setItemId:Id];
                [navigationCont pushViewController:storeVC animated:YES];
            }
        }
    }
}
-(void)manageDeepLinkStore:(NSString *)StoreId
{
    isDeepLink = NO;
    NSString * sId;
    NSScanner *scanner = [NSScanner scannerWithString:StoreId];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    // Throw away characters before the first number.
    [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
    // Collect numbers.
    [scanner scanCharactersFromSet:numbers intoString:&sId];
   UIViewController * controller = [[[self.tabBarController selectedViewController] navigationController] visibleViewController];
    UINavigationController * navigationCont = [[self.tabBarController selectedViewController] navigationController];
    if (isAfterKill)
    {
        isAfterKill = NO;
    }
    else if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground || [UIApplication sharedApplication].applicationState == UIApplicationStateInactive)
    {
        if ([controller isKindOfClass:[ISCollectionsContainerVC class]])
        {
            [MBProgressHUD hideHUDForView:self.navController.view animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshChatScreen object:sId];
        }
        else
        {
            [MBProgressHUD hideHUDForView:self.navController.view animated:YES];
            ISDetailContainerVC *storeVC = [[ISDetailContainerVC alloc] initWithNibName:@"ISDetailContainerVC" bundle:nil];
            storeVC.storeId = sId;
            [navigationCont pushViewController:storeVC animated:YES];
        }
    }
    else if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        UIViewController * controller = [[[self.tabBarController selectedViewController] navigationController] visibleViewController];
        if ([controller isKindOfClass:[ISCollectionsContainerVC class]])
        {
            [MBProgressHUD hideHUDForView:self.navController.view animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshChatScreen object:sId];
        }
        else
        {
            [MBProgressHUD hideHUDForView:self.navController.view animated:YES];
            ISDetailContainerVC *storeVC = [[ISDetailContainerVC alloc] initWithNibName:@"ISDetailContainerVC" bundle:nil];
            storeVC.storeId = sId;
            [navigationCont pushViewController:storeVC animated:YES];
        }
    }
}
-(void)manageDeepLinkNews
{
    isDeepLink = NO;
    if (isAfterKill)
    {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"KillDown" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [warningAlert show];
        
    }else if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground || [UIApplication sharedApplication].applicationState == UIApplicationStateInactive)
    {
        
        UIViewController * controller = [[[self.tabBarController selectedViewController] navigationController] visibleViewController];
        if ([controller isKindOfClass:[ISNewsFeedContainerVC class]])
        {
            [MBProgressHUD hideHUDForView:self.navController.view animated:YES];
        }
        else
        {
            [MBProgressHUD hideHUDForView:self.navController.view animated:YES];
            [self setSelectedViewControllerWithIndex:2];
        }
    }
    else if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        UIViewController * controller = [[[self.tabBarController selectedViewController] navigationController] visibleViewController];
        if ([controller isKindOfClass:[ISNewsFeedContainerVC class]])
        {
            [MBProgressHUD hideHUDForView:self.navController.view animated:YES];
        }
        else
        {
            [MBProgressHUD hideHUDForView:self.navController.view animated:YES];
            [self setSelectedViewControllerWithIndex:2];
        }
    }
}
@end
