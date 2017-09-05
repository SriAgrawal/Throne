//
//  ISDateUtility.h
//  Instasneaks
//
//  Created by Shridhar Agarwal on 12/09/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISDateUtility : NSObject

NSString *UTCDateFormateFromDate(NSDate *date);
+(NSString *)getDayAndTimeFromTimeStamp:(NSTimeInterval)dateInterval;
+(NSString *)getTimeFromTimeInterval:(NSTimeInterval) timeInterval;
+(NSDate *)getDateFromString:(NSString *)dateStr;

+(NSString*)getTimeFromTimeSatmp:(NSString *)timeStamp;
+ (NSDate *)getShortDateFromString:(NSString *)dateStr;
+(NSString *)convertTime:(NSString *)postDate;
@end
