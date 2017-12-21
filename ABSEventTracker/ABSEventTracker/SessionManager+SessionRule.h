//
//  SessionManager+SessionRule.h
/**********************************************************************
 **                                                                  **
 **                                                                  **
 **                        ABSEventTracker                           **
 **           Created by Benjoe Vidal on 31/05/2017.                 **
 **                 hello@benjoeriveravidal.com                      **
 **        Copyright © 2017 ABS-CBN. All rights reserved.            **
 **                                                                  **
 **                                                                  **
 **********************************************************************
 */
// SessionRule is responsible for updating and the sessionTime and sessionID
// The SessionRule is a category of SessionManager
#import "SessionManager.h"
@interface SessionManager (SessionRule)
-(void) startSession;
-(void) updateSession;
-(void) updateSessionID;
@end
