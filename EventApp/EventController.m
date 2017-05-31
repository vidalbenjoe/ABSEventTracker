//
//  EventController.m
//  EventApp
//
//  Created by Benjoe Vidal on 24/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "EventController.h"
#import "AttributeManager.h"
#import "DeviceInvariant.h"
#import "DeviceFingerprinting.h"
#import "DeviceInfo.h"
@implementation EventController
BOOL hasInitialized = false;

+(id) init{
    static EventController *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[super alloc] init];
            
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
            
            DeviceInvariant *device = [DeviceInvariant makeWithBuilder:^(DeviceInvariantBuilder *builder) {
                [builder setDeviceFingerprint:[DeviceFingerprinting generateDeviceFingerprint]];
                [builder setDeviceOS:[DeviceInfo systemVersion]];
                [builder setDeviceScreenWidth:[DeviceInfo screenWidth]];
                [builder setDeviceScreenHeight:[DeviceInfo screenHeight]];
                [builder setDeviceType:[DeviceInfo platformType]];
            }];
            
            [self initWithDevice:device];
            
            NSLog(@"properwName: %lu",(unsigned long)[[PropertyEventSource init] property]);
        
    });
    return shared;
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

+(void) writeEvent:(EventAttributes *) attributes{
    [[AttributeManager init] setEventAttributes:attributes];
   

    
    
    
    
    
//    if ([Validator isSourcePropertyValid:[[self propertySource] propertyName]]) {
//        
//    }
    
    //* VALIDATE EVENT PROPERTY
    //* INITIALIZE ATTRIBUTE MANAGER
    //* SET EVENT ATTRIBUTE IN ATTRIBUTEMANAGER;
    
    
    //* CREATE ANNOTHER CLASS TO INITIALIZE ALL ATTRIBUTES;
        // SOURCE PROPERTY
    
//    WriteAttributeRequest *writerAttributes = [[AttributeManager init] setDeviceOS:@""];
    
//    if ([Validator isSourcePropertyValid: [eventsource getProperty]]) {
//        NSLog(@"SOURCE IS VALID");
//    }else{
//        NSLog(@"SOURCE IS INVALID");
//    }
    

//    [Validator isSourcePropertyValid:];
    //PSEUDO CODE
    //sample condition
//    if (/* DISABLES CODE */ (1) == 1) {
//        //success
//        //call the delegate protocol
//        [delegate onSuccess];
//    }else{
//        [delegate onFail];
//    }
    
}

-(void) testBlock:(NSString *) name
         password: (NSString *) password
       completion: (void (^)(BOOL *success)) completionBlock{
   
}

-(void) setDelegate:(id) newDelagate{
    delegate = newDelagate;
}

@end
