//
//  ABSEventTracker+Initializer.m
//  ABSEventTracker
//
//  Created by Flydubai on 30/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "ABSEventTracker+Initializer.h"
#import "FormatUtils.h"
#import "AuthManager.h"
#import "DeviceFingerprinting.h"
#import "ABSBigDataServiceDispatcher.h"
#import "PropertyEventSource.h"
#import "Constant.h"
#import "EventController.h"
#import "DeviceInfo.h"
@implementation ABSEventTracker (Initializer)

+(void) initializeProperty{
    [self initEventSource];
            [[SessionManager init] establish];
    DeviceInvariant *device = [DeviceInvariant makeWithBuilder:^(DeviceInvariantBuilder *builder) {
        [builder setDeviceFingerprint:[DeviceFingerprinting generateDeviceFingerprint]];
                    [builder setDeviceOS:[DeviceInfo systemVersion]];
                    [builder setDeviceScreenWidth:[DeviceInfo screenWidth]];
                    [builder setDeviceScreenHeight:[DeviceInfo screenHeight]];
                    [builder setDeviceType:[DeviceInfo deviceType]];
    }];
    
    PropertyEventSource *digitalProperty = [[PropertyEventSource alloc] init];
    [digitalProperty setApplicationName:[PropertyEventSource getAppName]];
    [digitalProperty setBundleIdentifier:[PropertyEventSource getBundleIdentifier]];

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        NSLog(@"Queue: %@", queue);
        [self initWithDevice:device];
                    [self initAppProperty:digitalProperty];
                    [self initSession:[SessionManager init]];
        
                    [ABSBigDataServiceDispatcher requestToken:^(NSString *token) {
                        [AuthManager storeTokenToUserDefault:token];
                        NSLog(@"initialToken: %@", token);
        
                                        EventAttributes *attrib = [EventAttributes makeWithBuilder:^(EventBuilder *builder) {
                                            [builder setActionTaken:LOAD];
                                        }];
                                        [ABSEventTracker initEventAttributes:attrib];
        
                    }];
        
    });
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
    EventAttributes *attrib = [EventAttributes makeWithBuilder:^(EventBuilder *builder) {
        [builder setActionTaken:LOGIN];
    }];
    [ABSEventTracker initEventAttributes:attrib];
}

+(void) initWithDevice:(DeviceInvariant *) attributes{
    [[AttributeManager init] setDeviceInvariantAttributes:attributes];
}
+(void) initArbitaryAttributes:(ArbitaryVariant *) attributes{
    [[AttributeManager init] setActionTimeStamp:attributes];
}
+(void) initSession :(SessionManager*) attributes{
    [[AttributeManager init] setSession:attributes];
}

+(void) initEventAttributes: (EventAttributes *) attributes{
    [EventController writeEvent:attributes];
}

@end
