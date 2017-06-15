//
//  AttributeManager.h
//  EventApp
//
//  Created by Benjoe Vidal on 25/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventAttributes.h"
#import "UserAttributes.h"
#import "PropertyEventSource.h"
#import "DeviceInvariant.h"
#import "SessionManager.h"
@interface AttributeManager : NSObject <NSCoding>
+(AttributeManager*) init;

@property(nonatomic) EventAttributes *eventattributes;
@property(nonatomic) UserAttributes *userattributes;
@property(nonatomic) PropertyEventSource *propertyinvariant;
@property(nonatomic) DeviceInvariant *deviceinvariant;
@property(nonatomic) SessionManager *session;

-(void) setEventAttributes:(EventAttributes*) eventAttributes;
-(void) setUserAttributes:(UserAttributes *) userAttributes;
-(void) setPropertyAttributes:(PropertyEventSource *) propertyAttributes;
-(void) setDeviceInvariantAttributes:(DeviceInvariant *) deviceInvariantAttributes;
-(void) setSession:(SessionManager *)sessionAttributes;


@end

