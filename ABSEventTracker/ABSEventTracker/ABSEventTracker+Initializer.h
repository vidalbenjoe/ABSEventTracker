//
//  ABSEventTracker+Initializer.h
//  ABSEventTracker
//
//  Created by Flydubai on 30/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <ABSEventTracker/ABSEventTracker.h>
#import "UserAttributes.h"
#import "EventAttributes.h"
@interface ABSEventTracker (Initializer)
+(void) initializeProperty;
+(void) initWithUser:(UserAttributes *) attributes;
+(void) initEventAttributes: (EventAttributes *) attributes;
@end