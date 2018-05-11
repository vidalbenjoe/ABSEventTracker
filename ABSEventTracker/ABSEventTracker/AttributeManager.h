//
//  AttributeManager.h
//  EventApp

/**********************************************************************
 **                                                                  **
 **                                                                  **
 **                        ABSEventTracker                           **
 **           Created by Benjoe Vidal on 25/05/2017.                 **
 **                 hello@benjoeriveravidal.com                      **
 **        Copyright © 2017 ABS-CBN. All rights reserved.            **
 **                                                                  **
 **                                                                  **
 **********************************************************************
 */
#import <Foundation/Foundation.h>
#import "EventAttributes.h"
#import "UserAttributes.h"
#import "PropertyEventSource.h"
#import "DeviceInvariant.h"
#import "SessionManager.h"
#import "ArbitaryVariant.h"
#import "VideoAttributes.h"
#import "AudioAttributes.h"
// AttributeManager is the responsible for consolidating all of the attributes to be used in the event dispatcher - /Network/ABSBigDataServiceDispatcher
@interface AttributeManager : NSObject
+(AttributeManager*) init;

@property(nonatomic, strong) GenericEventController *genericattributes;
@property(nonatomic, strong) EventAttributes *eventattributes;
@property(nonatomic, strong) UserAttributes *userattributes;
@property(nonatomic, strong) PropertyEventSource *propertyinvariant;
@property(nonatomic, strong) DeviceInvariant *deviceinvariant;
@property(nonatomic, strong) SessionManager *session;
@property(nonatomic, strong) ArbitaryVariant *arbitaryinvariant;
@property(nonatomic, strong) VideoAttributes *videoattributes;
@property(nonatomic, strong) AudioAttributes *audioattributes;

-(void) setGenericAttributes:(GenericEventController*) genericAttributes;
-(void) setEventAttributes:(EventAttributes*) eventAttributes;
-(void) setUserAttributes:(UserAttributes *) userAttributes;
-(void) setPropertyAttributes:(PropertyEventSource *) propertyAttributes;
-(void) setDeviceInvariantAttributes:(DeviceInvariant *) deviceInvariantAttributes;
-(void) setSession:(SessionManager *) sessionAttributes;
-(void) setArbitaryAttributes:(ArbitaryVariant *) timestamp;
-(void) setVideoAttributes:(VideoAttributes *) videoAttribute;
-(void) setAudioAttributes:(AudioAttributes *) audioAttributes;

@end

