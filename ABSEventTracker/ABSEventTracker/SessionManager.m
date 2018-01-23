//
//  SessionManager.m
//  EventApp
//
//  Created by Benjoe Vidal on 15/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "SessionManager.h"
#import "SessionManager+SessionRule.h"
@implementation SessionManager
@synthesize sessionID;
@synthesize sessionStart;
@synthesize eventTriggeredTime;
@synthesize sessionEnd;

+(instancetype) init{
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

@end
