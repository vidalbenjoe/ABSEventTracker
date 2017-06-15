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
    NSDate *start = [self sessionStart];
    NSDate *end = [self sessionEnd];
    
    long startMinute = [start timeIntervalSinceReferenceDate];
    long endMinute = [end timeIntervalSinceReferenceDate];
    
    NSLog(@"startMinute: %ld", startMinute);
    NSLog(@"startMinute: %ld", endMinute);
    
    if ((endMinute - startMinute) <= 0) {
        [self updateSessionID];
        return;
    } else {
        [self updateSessionTime];
    }
}


-(void) updateSessionTime{
    NSDate *currentTime = [NSDate date];
    NSDate *add30Min = [currentTime dateByAddingTimeInterval:(DEFAULT_SESSION_EXPIRATION_IN_MINUTES*60)];
    
    [self setSessionStart:currentTime];
    [self setSessionEnd:add30Min];
    
    
}

-(void) updateSessionID{
    [self setSessionID:RANDOM_ID];
}

@end
