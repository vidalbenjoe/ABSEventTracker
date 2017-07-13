//
//  AttributeManager.m
//  EventApp
//
//  Created by Benjoe Vidal on 25/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "AttributeManager.h"
#import "AttributeWriter.h"
#import "ABSBigDataServiceDispatcher.h"

@implementation AttributeManager
@synthesize userattributes;
@synthesize eventattributes;
@synthesize propertyinvariant;
@synthesize deviceinvariant;
@synthesize session;
@synthesize arbitaryinvariant;

+(AttributeManager*) init{
    static dispatch_once_t onceToken = 0;
    static id shared = nil;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

#pragma mark - Event Attributes
-(void) setEventAttributes:(EventAttributes*) eventAttributes{
    eventattributes = eventAttributes;
    [AttributeWriter writer:self];
}
#pragma mark - User Attributes
-(void) setUserAttributes:(UserAttributes *) userAttributes{
    userattributes = userAttributes;
}
#pragma mark - Property Attributes
-(void) setPropertyAttributes:(PropertyEventSource *) propertyAttributes{
    propertyinvariant = propertyAttributes;
    //    NSLog(@"successProperrty")
}
#pragma mark - Device Attributes
-(void) setDeviceInvariantAttributes:(DeviceInvariant *) deviceInvariantAttributes{
    deviceinvariant = deviceInvariantAttributes;
}
#pragma mark - Sessiin Manager
-(void) setSession:(SessionManager *)sessionAttributes{
    session = sessionAttributes;
    NSLog(@"sessionSTarTest %@", [sessionAttributes sessionStart]);
}
#pragma mark Arbitary Attributes
-(void) setArbitaryAttributes:(ArbitaryVariant *) timestamp{
    arbitaryinvariant = timestamp;
}




@end
