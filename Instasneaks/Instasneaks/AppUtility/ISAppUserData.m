//
//  ISAppUserData.m
//  Instasneaks
//
//  Created by Ankurgupta148 on 17/08/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISAppUserData.h"

@implementation ISAppUserData
+(id)sharedObject {
    static ISAppUserData *obj = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        obj = [[ISAppUserData alloc] init];
        obj.objectUserInfo = [[ISUserInfo alloc] init];
    });
    return obj;
}
@end
