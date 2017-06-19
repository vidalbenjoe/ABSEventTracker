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
    
    long startMinute = [self convertStartMillisecondsToMinutes:startInterval];
    long endMinute = [self convertEndMillisecondsToMinutes:endInterval];
   
    //get milliseconds of the start then convert to minute
    NSLog(@"timwe: %f", startInterval);

    if ((endMinute - startMinute) <= 0) {
        [self updateSessionID];
        return;
    } else {
        [self updateSessionTime];
    }
}

-(void) updateSessionTime{
    NSDate *currentTime = [NSDate date];
    NSDate *endtime = [currentTime dateByAddingTimeInterval:(DEFAULT_SESSION_EXPIRATION_IN_MINUTES*60)];
    [self setSessionStart:currentTime];
    [self setSessionEnd:endtime];
    NSLog(@"currentTime %@",currentTime);
    NSLog(@"curentEndTime %@",endtime);
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
