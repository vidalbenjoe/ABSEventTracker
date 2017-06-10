//
//  AttributeManager.m
//  EventApp
//
//  Created by Benjoe Vidal on 25/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "AttributeManager.h"
#import "ABSEventAttributeQualifier.h"
#import "AttributeWriter.h"
#import "ABSBigDataServiceDispatcher.h"
@implementation AttributeManager
@synthesize userattributes;
@synthesize eventattributes;
@synthesize propertyinvariant;
@synthesize deviceinvariant;

+(AttributeManager*) init{
    static dispatch_once_t onceToken = 0;
    static id shared = nil;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

-(void) setEventAttributes:(EventAttributes*) eventAttributes{
    eventattributes = eventAttributes;
    [AttributeWriter writer:self];
}
-(void) setUserAttributes:(UserAttributes *) userAttributes{
    userattributes = userAttributes;
}
-(void) setPropertyAttributes:(PropertyEventSource *) propertyAttributes{
    propertyinvariant = propertyAttributes;
}
-(void) setDeviceInvariantAttributes:(DeviceInvariant *) deviceInvariantAttributes{
    deviceinvariant = deviceInvariantAttributes;
}
@end
