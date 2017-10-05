//
//  SessionManager.h
//  EventApp
//
//  Created by Benjoe Vidal on 15/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface SessionManager : NSObject
@property(nonatomic, copy) NSString *sessionID;
@property(nonatomic, retain) NSDate *sessionStart;
@property(nonatomic, retain) NSDate *eventTriggeredTime;
@property(nonatomic, retain) NSDate *sessionEnd;
+(instancetype) init;
-(void) establish;
-(void) update;
@end
