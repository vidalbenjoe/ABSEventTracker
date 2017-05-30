//
//  EventController.m
//  EventApp
//
//  Created by Benjoe Vidal on 24/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "EventController.h"
#import "AttributeManager.h"
@implementation EventController
BOOL hasInitialized = false;


+(id) init{
    static EventController *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[super alloc] init];
        if (!hasInitialized) {
            if ([[PropertyEventSource getBundleIdentifier]  isEqual: I_WANT_TV_ID]) {
                [[self propertySource] setDigitalProperty:I_WANT_TV];
            }else if ([[PropertyEventSource getBundleIdentifier]  isEqual: TFC_ID]) {
                [[self propertySource] setDigitalProperty:NO_INK];
            }else if ([[PropertyEventSource getBundleIdentifier]  isEqual: SKY_ON_DEMAND_ID]) {
                [[self propertySource] setDigitalProperty:SKY_ON_DEMAND];
            }else if ([[PropertyEventSource getBundleIdentifier]  isEqual: NEWS_ID]) {
                [[self propertySource] setDigitalProperty:NEWS];
            }else{
                [[self propertySource] setDigitalProperty:INVALID];
            }
            hasInitialized = true;
        }
        
    });
    return shared;
}

+(PropertyEventSource *) propertySource{
    PropertyEventSource *propertyeventSource = [[PropertyEventSource alloc] init];
    return propertyeventSource;
}


+(void) writeDevice:(DeviceInvariant *) attributes{
    [[AttributeManager init] setDeviceInvariantAttributes:attributes];
}

+(void) writeEvent:(EventAttributes *) attributes{
    [self superclass];
    [[AttributeManager init] setEventAttributes:attributes];
    
    
    
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
-(void) initializeProperty{
    
}

-(void) testBlock:(NSString *) name
         password: (NSString *) password
       completion: (void (^)(BOOL *success)) completionBlock{
   
}

-(void) setDelegate:(id) newDelagate{
    delegate = newDelagate;
}

@end
