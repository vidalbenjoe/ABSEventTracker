//
//  SessionAttributes.h
//  EventApp
//
//  Created by Benjoe Vidal on 26/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionAttributes : NSObject

@property(nonatomic, assign) NSString *sessionID;
@property(nonatomic, assign) NSString *sessionStart;
@property(nonatomic, assign) NSString *sessionEnd;

@end
