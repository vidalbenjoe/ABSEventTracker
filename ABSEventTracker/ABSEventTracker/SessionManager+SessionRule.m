//
//  SessionManager+SessionRule.m
//
//  Created by Benjoe Vidal on 15/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "SessionManager+SessionRule.h"
#import "Constant.h"
#import "FormatUtils.h"
#import "ABSEventTracker.h"
@implementation SessionManager (SessionRule)

// Updating the session id by generation a random UUID.

-(void) startSession{
    NSDate *currentTime = [NSDate date];
    // Add 30 minutes expiration from the current time.
    NSDate *endtime = [currentTime dateByAddingTimeInterval:(DEFAULT_SESSION_EXPIRATION_IN_MINUTE(s)*60)];
    [self setSessionStart: currentTime];
    [self setSessionEnd:endtime];
}

-(void) updateSessionID{
    NSString *uuid = [FormatUtils randomUUID];
    [self setSessionID:uuid];
}
// Update the session end time based on the last event
-(void) updateSessionTime{
    NSDate *currentTime = [NSDate date];
    // Add 30 minutes expiration from the current time.
    NSDate *endtime = [currentTime dateByAddingTimeInterval:(DEFAULT_SESSION_EXPIRATION_IN_MINUTE(s)*60)];
    [self setSessionEnd:endtime];
}

-(void) updateSession{
    NSDate *start = [NSDate date];
    /* Check if the current time is less than 30 minutes
     */
    if ([start timeIntervalSinceDate:[self sessionEnd]] >= 0){
        /* Update the session ID if the current time is greater than 30 minutes since the last triggered event
         */
        [self updateSessionID];
        /*  Update the SessionEndTime and sessionStartTime if the current time is less than the sessionEndTime - Meaning the session is expired, and you have to initialize another session
         */
        [ABSEventTracker initEventAttributes:[EventAttributes makeWithBuilder:^(EventBuilder *buider) {
            [buider setActionTaken:SESSION_EXPIRED];
        }]];

        NSDate *end = [start dateByAddingTimeInterval:(DEFAULT_SESSION_EXPIRATION_IN_MINUTE(s)*60)];
        [self setSessionStart:start];
        [self setSessionEnd:end];
    }else{
        // Update only the session time if the current time is less than 30 minutes.
        // The end time will be based on the updated start time.
        [self updateSessionTime];
    }
}

@end
