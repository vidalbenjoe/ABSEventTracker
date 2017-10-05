//
//  SessionManager+SessionRule.m
//
//  Created by Benjoe Vidal on 15/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "SessionManager+SessionRule.h"
#import "Constant.h"
#import "FormatUtils.h"
@implementation SessionManager (SessionRule)

// Updating the session id by generation a random UUID.

-(void) startSession{
    NSDate *currentTime = [NSDate date];
    // Add 10 minutes expiration from the current time.
    NSDate *endtime = [currentTime dateByAddingTimeInterval:(DEFAULT_SESSION_EXPIRATION_IN_MINUTE(s)*60)];
    [self setSessionStart: currentTime];
    [self setSessionEnd:endtime];
    NSLog(@"OriginalSessionStart: %@", currentTime);
    NSLog(@"OriginalSessionEnd: %@", endtime);
}

-(void) updateSessionID{
    NSString *uuid = [FormatUtils randomUUID];
    [self setSessionID:uuid];
}
// Update the session time based on the last event
-(void) updateSessionTime{
    NSLog(@"OriginalSessionStartStatic: %@", [self sessionStart]);
    NSDate *currentTime = [NSDate date];
    // Add 10 minutes expiration from the current time.
//     NSDate *endtime = [currentTime dateByAddingTimeInterval:[currentTime timeIntervalSinceDate:[self sessionStart]]*60];
    
    NSDate *endtime = [currentTime dateByAddingTimeInterval:(DEFAULT_SESSION_EXPIRATION_IN_MINUTE(s)*60)];
    
    NSLog(@"subtrackDate: %f", [currentTime timeIntervalSinceDate:[self sessionStart] ]);
    float milli = [currentTime timeIntervalSinceDate:[self sessionStart]];
    float seconds = milli / 1000.0;
    float minutes = seconds / 60.0;
    
    NSLog(@"minutomoto: %f", minutes);
    
    NSLog(@"dateformula: %@", [currentTime dateByAddingTimeInterval:(2*60)]);

    if ([currentTime timeIntervalSinceDate:[self sessionEnd]] >= 0) {
        [self setSessionEnd:endtime];
    }else{
        NSDate *end = [currentTime dateByAddingTimeInterval:(DEFAULT_SESSION_EXPIRATION_IN_MINUTE(s)*60)];
        [self setSessionStart:currentTime];
        [self setSessionEnd:end];
    }
    
    
}

-(void) updateSession{
    NSDate *start = [NSDate date];
    NSDate *end = [self sessionEnd];
    /* Check if the current time is less than 30 minutes
     *
     */
    if ([start timeIntervalSinceDate:end] >= 0){
        // Update the session ID if the current time is greater than 30 minutes since the last triggered event
        [self updateSessionID];
    }else{
        // Update only the session time if the current time is less than 30 minutes.
        // The end time will be based on the updated start time.
        [self updateSessionTime];
    }
}

@end
