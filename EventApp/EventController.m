//
//  EventController.m
//  EventApp
//
//  Created by Benjoe Vidal on 24/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "EventController.h"
#import "AttributeManager.h"

#import "DeviceFingerprinting.h"
#import "DeviceInfo.h"
@implementation EventController
BOOL hasInitialized = false;

+(id) init{
    static EventController *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[super alloc] init];
    });
    return shared;
}

+(void) writeEvent:(EventAttributes *) attributes{
    [[AttributeManager init] setEventAttributes:attributes];
}






-(void) testBlock:(NSString *) name
         password: (NSString *) password
       completion: (void (^)(BOOL *success)) completionBlock{
}

-(void) setDelegate:(id) newDelagate{
    delegate = newDelagate;
}

@end
