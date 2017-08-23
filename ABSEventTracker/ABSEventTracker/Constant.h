//
//  Constants.h
//  EventApp
//
//  Created by Benjoe Vidal on 01/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
#define I_WANT_TV_ID        @"com.abscbn.iwantv"
#define TFC_ID              @"com.ph.abscbn.tfc"
#define SKY_ON_DEMAND_ID    @"com.abs.cbn.sky.on.demand"
#define NEWS_ID             @"com.abs.cbn.news"
#define EVENTAPP_ID         @"com.ph.abscbn.ios.EventApp"
#define INVALID_ID          @"com.invalid"

#define SECHASH_ERROR_REQUEST      @"SECHASH_ERRO_REQUEST"
#define DEFAULT_SESSION_EXPIRATION_IN_MINUTE(s)   10
#define DEFAULT_TOKEN_EXPIRATION_IN_MINUTE(s)   9

//{"host":"www.skyondemand.com.ph"},
//{"host":"www.onemusic.ph"},
//{"host":"www.iwantv.com.ph"},
//{"host":"noink.abs-cbn.com"},


@interface Constant : NSObject
extern NSString* const eventAppsBaseURL; // Base server URL ex: https:www.google.com
extern NSString* const eventTokenURL; // token sub url
extern NSString* const eventWriteURL;
extern NSString* const eventMobileResourceURL;

extern NSString* const recoURL;

extern NSString* const recommendationPopular;
extern NSString* const recommendationUserToItem;
extern NSString* const recommendationItemToItem;
extern NSString* const recommendationCommunityToItem;
extern NSString* const host;

/*!
 * Method to generate Mobile header that can be used to request a security token based on the appBundleIdentifier
 */
+(NSString *) generateNewMobileHeader;
@end
