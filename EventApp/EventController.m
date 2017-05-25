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
            PropertyEventSource *eventSource = [[PropertyEventSource alloc] init];
            if ([[PropertyEventSource getBundleIdentifier]  isEqual: IWANTTVDEF]) {
                [eventSource setDigitalProperty:I_WANT_TV];
            }if ([[PropertyEventSource getBundleIdentifier]  isEqual: TFCDEF]) {
                [eventSource setDigitalProperty:NO_INK];
            }else{
                [eventSource setDigitalProperty:INVALID];
            }
            NSLog(@"initProp %d:", (int)[eventSource getProperty]);
            hasInitialized = true;
        
            if ([Validator isSourcePropertyValid:[eventSource getProperty]]) {
                
            }
            
            
        }
    });
    return shared;
}

-(void) initializeProperty{
    //To avoid conflict when accidentally called from the code
    
}


-(void) writeEvent:(EventAttributes *) attributes{
    [self superclass];
    NSLog(@"written: %@", attributes.clickedContent);
    

    [[AttributeManager init] setEventattributes:attributes];
    
    
    
//    if ([Validator isSourcePropertyValid: [eventsource getProperty]]) {
//        NSLog(@"SOURCE IS VALID");
//    }else{
//        NSLog(@"SOURCE IS INVALID");
//    }
//    
    
//    [Validator isSourcePropertyValid:];
    //PSEUDO CODE

    
    
    //sample condition
//    if (/* DISABLES CODE */ (1) == 1) {
//        //success
//        //call the delegate protocol
//        [delegate onSuccess];
//        
//    }else{
//        [delegate onFail];
//    }
    
}


-(void) setDelegate:(id) newDelagate{
    delegate = newDelagate;
}

@end
