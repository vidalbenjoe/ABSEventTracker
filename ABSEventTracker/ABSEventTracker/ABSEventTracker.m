//
//  ABSEventTracker.m
//  EventApp
//
//  Created by Benjoe Vidal on 31/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//
#import "ABSEventTracker.h"
#import "FormatUtils.h"
#import "EventAuthManager.h"
#import "DeviceFingerprinting.h"
#import "ABSBigDataServiceDispatcher.h"
#import "PropertyEventSource.h"
#import "Constant.h"
#import "EventController.h"
#import "DeviceInfo.h"
#import "CacheManager.h"
#import "ABSLogger.h"

@implementation ABSEventTracker

+(instancetype) initializeTracker :(EnvironmentConfig) config isEnableHTTPLogs :(BOOL) HTTPLogs{
//    NSLog(@"EnvironmentConfig: %ld", (long) config);
    static ABSEventTracker *shared = nil;
    static dispatch_once_t pred;                 // Lock
        dispatch_once(&pred, ^{                 // This code is called at most once per app
            shared = [[self alloc] init];
            NSArray *identifier = [NSArray arrayWithObjects:I_WANT_TV_ID,TFC_ID,SKY_ON_DEMAND_ID,NEWS_ID, ONE_OTT, nil];
            //Checking the list of valid identifier if it's matched on the current app bundle identifier
            BOOL isValid = [identifier containsObject: [PropertyEventSource getBundleIdentifier]];
            if (isValid) {
                // Establishing Session
                [[SessionManager init] establish];
                [self initSession:[SessionManager init]];
                // Initilize all of the required attributes and entropy to be able to gather event and device related properties.
                // Getting the device information to be used on device fingerprinting and analytics.
                DeviceInvariant *device = [DeviceInvariant makeWithBuilder:^
                                           (DeviceInvariantBuilder *builder) {
                                               [builder setDeviceFingerprint:config == PRODUCTION ?[DeviceFingerprinting generateDeviceFingerprint] : [NSString stringWithFormat:@"%@", [DeviceFingerprinting generateDeviceFingerprint]]];
                                               [builder setDeviceOS:[NSString stringWithFormat:@"%@ %@", [DeviceInfo systemName],[DeviceInfo systemVersion]]];
                                               [builder setDeviceScreenWidth:[DeviceInfo screenWidth]];
                                               [builder setDeviceScreenHeight:[DeviceInfo screenHeight]];
                                               [builder setDeviceType:[DeviceInfo deviceType]];
                                               [builder setAppversionBuildRelease:[PropertyEventSource getAppVersion]];
                                               
                                           }];
                
                // Initilizing PropertyEventSource to be able to get proprty app name and its bundle Identifier
                PropertyEventSource *digitalProperty = [[PropertyEventSource alloc] init];
                [digitalProperty setApplicationName:[PropertyEventSource getAppName]];
                [digitalProperty setBundleIdentifier:[PropertyEventSource getBundleIdentifier]];
                [digitalProperty setUrl:config == PRODUCTION ? urlProd : urlStaging];
                [digitalProperty setPath:config == PRODUCTION ? eventSendProdPath : eventSendStagingPath];
                //Check digital property if for production or for staging
                
                if ([[PropertyEventSource getBundleIdentifier]  isEqual: TFC_ID]) {
                    [digitalProperty setSiteDomain:config == PRODUCTION ? TFCHostProdURL : TFCHostStagingURL];
                    [digitalProperty setOrigin:TFCOriginURL];
                } else if ([[PropertyEventSource getBundleIdentifier]  isEqual: NEWS_ID]){
                    [digitalProperty setSiteDomain:NEWSHostProdURL];
                    [digitalProperty setOrigin:NEWSOriginURL];
                } else if ([[PropertyEventSource getBundleIdentifier]  isEqual: I_WANT_TV_ID]){
                    [digitalProperty setSiteDomain:config == PRODUCTION ? IWANTVHostProdURL :  IWANTVHostStagingURL];
                    [digitalProperty setOrigin:IWANTVOriginURL];
                }else if ([[PropertyEventSource getBundleIdentifier]  isEqual: SKY_ON_DEMAND_ID]){
                    [digitalProperty setSiteDomain:config == PRODUCTION ? SODHostProdURL : SODHostStagingURL];
                    [digitalProperty setOrigin:SODOriginURL];
                }else if ([[PropertyEventSource getBundleIdentifier]  isEqual: ONE_OTT]){
                    [digitalProperty setSiteDomain:config == PRODUCTION ? ONEOTTHostProdURL : ONEOTTHostStagingURL];
                    [digitalProperty setOrigin:ONEOTTOriginURL];
                }
                //Storing fingerprintID to EventAuthManager
                [EventAuthManager storeFingerPrintID:[DeviceFingerprinting generateDeviceFingerprint]];
                
                [self checkEventSource];
                [self initWithDevice:device];
                [self initAppProperty:digitalProperty];
                
                [ABSBigDataServiceDispatcher requestToken:^(NSString *token) {
                    EventAttributes *launchEvent = [EventAttributes makeWithBuilder:^(EventBuilder *builder) {
                        // Set Event action into LOAD
                        [builder setActionTaken:LOAD];
                    }];
                    // Event writing
                    [ABSEventTracker initEventAttributes:launchEvent];
                    [ABSBigDataServiceDispatcher dispatchCachedAttributes];
                }];
                // Setting a boolean to enable/disable HTTP Logs
                [[ABSLogger initialize] setDisplayHTTPLogs:HTTPLogs];
            }else{
                [[ABSLogger initialize] setMessage:@"Initilization error: Bundle Identifier is not registered on the list of valid ABS-CBN's Digital Property"];
                NSLog(@"Initilization error: Bundle Identifier is not registered on the list of valid ABS-CBN's Digital Property");
            }
        });
    
    
   
    return shared;
}

