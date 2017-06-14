//
//  Session.h
//  EventApp
//
//  Created by Flydubai on 14/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Session : NSObject

@property(nonatomic, weak) NSString *bigDataSessionID;
@property(nonatomic, weak) NSString *sessionStartTimeStamp;
@property(nonatomic, weak) NSString *sessionEndTimeStamp;

@end
