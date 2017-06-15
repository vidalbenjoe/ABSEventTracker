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

-(void) establish{
    [self updateSessionID];
    [self updateSessionTime];
}

-(void) update{
    [self updateSession];
}

@end
