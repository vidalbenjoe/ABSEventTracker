//
//  SessionManager+SessionRule.m
//  EventApp
//
//  Created by Benjoe Vidal on 15/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "SessionManager+SessionRule.h"
#import "Constant.h"
#import "FormatUtils.h"
@implementation SessionManager (SessionRule)

// Updating the session id by generation a random UUID.
-(void) updateSessionID{
    NSString *uuid = [FormatUtils randomUUID];
    
    [self setSessionID:uuid];
}
// Update the session time based on the last event
-(void) updateSessionTime{
    NSDate *currentTime = [NSDate date];
    // Add 10 minutes expiration from the current time.
    NSDate *endtime = [currentTime dateByAddingTimeInterval:(DEFAULT_SESSION_EXPIRATION_IN_MINUTE(s)*60)];
    [self setSessionStart: currentTime];
    [self setSessionEnd:endtime];
}

-(void) updateSession{
    NSDate *start = [NSDate date];
    NSDate *end = [self sessionEnd];
    /* Check if the current time is less than 10 minutes
     *
     */
    if ([end timeIntervalSinceDate:start] >= 0){
        // Update the session ID if the current time is greater than 10 minutes since the last triggered event
        [self updateSessionID];
    }else{
        // Update only the session time if the current time is less than 10 minutes.
        // The end time will be based on the updated start time.
        [self updateSessionTime];
    }
}

@end
