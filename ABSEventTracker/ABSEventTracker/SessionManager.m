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
@synthesize sessionEnd;

+(SessionManager*) init{
    static dispatch_once_t onceToken = 0;
    static id shared = nil;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}
// Establish a session
-(void) establish{
    [self updateSessionID];
    [self updateSessionTime];
}

// Update the session
-(void) update{
    [self updateSession];
}


@end
