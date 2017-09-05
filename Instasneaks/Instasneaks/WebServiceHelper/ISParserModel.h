//
//  ISParserModel.h
//  Instasneaks
//
//  Created by Suresh patel on 09/08/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISParserModel : NSObject

+(id)parseDataFromDict:(NSDictionary *)dict;

-(void)updateValueFromDict:(NSDictionary *)dict;

@end
