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

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:propertyinvariant forKey:@"properyInvariant"];
    [encoder encodeObject:eventattributes forKey:@"eventAttributes"];
    [encoder encodeObject:userattributes forKey:@"userAttributes"];
    [encoder encodeObject:userattributes forKey:@"deviceInvariant"];
    [encoder encodeObject:arbitaryinvariant forKey:@"arbitaryInvariant"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [self init];
    self.propertyinvariant = [decoder decodeObjectForKey:@"properyInvariant"];
    self.eventattributes = [decoder decodeObjectForKey:@"eventAttributes"];
    self.userattributes = [decoder decodeObjectForKey:@"userAttributes"];
    self.userattributes = [decoder decodeObjectForKey:@"deviceInvariant"];
    self.arbitaryinvariant = [decoder decodeObjectForKey:@"arbitaryInvariant"];
    return self;
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
    //    NSLog(@"successProperrty")
}
-(void) setDeviceInvariantAttributes:(DeviceInvariant *) deviceInvariantAttributes{
    deviceinvariant = deviceInvariantAttributes;
}
-(void) setSession:(SessionManager *)sessionAttributes{
    session = sessionAttributes;
    NSLog(@"sessionSTarTest %@", [sessionAttributes sessionStart]);
}

-(void) setActionTimeStamp:(ArbitaryVariant *) timestamp{
    arbitaryinvariant = timestamp;
    NSLog(@"dawgdqhk %@", [timestamp applicationLaunchTimeStamp]);
}

@end
