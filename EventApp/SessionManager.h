//
//  SessionManager.h
//  EventApp
//
//  Created by Benjoe Vidal on 15/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionManager : NSObject
@property(nonatomic, assign) int sessionID;
@property(nonatomic, assign) NSDate *sessionStart;
@property(nonatomic, assign) NSDate *sessionEnd;

-(void) establish;
-(void) update;

@end
