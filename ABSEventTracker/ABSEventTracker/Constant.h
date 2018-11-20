//
//  Constants.h
/**********************************************************************
 **                                                                  **
 **                                                                  **
 **                        ABSEventTracker                           **
 **            Created by Benjoe Vidal on 01/06/2017.                **
 **          Copyright © 2017 ABS-CBN. All rights reserved.          **
 **                                                                  **
 **                                                                  **
 **                                                                  **
 **********************************************************************/

#import <Foundation/Foundation.h>
#define I_WANT_TV_ID            @"com.abs-cbn.iwanttv"
#define TFC_ID                  @"com.abscbni.tfctv"
#define SKY_ON_DEMAND_ID        @"com.mysky.ondemand"
#define NEWS_ID                 @""
#define ONE_OTT                 @"com.abscbn.iwantNow"
#define TESTER_ID               @"com.abs.cbn.event.processing.library.test"

#define SECHASH_ERROR_REQUEST   @"Encountered an error while requesting for Security hash "

#define DEFAULT_SESSION_EXPIRATION_IN_MINUTE(s)   30
#define DEFAULT_TOKEN_EXPIRATION_IN_MINUTE(s)      9
#define DEFAULT_SECHASH_EXPIRATION_IN_MINUTE(s)   45

@interface Constant : NSObject
extern NSString *const urlStaging;
extern NSString *const urlProd;
extern NSString *const urlPreProd;

extern NSString* const eventTokenURL; // token sub url
extern NSString* const eventSendStagingPath;
extern NSString* const eventSendProdPath;
extern NSString* const eventMobileResourceURL;

extern NSString* const recoMobileResourceURL;
extern NSString* const devRecoURL;
extern NSString* const recoTokenURL;
extern NSString* const recommendationPopular;
extern NSString* const UserToItemURL;
extern NSString* const ItemToItemURL;
extern NSString* const recommendationCommunityToItem;
extern NSString* const recommendationGetItemToItem;

// Staging host URL
extern NSString* const TFCHostStagingURL;
extern NSString* const NEWSHostStagingURL;
extern NSString* const IWANTVHostStagingURL;
extern NSString* const SODHostStagingURL;
extern NSString* const ONEOTTHostStagingURL;

// Production host URL
extern NSString* const TFCHostProdURL;
extern NSString* const NEWSHostProdURL;
extern NSString* const IWANTVHostProdURL;
extern NSString* const SODHostProdURL;
extern NSString* const ONEOTTHostProdURL;

// Origin URL Production
extern NSString* const TFCOriginURL;
extern NSString* const NEWSOriginURL;
extern NSString* const IWANTVOriginURL;
extern NSString* const SODOriginURL;
extern NSString* const ONEOTTOriginURL;

/*!
 * Method to generate Mobile header that can be used to request a security token based on the appBundleIdentifier
 */
+(NSString *) generateNewMobileHeader;
@end
