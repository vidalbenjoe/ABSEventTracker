//
//  ABSEventTracker.h
//  EventApp
//
//  Created by Flydubai on 31/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceInvariant.h"
#import "UserAttributes.h"
#import "PropertyEventSource.h"
#import "AttributeManager.h"
@interface ABSEventTracker : NSObject

+(id) init;
+(void) initWithUser:(UserAttributes *) attributes;
+(void) initWithDevice:(DeviceInvariant *) attributes;

@end
