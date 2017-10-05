//
//  SessionManager+SessionRule.h
//  EventApp
//
//  Created by Benjoe Vidal on 15/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//
// SessionRule is responsible for updating and the sessionTime and sessionID
// The SessionRule is a category of SessionManager
#import "SessionManager.h"
@interface SessionManager (SessionRule)
-(void) startSession;
-(void) updateSession;
-(void) updateSessionID;
@end
