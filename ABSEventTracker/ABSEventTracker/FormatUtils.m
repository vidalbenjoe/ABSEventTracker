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

+(NSString *) dateFormatter:(NSDate *) date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    NSString *result = [formatter stringFromDate:date];
    return result;
}

+(NSString *) randomUUID{
    unsigned char bytes[128];
    int result = SecRandomCopyBytes(kSecRandomDefault, 128, bytes);
    if (result != noErr) {
        return nil;
    }
    NSString *randomUUID = [[NSUUID alloc] initWithUUIDBytes:bytes].UUIDString;
    return randomUUID;
}


@end
