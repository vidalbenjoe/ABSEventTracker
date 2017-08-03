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

-(void) updateSessionID{
    NSString *uuid = [FormatUtils randomUUID];
    [self setSessionID:uuid];
}

-(void) updateSessionTime{
    NSDate *currentTime = [NSDate date];
    NSDate *endtime = [currentTime dateByAddingTimeInterval:(DEFAULT_SESSION_EXPIRATION_IN_MINUTES*60)];
    [self setSessionStart: currentTime];
    [self setSessionEnd:endtime];
}

-(void) updateSession{
    NSDate *start = [NSDate date];
    NSDate *end = [self sessionEnd];
    if ([end timeIntervalSinceDate:start] >= 0){
        [self updateSessionID];
        NSLog(@"updateSessionID");
    }else{
        [self updateSessionTime];
        NSLog(@"updateSessionTime");
    }
}


@end
