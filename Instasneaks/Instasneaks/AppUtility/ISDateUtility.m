//
//  ISDateUtility.m
//  Instasneaks
//
//  Created by Shridhar Agarwal on 12/09/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISDateUtility.h"
#define POSITIVE(n) ((n) < 0 ? 0 - (n) : (n))
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

@implementation ISDateUtility


/*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Getting UTC Date Formatted String <<<<<<<<<<<<<<<<<<<<<<<<*/

NSString *UTCDateFormateFromDate(NSDate *date) {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSZ"];
    
    return [dateFormat stringFromDate:date];
}


+(NSString *)getDayAndTimeFromTimeStamp:(NSTimeInterval)dateInterval {
    
    NSDate *eventDate = [NSDate dateWithTimeIntervalSince1970:dateInterval];
    
    NSDateComponents *components = [CURRENT_CALENDAR components:(NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date] toDate:eventDate options:0];
    
    
    NSString *dayAndTime = [NSString stringWithFormat:@"%ld,%ld,%ld,%ld",(long)[components month],(long)[components day],(long)[components hour],(long)[components minute]];
    
    return dayAndTime;
}

+(NSString *)getTimeFromTimeInterval:(NSTimeInterval) timeInterval
{
    
    double minutes = fmod(trunc(timeInterval / (60.0)), 60.0);
    double hours = trunc(timeInterval / (3600.0));
    return [NSString stringWithFormat:@"%.0f : %.0f",hours,minutes];
}

+(NSDate *)getDateFromString:(NSString *)dateStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssz"];
    
    return [dateFormatter dateFromString: dateStr];
    
}

+(NSString*)getTimeFromTimeSatmp:(NSString *)timeStamp {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp.integerValue];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"hh:mm a"];
    NSString *tempScheduleTime = [timeFormat stringFromDate:date];
    return tempScheduleTime;
}

+ (NSDate *)getShortDateFromString:(NSString *)dateStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    return [dateFormatter dateFromString: dateStr];
}

+(NSString *)convertTime:(NSString *)postDate {
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[postDate longLongValue]];
    
    NSString *dateStr = [dateFormat stringFromDate:date];
    NSDate *datePrevious = [dateFormat dateFromString:dateStr];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitSecond
                                               fromDate:datePrevious toDate:now options:0];
    
    if([difference second] > 3600*24)
    {
        NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                                   fromDate:date toDate:now options:0];
        return [NSString stringWithFormat:@"%ld day",(long)[difference day]];
        
    }
    else
        if(([difference second] > 3600) && ([difference second] < 3600*24))
        {
            NSDateComponents *difference = [calendar components:NSCalendarUnitHour
                                                       fromDate:date toDate:now options:0];
            return [NSString stringWithFormat:@"%ld hour",(long)[difference hour]];
            
        }
    else
        if(([difference second] > 60) && ([difference second] < 3600))
        {
            NSDateComponents *difference = [calendar components:NSCalendarUnitMinute
                                                       fromDate:date toDate:now options:0];
            return [NSString stringWithFormat:@"%ld minute",(long)[difference minute]];
        }
       else
        {
               return [NSString stringWithFormat:@"%ld second",(long)[difference second]];
        }
}
@end
