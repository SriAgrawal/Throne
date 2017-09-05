//
//  ISAppUserData.h
//  Instasneaks
//
//  Created by Ankurgupta148 on 17/08/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Header.h"
@class ISUserInfo;
@interface ISAppUserData : NSObject
@property (nonatomic,strong)ISUserInfo *objectUserInfo;
+(id)sharedObject;
@end
