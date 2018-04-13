//
//  FormatUtils.m
//  EventApp
//
//  Created by Benjoe Vidal on 15/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "FormatUtils.h"
#import <objc/runtime.h>
@implementation FormatUtils

+(NSString*) getCurrentTimeAndDate: (NSDate *) date{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setCalendar:calendar];
    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    return [dateFormat stringFromDate:date];
}

/*
 * This method will generate randomUUID that will be used for sessionID @SessionManager
 */
+(NSString *) randomUUID{
    unsigned char bytes[128];
    int result = SecRandomCopyBytes(kSecRandomDefault, 128, bytes);
    if (result != noErr) {
        return nil;
    }
    NSString *randomUUID = [[NSUUID alloc] initWithUUIDBytes:bytes].UUIDString;
    return randomUUID;
}

/*
 * This method will get the time difference between the two timestamp;
 */
+(NSInteger) timeDifferenceInSeconds: (NSDate *) start endTime: (NSDate *) end{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitSecond;
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:start
                                                  toDate:end options:0];
    NSInteger elapse = [components second];
    
    NSLog(@"ViewPageDuration: %ld", (long)elapse);
    return elapse;
}

@end
