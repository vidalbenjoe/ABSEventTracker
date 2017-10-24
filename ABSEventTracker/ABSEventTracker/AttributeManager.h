//
//  AttributeManager.h
//  EventApp
/**********************************************************************
 **                                                                  **
 **                                                                  **
 **                        ABSEventTracker                           **
 **            Created by Benjoe Vidal on 25/05/2017.                **
 **          Copyright © 2017 ABS-CBN. All rights reserved.          **
 **                                                                  **
 **                                                                  **
 **                                                                  **
 **********************************************************************/

#import <Foundation/Foundation.h>
#import "EventAttributes.h"
#import "UserAttributes.h"
#import "PropertyEventSource.h"
#import "DeviceInvariant.h"
#import "SessionManager.h"
#import "ArbitaryVariant.h"
#import "VideoAttributes.h"

// AttributeManager is the responsible for consolidating all of the attributes to be used in the event dispatcher - @ABSBigDataServiceDispatcher.h
@interface AttributeManager : NSObject
+(AttributeManager*) init;
@property(nonatomic) EventAttributes *eventattributes;
@property(nonatomic) UserAttributes *userattributes;
@property(nonatomic) PropertyEventSource *propertyinvariant;
@property(nonatomic) DeviceInvariant *deviceinvariant;
@property(nonatomic) SessionManager *session;
@property(nonatomic) ArbitaryVariant *arbitaryinvariant;
@property(nonatomic) VideoAttributes *videoattributes;

-(void) setEventAttributes:(EventAttributes*) eventAttributes;
-(void) setUserAttributes:(UserAttributes *) userAttributes;
-(void) setPropertyAttributes:(PropertyEventSource *) propertyAttributes;
-(void) setDeviceInvariantAttributes:(DeviceInvariant *) deviceInvariantAttributes;
-(void) setSession:(SessionManager *)sessionAttributes;
-(void) setArbitaryAttributes:(ArbitaryVariant *) timestamp;
-(void) setVideoAttributes:(VideoAttributes *) videoAttribute;
@end

