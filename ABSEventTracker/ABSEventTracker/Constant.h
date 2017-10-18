//
//  Constants.h
//  EventApp
//
//  Created by Benjoe Vidal on 01/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
#define I_WANT_TV_ID        @"com.abs-cbn.iwanttv"
#define TFC_ID              @"com.abscbni.tfctv"
#define SKY_ON_DEMAND_ID    @"abs.app.devicehardware.ABSEventTester"
#define NEWS_ID             @""
#define INVALID_ID          @"com.invalid"
#define TESTER_ID           @"com.abs.cbn.event.processing.library.test"

#define SECHASH_ERROR_REQUEST      @"SECHASH_ERRO_REQUEST"
#define DEFAULT_SESSION_EXPIRATION_IN_MINUTE(s)   30
#define DEFAULT_TOKEN_EXPIRATION_IN_MINUTE(s)   9
#define DEFAULT_SECHASH_EXPIRATION_IN_MINUTE(s)   45
@interface Constant : NSObject
extern NSString* const eventAppsBaseURL; // Base server URL ex: https:www.google.com
extern NSString* const tokenURL;
extern NSString* const eventTokenURL; // token sub url
extern NSString* const eventWriteURL;
extern NSString* const eventMobileResourceURL;

extern NSString* const recommendationPopular;
extern NSString* const UserToItemURL;
extern NSString* const ItemToItemURL;
extern NSString* const recommendationCommunityToItem;
extern NSString* const host;

// Staging host URL
extern NSString* const TFCHostStagingURL;
extern NSString* const NEWSHostStagingURL;
extern NSString* const IWANTVHostStagingURL;
extern NSString* const SODHostStagingURL;

// Production host URL
extern NSString* const TFCHostProdURL;
extern NSString* const NEWSHostProdURL;
extern NSString* const IWANTVHostProdURL;
extern NSString* const SODHostProdURL;


/*!
 * Method to generate Mobile header that can be used to request a security token based on the appBundleIdentifier
 */
+(NSString *) generateNewMobileHeader;
@end