/**
 * Simple conditional statement to filter out ABS-CBN digital properties.
 * IMPORTANT: if the bundle Identifier doesn't meet the pre-defined identifier, the server will not return any valid security hash.
 * Security hash is used to request a Token. - (ASP Connection only) Deprecated in NodeJS
 */
#pragma mark - Event source
+(void) checkEventSource{
    if ([[PropertyEventSource getBundleIdentifier]  isEqual: I_WANT_TV_ID]) {
        [[PropertyEventSource sharedInstance] setDigitalProperty:I_WANT_TV];
    }else if ([[PropertyEventSource getBundleIdentifier]  isEqual: TFC_ID]) {
        [[PropertyEventSource sharedInstance] setDigitalProperty:NO_INK];
    }else if ([[PropertyEventSource getBundleIdentifier]  isEqual: SKY_ON_DEMAND_ID]) {
        [[PropertyEventSource sharedInstance] setDigitalProperty:SKY_ON_DEMAND];
    }else if ([[PropertyEventSource getBundleIdentifier]  isEqual: NEWS_ID]) {
        [[PropertyEventSource sharedInstance] setDigitalProperty:NEWS];
    }else if ([[PropertyEventSource getBundleIdentifier]  isEqual: TESTER_ID]) {
        [[PropertyEventSource sharedInstance] setDigitalProperty:TEST];
    }else{
        [[PropertyEventSource sharedInstance] setDigitalProperty:INVALID];
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
 * This method wil l trigger after the user successfully logged in to their account.
 */
#pragma mark User
+(void) initWithUser:(UserAttributes *) attributes {
    // Send LOGIN action into server
    [UserAttributes cachedUserInfoWithID:attributes.ssoID ?: attributes.gigyaID];
    [ABSEventTracker initEventAttributes:[EventAttributes makeWithBuilder:^(EventBuilder *builder) {
        [builder setActionTaken:LOGIN];
    }]];
    [[AttributeManager init] setUserAttributes:attributes];
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

/*!
 * @discussion Set the Video Attributes into attriutes manager.
 * @param
 * attributes -
 * videoactionTaken
 * videoState
 * videoHeight
 * videoWidth
 * isVideoEnded
 * isVideoPaused
 * isVideoFullScreen
 * videoTimeStamp
 * videoTitle
 * videoURL
 * videoVolume
 * videoClick
 * videoAdComplete
 * videoAdSkipped
 * videoAdError
 * videoAdPlay
 * videoMeta
 * videoBuffer
 * videoDuration
 * videoSeekStart
 * videoSeekEnd
 * videoAdTime
 * videoPlayPosition
 * videoPausePosition
 * videoResumePosition
 * videoStopPosition
 * videoBufferPosition
 */

#pragma mark - Video Attributes
+(void) initVideoAttributes:(VideoAttributes *)attributes{
    [EventController writeVideoAttributes:attributes];
}
#pragma mark - Video Attributes
+(void) initAudioAttributes:(AudioAttributes *)attributes{
    [EventController writeAudioAttributes:attributes];
}
#pragma mark - Recommendation Attributes
+(void) initRecoAttributes:  (RecommendationAttributes *) attributes{
     [EventController writeRecommendationAttributes:attributes];
}
@end



