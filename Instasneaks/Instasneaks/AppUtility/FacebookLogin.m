//
//  Header.h
//  Instasneaks
//
//  Created by Suresh patel on 15/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "FacebookLogin.h"
#import "Header.h"


@implementation FacebookLogin

+ (FacebookLogin *)sharedManager {
    
    static FacebookLogin *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[FacebookLogin alloc] init];
    });
    return _sharedManager;
}

#pragma mark - Facebook methods

// This method will handle ALL the session state changes in the app

- (void)getFacebookInfoWithCompletionHandler:(UIViewController *)controller completionBlock:(void (^)(NSDictionary* dict, NSString* error))handler {
    
    if (![APPDELEGATE isReachable]){
        handler(nil,@"Unable to connect network. Please check your internet connection.");
        return ;
    }
    
    [self callFacebookLoginWithCompletionBlock:controller completionBlock:^(NSDictionary *dict, NSString *error) {
        handler(dict, error);
    }];
    
}

- (void)callFacebookLoginWithCompletionBlock:(UIViewController *)controller completionBlock:(void (^)(NSDictionary* dict, NSString* error))handler {
//    /picture.type(large)
    NSMutableDictionary *requsetDict = [NSMutableDictionary dictionary];
    [requsetDict setValue:@"id,name,first_name,last_name,gender,email,birthday,picture.type(large)" forKey:@"fields"];
    //[requsetDict setValue:@"locale" forKey:@"en_US"];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:requsetDict]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             handler(result,[error localizedDescription]);
         }];
    } else {
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        
        [loginManager logInWithReadPermissions:[NSArray arrayWithObjects:@"email", @"public_profile", @"user_photos", nil] fromViewController:controller handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            
            if (error) {
                handler(nil,@"Processing Error. Please try again!");
                [self logOutFromFacebook];
                
            } else if (result.isCancelled) {
                handler(nil,@"Request cancelled!");
                
                [self logOutFromFacebook];
                
            } else {
                
                //Getting Basic data from facebook
                [FBSDKAccessToken setCurrentAccessToken:result.token];
                if ([FBSDKAccessToken currentAccessToken]) {
                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:requsetDict]
                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                         handler(result,[error localizedDescription]);
                     }];
                }
            }
            
        }];
    }
}

- (void)logOutFromFacebook {
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [FBSDKProfile setCurrentProfile:nil];
}

@end
