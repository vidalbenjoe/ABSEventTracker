//
//  ABSEventTracker+Initializer.m
//  ABSEventTracker
//
//  Created by Benjoe Vidal on 30/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "ABSEventTracker+Initializer.h"
#import "FormatUtils.h"
#import "AuthManager.h"
#import "DeviceFingerprinting.h"
#import "ABSBigDataServiceDispatcher.h"
#import "ABSRecommendationEngine.h"
#import "PropertyEventSource.h"
#import "Constant.h"
#import "EventController.h"
#import "DeviceInfo.h"

@implementation ABSEventTracker (Initializer)
+(void) initializeProperty{
    // Initilize Session
    [[SessionManager init] establish];
    // Get device information to be used on device fingerprinting and analytics.
    DeviceInvariant *device = [DeviceInvariant makeWithBuilder:^
                               (DeviceInvariantBuilder *builder) {
        [builder setDeviceFingerprint:[DeviceFingerprinting generateDeviceFingerprint]];
        [builder setDeviceOS:[DeviceInfo systemVersion]];
        [builder setDeviceScreenWidth:[DeviceInfo screenWidth]];
        [builder setDeviceScreenHeight:[DeviceInfo screenHeight]];
        [builder setDeviceType:[DeviceInfo deviceType]];
    }];
    
    // Initilizing PropertyEventSource to be able to get proprty app name and its bundle Identifier
    PropertyEventSource *digitalProperty = [[PropertyEventSource alloc] init];
    [digitalProperty setApplicationName:[PropertyEventSource getAppName]];
    [digitalProperty setBundleIdentifier:[PropertyEventSource getBundleIdentifier]];
    // Background queue upon which you can dispatch background tasks that are run asynchronously to avoid blocking of UIs
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
                    [self initSession:[SessionManager init]];
                    [self initEventSource];
                    [self initWithDevice:device];
                    [self initAppProperty:digitalProperty];
        [ABSBigDataServiceDispatcher requestToken:^(NSString *token) {
            
            EventAttributes *attrib = [EventAttributes makeWithBuilder:^(EventBuilder *builder) {
                NSLog(@"initAttrib: %ld", (long)attrib.actionTaken);
                // set Event action into LOAD
                [builder setActionTaken:LOAD];
            }];
            // Write LOAD action to to server.
            [ABSEventTracker initEventAttributes:attrib];
        }];
                NSLog(@"initad");
                    // Request Token from initilization
        
    });
}
/**
 * Simple conditional statement to filter out ABS-CBN digital properties.
 * IMPORTANT: if the bundleIdentifier of the current app don't meet the pre-defined identifier, the server will not return any valid security hash.
 * Security hash is used to request a Token.
 */

#pragma mark - Event source
+(void) initEventSource{
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
}

/**
 * Set the SessionManager into attriutes manager.
 * Parameters: SessionManager -
 * sessionID
 * sessionStart
 * sessionEnd
 */

#pragma mark - Session
+(void) initSession :(SessionManager*) attributes{
    [[AttributeManager init] setSession:attributes];
}

/**
 * Set the property attributes into Attributes Manager.
 */
#pragma mark Property
+(void) initAppProperty:(PropertyEventSource *) attributes{
    [[AttributeManager init] setPropertyAttributes:attributes];
}

/**
 * This method will trigger after the user successfully logged in to their account.
 */
#pragma mark User
+(void) initWithUser:(UserAttributes *) attributes {
    [[AttributeManager init] setUserAttributes:attributes];
    EventAttributes *attrib = [EventAttributes makeWithBuilder:^(EventBuilder *builder) {
        [builder setActionTaken:LOGIN];
    }];
    // Send LOGIN action into server
    [ABSEventTracker initEventAttributes:attrib];
}

/**
 * Set the Device information into attriutes manager.
 */

#pragma mark - Device
+(void) initWithDevice:(DeviceInvariant *) attributes{
    [[AttributeManager init] setDeviceInvariantAttributes:attributes];
}
/**
 * Set the Arbitary attributes into attriutes manager.
 * Parameters: ArbitaryVariant - 
 * applicationAbandonTimeStamp
 * applicationLaunchTimeStamp
 * postCommentTimeStamp
 * loginTimeStamp
 * logoutTimeStamp,
 * searchTimeStamp
 */

#pragma mark - Arbitary
+(void) initArbitaryAttributes:(ArbitaryVariant *) attributes{
    [[AttributeManager init] setArbitaryAttributes:attributes];
}
/*!
 * @discussion Set the Event Attributes into attriutes manager.
 * @param 
 * attributes -
 * clickedContent
 * searchQuery
 * actionTaken
 * readArticles
 * articleAuthor
 * commentContent
 * loginTimeStamp
 * likedContent
 * shareRetweetContent
 * followEntity
 * metaTags
 * previosScreen
 * screenDestination
 * latitude
 * longitude
 * articleCharacterCount
 * rating
 * duration
 */

#pragma mark - Event Attributes
+(void) initEventAttributes: (EventAttributes *) attributes{
    [EventController writeEvent:attributes];
}

+(void) initVideoAttributes:(VideoAttributes *)attributes{
    [EventController writeVideoAttributes:attributes];
}

/*!
 * @discussion This method will fetch recommendation by popular
 */

#pragma mark - Popular
+(NSMutableArray*) readPopularRecommendation{
    return [ABSRecommendationEngine recommendationPopular];
}

#pragma mark - Item to item
+(NSMutableArray*) readItemToItemRecommendation{
    return [ABSRecommendationEngine recommendationItemToItem];
}

#pragma mark - User to item
+(NSMutableArray*) readUserToItemRecommendation{
    return [ABSRecommendationEngine recommendationUserToItem];
}

#pragma mark - Community to item
+(NSMutableArray*) readCommunityToItemRecommendation{
    return [ABSRecommendationEngine recommendationCommunityToItem];
}
@end
