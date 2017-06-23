//
//  SessionManager+SessionRule.m
//  EventApp
//
//  Created by Benjoe Vidal on 15/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "SessionManager+SessionRule.h"
#import "Constants.h"
#import "FormatUtils.h"
@implementation SessionManager (SessionRule)

-(void) updateSession{
    NSDate *start = [self sessionStart];
    NSDate *end = [self sessionEnd];

    NSTimeInterval startInterval = [start timeIntervalSinceReferenceDate];
    NSTimeInterval endInterval = [end timeIntervalSinceReferenceDate];
    double startmilliseconds = startInterval*1000;
    double endmilliseconds = endInterval*1000;
    long startMinute = [self convertStartMillisecondsToMinutes:startInterval];
    long endMinute = [self convertEndMillisecondsToMinutes:endInterval];
   
    //get milliseconds of the start then convert to minute
    NSLog(@"startSession: %@", start);
    NSLog(@"endSession: %@", end);
    
    NSLog(@"startInterval: %f", startInterval);
    NSLog(@"endInterval: %f", endInterval);
    
    NSLog(@"startmilliseconds: %f", startmilliseconds);
    NSLog(@"endmilliseconds: %f", endmilliseconds);
    
    NSLog(@"startMinute: %ld", startMinute);
    NSLog(@"endMinute: %ld", endMinute);
    NSLog(@"timeFormula %d", (endMinute - startMinute) <= 0);
    
    if ((endMinute - startMinute) <= 0) {
        [self updateSessionID];
        NSLog(@"updateSessionID");
        return;
    } else {
        [self updateSessionTime];
         NSLog(@"updateSessionTime");
    }
}

-(void) updateSessionTime{
    NSDate *currentTime = [NSDate date];
    NSDate *endtime = [currentTime dateByAddingTimeInterval:(DEFAULT_SESSION_EXPIRATION_IN_MINUTES*60)];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSDate *a = [dateFormat dateFromString:[FormatUtils getCurrentTimeAndDate:currentTime]];
    NSDate *b = [dateFormat dateFromString:[FormatUtils getCurrentTimeAndDate:endtime]];
    [self setSessionStart: a];
    [self setSessionEnd:b];
    NSLog(@"currentTime %@",a);
    NSLog(@"curentEndTime %@",b);
}

-(void) updateSessionID{
    NSString *uuid = [FormatUtils randomUUID];
    [self setSessionID:uuid];
}

-(float) convertStartMillisecondsToMinutes:(NSTimeInterval) timeInterval{
    double milliseconds = timeInterval * 1000;
    float seconds = milliseconds / 1000.0;
    float minutes = seconds / 60.0;
    NSLog(@"Startmilliseconds %f",milliseconds);
    return minutes;
}

-(float) convertEndMillisecondsToMinutes:(NSTimeInterval) timeInterval{
    double milliseconds = timeInterval * 1000;
    float seconds = milliseconds / 1000.0;
    float minutes = seconds / 60.0;
    NSLog(@"Endmilliseconds %f",milliseconds);
    return minutes;
}

@end
