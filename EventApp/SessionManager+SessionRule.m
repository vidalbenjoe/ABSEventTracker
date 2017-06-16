//
//  SessionManager+SessionRule.m
//  EventApp
//
//  Created by Benjoe Vidal on 15/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "SessionManager+SessionRule.h"
#import "Constants.h"
@implementation SessionManager (SessionRule)

-(void) updateSession{
    NSDate *start = [NSDate date];
    NSDate *end = [self sessionEnd];
    CFAbsoluteTime time = CFAbsoluteTimeGetCurrent();
    
    long startInterval = [start timeIntervalSince1970];
    long endInterval = [end timeIntervalSince1970];
  
    long startMinute = (startInterval / 1000) / 60;
    long endMinute = (endInterval / 1000) / 60;
    
    NSTimeInterval date = [start timeIntervalSinceReferenceDate];
    double milliseconds = date*1000;
    float seconds = milliseconds / 1000.0;
    float minutes = seconds / 60.0;
    
    NSLog(@"seconds: %f", minutes);
    
    //get milliseconds of the start then convert to minute

    
    NSLog(@"timwe: %f", time);
    
    NSLog(@"startInterval: %ld", startInterval);
    NSLog(@"endInterval %ld",endInterval);
    
    NSLog(@"startMinutes: %ld", startMinute);
    NSLog(@"endMinutes %ld",endMinute);
    
    NSLog(@"startTime %@",start);
    NSLog(@"endTime %@",start);
    
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
//    [self updateSession];
}

-(void) updateSessionID{
    [self setSessionID:RANDOM_ID];
}

@end
