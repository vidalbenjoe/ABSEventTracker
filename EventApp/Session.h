//
//  Session.h
//  EventApp
//
//  Created by Benjoe Vidal on 31/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Session : NSObject
@property(nonatomic, strong) NSString *bigDataSessionID;
@property(nonatomic, strong) NSString *sessionStartStamp;
@property(nonatomic, strong) NSString *sessionEndTimeStamp;
@end
