//
//  ABSEventTracker.m
//  EventApp
//
//  Created by Benjoe Vidal on 31/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//
#import "ABSEventTracker.h"
#import "FormatUtils.h"
#import "AuthManager.h"
#import "DeviceFingerprinting.h"
#import "ABSBigDataServiceDispatcher.h"
#import "ABSRecommendationEngine.h"
#import "PropertyEventSource.h"
#import "Constant.h"
#import "EventController.h"
#import "DeviceInfo.h"
#import "CacheManager.h"
#import "ABSLogger.h"

@implementation ABSEventTracker

+(ABSEventTracker *) initializeTrackerForProd :(BOOL) isProd{
    static ABSEventTracker *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[super alloc] init];
        // This line will initilize all of the required attributes and entropy to be able to gather event and device related properties.
        // Adding restriction based on bundle identifier of digital property. The library will not be initialized if the current bundle identifier is not registered in ABSEventTracker
        NSArray *identifier = [NSArray arrayWithObjects:I_WANT_TV_ID,TFC_ID,SKY_ON_DEMAND_ID,NEWS_ID, nil];
//        Checking the list of valid identifier if matched on the current BI
        BOOL isValid = [identifier containsObject: [PropertyEventSource getBundleIdentifier]];
        if (isValid) {
            [self initializeProperty:isProd];
        }else{
            [[ABSLogger initialize] setMessage:@"Initilization error: Bundle Identifier is not registered on the list of valid ABS-CBN's Digital Property"];
        }
    });
    
    return shared;
}

+(void) initializeProperty: (BOOL) isProd{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        // Initialize Session
        [[SessionManager init] establish];
        // Get device information to be used on device fingerprinting and analytics.
        DeviceInvariant *device = [DeviceInvariant makeWithBuilder:^
                                   (DeviceInvariantBuilder *builder) {
                                       [builder setDeviceFingerprint:[DeviceFingerprinting generateDeviceFingerprint]];
                                       [builder setDeviceOS:[NSString stringWithFormat:@"%@ %@", [DeviceInfo systemName],[DeviceInfo systemVersion]]];
                                       [builder setDeviceScreenWidth:[DeviceInfo screenWidth]];
                                       [builder setDeviceScreenHeight:[DeviceInfo screenHeight]];
                                       [builder setDeviceType:[DeviceInfo deviceType]];
                                   }];
        // Initilizing PropertyEventSource to be able to get proprty app name and its bundle Identifier
        PropertyEventSource *digitalProperty = [[PropertyEventSource alloc] init];
        [digitalProperty setApplicationName:[PropertyEventSource getAppName]];
        [digitalProperty setBundleIdentifier:[PropertyEventSource getBundleIdentifier]];
        if (isProd) {
            //use production site domain URL
            if ([[PropertyEventSource getBundleIdentifier]  isEqual: TFC_ID]) {
                  [digitalProperty setSiteDomain:TFCHostProdURL];
            } else if ([[PropertyEventSource getBundleIdentifier]  isEqual: NEWS_ID]){
                  [digitalProperty setSiteDomain:NEWSHostProdURL];
            } else if ([[PropertyEventSource getBundleIdentifier]  isEqual: I_WANT_TV_ID]){
                  [digitalProperty setSiteDomain:IWANTVHostProdURL];
            }else if ([[PropertyEventSource getBundleIdentifier]  isEqual: SKY_ON_DEMAND_ID]){
                  [digitalProperty setSiteDomain:SODHostProdURL];
            }
        }else{
            if ([[PropertyEventSource getBundleIdentifier]  isEqual: TFC_ID]) {
                  [digitalProperty setSiteDomain:TFCHostStagingURL];
            } else if ([[PropertyEventSource getBundleIdentifier]  isEqual: NEWS_ID]){
                  [digitalProperty setSiteDomain:NEWSHostStagingURL];
            } else if ([[PropertyEventSource getBundleIdentifier]  isEqual: I_WANT_TV_ID]){
                  [digitalProperty setSiteDomain:IWANTVHostStagingURL];
            }else if ([[PropertyEventSource getBundleIdentifier]  isEqual: SKY_ON_DEMAND_ID]){
                  [digitalProperty setSiteDomain:SODHostStagingURL];
            }
        }
        [self initSession:[SessionManager init]];
        [self checkEventSource];
        [self initWithDevice:device];
        [self initAppProperty:digitalProperty];
        [ABSBigDataServiceDispatcher requestToken:^(NSString *token) {
            EventAttributes *attrib = [EventAttributes makeWithBuilder:^(EventBuilder *builder) {
                // set Event action into LOAD
                [builder setActionTaken:LOAD];
            }];
            // Write LOAD action to to server.
            [ABSEventTracker initEventAttributes:attrib];
            [ABSBigDataServiceDispatcher dispatchCachedAttributes];
        }];
    });
}
/**
 * Simple conditional statement to filter out ABS-CBN digital properties.
 * IMPORTANT: if the bundle Identifier doesn't meet the pre-defined identifier, the server will not return any valid security hash.
 * Security hash is used to request a Token. - (ASP Connection only) Deprecated in NodeJS
 */

#pragma mark - Event source
+(void) checkEventSource{
    if ([[PropertyEventSource getBundleIdentifier]  isEqual: I_WANT_TV_ID]) {
        [[PropertyEventSource init] setDigitalProperty:I_WANT_TV];
    }else if ([[PropertyEventSource getBundleIdentifier]  isEqual: TFC_ID]) {
        [[PropertyEventSource init] setDigitalProperty:NO_INK];
    }else if ([[PropertyEventSource getBundleIdentifier]  isEqual: SKY_ON_DEMAND_ID]) {
        [[PropertyEventSource init] setDigitalProperty:SKY_ON_DEMAND];
    }else if ([[PropertyEventSource getBundleIdentifier]  isEqual: NEWS_ID]) {
        [[PropertyEventSource init] setDigitalProperty:NEWS];
    }else if ([[PropertyEventSource getBundleIdentifier]  isEqual: TESTER_ID]) {
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
    [UserAttributes cacheUserData:attributes];
    // Send LOGIN action into server
    [ABSEventTracker initEventAttributes:[EventAttributes makeWithBuilder:^(EventBuilder *builder) {
        [builder setActionTaken:LOGIN];
    }]];
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
    switch (attributes.action) {
        case VIDEO_PLAYED:
            
            break;
        case VIDEO_PAUSED:
            [VideoAttributes makeWithBuilder:^(VideoBuilder *builder) {
                [builder setIsVideoPause:YES];
            }];
            break;
        case VIDEO_RESUMED:
            
            break;
        case VIDEO_SEEK:
            
            break;
        case VIDEO_STOPPED:
            
            break;
        case VIDEO_BUFFER:
            
            break;
        case VIDEO_COMPLETE:
            [VideoAttributes makeWithBuilder:^(VideoBuilder *builder) {
                [builder setIsVideoEnded:YES];
            }];
            break;
    }
    [EventController writeVideoAttributes:attributes];
    
}
@end



