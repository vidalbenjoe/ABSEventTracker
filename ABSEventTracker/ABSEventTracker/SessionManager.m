//
//  SessionManager.m
//  EventApp
//
//  Created by Benjoe Vidal on 15/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "SessionManager.h"
#import "FormatUtils.h"
#import "Constant.h"
#import "ABSEventTracker.h"
@implementation SessionManager
@synthesize sessionID;
@synthesize sessionStart;
@synthesize eventTriggeredTime;
@synthesize sessionEnd;

+(id) init{
    static SessionManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[super alloc] init];
    });
    return shared;
}
// Establish a session
-(void) establish{
    [self updateSessionID];
    [self startSession];
}

// Update the session
-(void) update{
    [self updateSession];
}


-(void) updateSessionID{
    NSString *uuid = [FormatUtils randomUUID];
    [self setSessionID:uuid];
}
-(void) startSession{
    NSDate *currentTime = [NSDate date];
    // Add 30 minutes expiration from the current time.
    NSDate *endtime = [currentTime dateByAddingTimeInterval:(DEFAULT_SESSION_EXPIRATION_IN_MINUTE(s)*60)];
    [self setSessionStart: currentTime];
    [self setSessionEnd:endtime];
}

// Update the session end time based on the last event
-(void) updateSessionTime{
    
    NSDate *currentTime = [NSDate date];
    // Add 30 minutes expiration from the current time.
    NSDate *endtime = [currentTime dateByAddingTimeInterval:(DEFAULT_SESSION_EXPIRATION_IN_MINUTE(s)*60)];
    [self setSessionEnd:endtime];
    
}

-(void) updateSession{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
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
    });
}
@end
