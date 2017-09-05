//
//  NSDictionary+NullChecker.m
//  PartyApp
//
//  Created by KrishnaKant kaira on 04/03/14.
//  Copyright (c) 2014 Mobiloitte. All rights reserved.
//

#import "NSDictionary+NullChecker.h"

@implementation NSDictionary (NullChecker)

-(id)objectForKeyNotNull:(id)key expectedObj:(id)obj {
    
    id object = [self objectForKey:key];
    
    if (object == nil){
        return obj;
    }
   	if (object == [NSNull null])
        return obj;
    
    if ([object isKindOfClass:[NSNumber class]]) {
        CFNumberType numberType = CFNumberGetType((CFNumberRef)object);
        if (numberType == kCFNumberFloatType || numberType == kCFNumberDoubleType || numberType == kCFNumberFloat32Type || numberType == kCFNumberFloat64Type) {
            return [NSString stringWithFormat:@"%f",[object floatValue]];
            
        }else{
            return [NSString stringWithFormat:@"%ld",(long)[object integerValue]];
            
        }
    }
    
    return object;
}

-(id)objectForKeyNotNull:(id)key {
    id object = [self objectForKey:key];
    if([object isKindOfClass:[NSString class]]){
        if ([object isEqualToString:@"<null>"]||[object isEqualToString:@"(null)"]) {
            return @"";
        }
    }
    
    if (object == nil){
        return @"";
    }
   	if (object == [NSNull null])
        return @"";
    return object;
}

@end
