//
//  PersistentVariant.h
//  EventApp
//
//  Created by Flydubai on 25/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersistentVariant : NSObject

@property(nonatomic, weak) NSString *bigDataSessionID;
@property(nonatomic, weak) NSString *sessionStartTimeStamp;
@property(nonatomic, weak) NSString *sessionEndTimeStamp;
@property(nonatomic, weak) NSString *applicationLaunchTimeStamp;

@end
