//
//  Header.h
//  Instasneaks
//
//  Created by Suresh patel on 15/07/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FacebookLogin : NSObject

+ (FacebookLogin *)sharedManager;

// facebook login
- (void)getFacebookInfoWithCompletionHandler:(UIViewController *)controller completionBlock:(void (^)(NSDictionary* dict, NSString* error))handler;
- (void)logOutFromFacebook;

@end
