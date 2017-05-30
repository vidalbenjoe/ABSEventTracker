//
//  AttributeManager.m
//  EventApp
//
//  Created by Benjoe Vidal on 25/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "AttributeManager.h"

@implementation AttributeManager
@synthesize userattributes;
@synthesize eventattributes;
@synthesize propertyinvariant;
@synthesize deviceinvariant;

+(id) init{
    static AttributeManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[super alloc] init];
    });
    return shared;
}

-(void) setEventAttributes:(EventAttributes*) eventAttributes{
    eventattributes = eventAttributes;
    [self verifyEventAttribute:eventattributes];
    NSLog(@"AttributeManagerw: %@", eventAttributes.clickedContent);
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

-(void) verifyEventAttribute: (EventAttributes*) eventAttributes{
    NSMutableArray *violatedQualifiers = eventAttributes.getAttributeViolations;
    NSLog(@"volation: %@", violatedQualifiers);
    if (violatedQualifiers.count == 0) {
        
    }
}

@end
