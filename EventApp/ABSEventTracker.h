//
//  ABSEventTracker.h
//  EventApp
//
//  Created by Benjoe Vidal on 31/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceInvariant.h"
#import "UserAttributes.h"
#import "PropertyEventSource.h"
#import "AttributeManager.h"
#import "Constants.h"
#import <UIKit/UIKit.h>
@interface ABSEventTracker : NSObject<UIApplicationDelegate>
@property(nonatomic) EventAttributes *events;
+(ABSEventTracker *) init;
+(void) initEventAttributes: (EventAttributes *) attributes;
+(void) initWithUser:(UserAttributes *) attributes;
@end
