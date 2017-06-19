//
//  ABSEventTracker.m
//  EventApp
//
//  Created by Benjoe Vidal on 31/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//
#import "ABSEventTracker.h"
#import "DeviceFingerprinting.h"
#import "DeviceInfo.h"
#import "EventController.h"
#import "EventAttributes.h"
#import "FormatUtils.h"
@implementation ABSEventTracker
@synthesize events;
+(ABSEventTracker *) init{
    static ABSEventTracker *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[super alloc] init];
        [self initEventSource];
        [[SessionManager init] establish];
        DeviceInvariant *device = [DeviceInvariant makeWithBuilder:^(DeviceInvariantBuilder *builder) {
            [builder setDeviceFingerprint:[DeviceFingerprinting generateDeviceFingerprint]];
            [builder setDeviceOS:[DeviceInfo systemVersion]];
            [builder setDeviceScreenWidth:[DeviceInfo screenWidth]];
            [builder setDeviceScreenHeight:[DeviceInfo screenHeight]];
            [builder setDeviceType:[DeviceInfo platformType]];
        }];
        
        UserAttributes *user = [UserAttributes makeWithBuilder:^(UserBuilder *builder) {
            [builder setFirstName:@"Benjoe"];
            [builder setLastName:@"Vidal"];
            [builder setMiddleName:@"Rivera"];
            [builder setSsoID:@"SSOID"];
            [builder setGigyaID:@"GIGYAID"];
        }];
        
        PropertyEventSource *digitalProperty = [[PropertyEventSource alloc] init];
        [digitalProperty setApplicationName:[PropertyEventSource getAppName]];
        [digitalProperty setBundleIdentifier:[PropertyEventSource getBundleIdentifier]];
        
        [self initWithDevice:device];
        [self initAppProperty:digitalProperty];
        [self initWithUser:user];
        [self initSession:[SessionManager init]];
        [self initArbitaryAttributes:[ArbitaryVariant init]];
        
        EventAttributes *attrib = [EventAttributes makeWithBuilder:^(EventBuilder *builder) {
            [builder setActionTaken:LOAD];
        }];
        
        [ABSEventTracker initEventAttributes:attrib];

        NSLog(@"properwName: %lu",(unsigned long)[[PropertyEventSource init] property]);
    });
    
    return shared;
}
+(void) initEventSource{
    if ([[PropertyEventSource getBundleIdentifier]  isEqual: I_WANT_TV_ID]) {
        [[PropertyEventSource init] setDigitalProperty:I_WANT_TV];
    }else if ([[PropertyEventSource getBundleIdentifier]  isEqual: TFC_ID]) {
        [[PropertyEventSource init] setDigitalProperty:NO_INK];
    }else if ([[PropertyEventSource getBundleIdentifier]  isEqual: SKY_ON_DEMAND_ID]) {
        [[PropertyEventSource init] setDigitalProperty:SKY_ON_DEMAND];
    }else if ([[PropertyEventSource getBundleIdentifier]  isEqual: NEWS_ID]) {
        [[PropertyEventSource init] setDigitalProperty:NEWS];
    }else if ([[PropertyEventSource getBundleIdentifier]  isEqual: EVENTAPP_ID]) {
        [[PropertyEventSource init] setDigitalProperty:TEST];
    }else{
        [[PropertyEventSource init] setDigitalProperty:INVALID];
    }
    NSLog(@"pwfw: %lu", (unsigned long)[[PropertyEventSource init] property]);
}

+(void) initAppProperty:(PropertyEventSource *) attributes{
    [[AttributeManager init] setPropertyAttributes:attributes];
}
+(void) initWithUser:(UserAttributes *) attributes {
    [[AttributeManager init] setUserAttributes:attributes];
}
+(void) initWithDevice:(DeviceInvariant *) attributes{
    [[AttributeManager init] setDeviceInvariantAttributes:attributes];
}
+(void) initEventAttributes: (EventAttributes *) attributes{
    [EventController writeEvent:attributes];
}

+(void) initArbitaryAttributes:(ArbitaryVariant *) attributes{
    [attributes setApplicationLaunchTimeStamp:[FormatUtils getCurrentTimeAndDate]];
    [[AttributeManager init] setActionTimeStamp:attributes];
}

+(void) initSession :(SessionManager*) attributes{
    [[AttributeManager init] setSession:attributes];
}




@end
