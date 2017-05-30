//
//  EventController.h
//  EventApp
//
//  Created by Benjoe Vidal on 24/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventAttributes.h"
#import "EventCallBack.h"
#import "Validator.h"
#import "Enumerations.h"
#import "DeviceInvariant.h"
@protocol EventCallBacks <NSObject>

-(void) onSuccess;
-(void) onFail;

@end

@interface EventController : NSObject{
    id delegate;
}

//TODO : Create method that will process the event writing from the users given attributes
//TODO : Send the processed attributes to server

+(id) init;
+(void) writeDevice:(DeviceInvariant *) attributes;
+(void) writeEvent:(EventAttributes *) attributes;
-(void) setDelegate:(id) newDelagate;
-(void) initializeProperty;

@end
