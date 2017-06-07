//
//  EventController.m or the ABSEngineController // Act as a Facade(Reading and writing event attributes)
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
/**
 Functions to write event attributes to Attribute Manager.
 @param attributes EventAttributes
 */

+(void) writeEvent:(EventAttributes *) attributes{
    BOOL verifiedQualifiers = [self verifyEventAttribute:attributes error:nil];
    if (verifiedQualifiers) {
        [[AttributeManager init] setEventAttributes:attributes];
    }
}

-(void) setDelegate:(id) newDelagate{
    delegate = newDelagate;
}


+(BOOL) verifyEventAttribute: (EventAttributes*) eventAttributes error:(NSError *) error{
    NSError *errore = nil;
    NSMutableArray *violatedQualifiers = eventAttributes.getAttributeViolations;
    NSLog(@"volation: %@", violatedQualifiers);

    if (violatedQualifiers.count == 0) {
        
    }
    
    if (error) {
        NSString *errorMessage = [NSString stringWithFormat:@"Property %@ is required", eventAttributes];
        NSDictionary *userInfo = @{
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(errorMessage, nil)
                                   };
        errore = [NSError errorWithDomain:errorMessage
                                     code:-1
                                 userInfo:userInfo];
        NSLog(@"error %@", error.description);
        
    }
    return true;
}

@end
