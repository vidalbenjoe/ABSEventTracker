//
//  AttributeManager.m
//  EventApp
//
//  Created by Benjoe Vidal on 25/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "AttributeManager.h"
#import "AttributeWriter.h"
#import "ABSBigDataServiceDispatcher.h"

@implementation AttributeManager
@synthesize genericattributes;
@synthesize userattributes;
@synthesize eventattributes;
@synthesize propertyinvariant;
@synthesize deviceinvariant;
@synthesize session;
@synthesize arbitaryinvariant;
@synthesize videoattributes;
@synthesize audioattributes;
@synthesize recommendationattributes;
/*
 * This class acts as a Facade/Manager for different sub-modules that constitutes the entire
 * BigData's iOS library event processing functionality.
 * It also manages the events data triggered by the digital property
 */
+(AttributeManager*) init{
    static dispatch_once_t onceToken = 0;
    static id shared = nil;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}
#pragma mark - Generic Action
-(void) setGenericAttributes:(GenericEventController*) genericAttributes{
    genericattributes = genericAttributes;
}

#pragma mark - Event Attributes
-(void) setEventAttributes:(EventAttributes*) eventAttributes{
    videoattributes = nil;
    eventattributes = eventAttributes;
    [AttributeWriter writer:self];
}
#pragma mark - User Attributes
-(void) setUserAttributes:(UserAttributes *) userAttributes{
    videoattributes = nil;
    userattributes = userAttributes;
    
}
#pragma mark - Property Attributes
-(void) setPropertyAttributes:(PropertyEventSource *) propertyAttributes{
    propertyinvariant = propertyAttributes;
}
#pragma mark - Device Attributes
-(void) setDeviceInvariantAttributes:(DeviceInvariant *) deviceInvariantAttributes{
    deviceinvariant = deviceInvariantAttributes;
}
#pragma mark - Session Manager
-(void) setSession:(SessionManager *)sessionAttributes{
    session = sessionAttributes;
}
#pragma mark Arbitary Attributes
-(void) setArbitaryAttributes:(ArbitaryVariant *) timestamp{
    arbitaryinvariant = timestamp;
}
#pragma mark - Video Attributes
-(void) setVideoAttributes:(VideoAttributes *)videoAttribute{
    videoattributes = videoAttribute;
    // Trigger AttributeWriter every time video event happened
    [AttributeWriter writer:self];
}
#pragma mark - Audio Attributes
-(void) setAudioAttributes:(AudioAttributes *) audioAttributes{
    audioattributes = audioAttributes;
    [AttributeWriter writer:self];
}
#pragma mark - Recommendation Attributes
-(void) setRecommendationAttributes:(RecommendationAttributes *) recommendationAttributes{
    recommendationattributes = recommendationAttributes;
    [AttributeWriter recommendationWriter:self];
}

- (void)dealloc {
  
}
@end
