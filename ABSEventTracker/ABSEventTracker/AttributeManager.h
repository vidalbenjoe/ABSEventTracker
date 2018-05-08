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
@property(nonatomic, weak) GenericEventController *genericattributes;
@property(nonatomic, weak) EventAttributes *eventattributes;
@property(nonatomic, weak) UserAttributes *userattributes;
@property(nonatomic, weak) PropertyEventSource *propertyinvariant;
@property(nonatomic, weak) DeviceInvariant *deviceinvariant;
@property(nonatomic, weak) SessionManager *session;
@property(nonatomic, weak) ArbitaryVariant *arbitaryinvariant;
@property(nonatomic, weak) VideoAttributes *videoattributes;
@property(nonatomic, weak) AudioAttributes *audioattributes;

-(void) setGenericAttributes:(GenericEventController*) genericAttributes;
-(void) setEventAttributes:(EventAttributes*) eventAttributes;
-(void) setUserAttributes:(UserAttributes *) userAttributes;
-(void) setPropertyAttributes:(PropertyEventSource *) propertyAttributes;
-(void) setDeviceInvariantAttributes:(DeviceInvariant *) deviceInvariantAttributes;
-(void) setSession:(SessionManager *)sessionAttributes;
-(void) setArbitaryAttributes:(ArbitaryVariant *) timestamp;
-(void) setVideoAttributes:(VideoAttributes *) videoAttribute;
-(void) setAudioAttributes:(AudioAttributes *) audioAttributes;
@end

