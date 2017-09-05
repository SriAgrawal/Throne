//
//  ISServiceHelper.h
//  Instasneaks
//
//  Created by Suresh patel on 08/08/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Header.h"

typedef enum {
    GET = 0,
    POST = 1,
    DELETE = 2,
    PUT = 3,
    PATCH = 4
    
} Method;

typedef struct Page {
    NSInteger startIndex;
    NSInteger pageSize;
} PAGE;

@interface ISServiceHelper : NSObject

+ (ISServiceHelper *)helper;

- (void)request:(NSMutableDictionary *)parameterDict apiName:(NSString *)name method:(Method)methodType completionBlock:(void (^)(NSDictionary *resultDict, NSError *error))handler;


@end
