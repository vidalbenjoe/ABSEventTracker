//
//  Constants.h
//  EventApp
//
//  Created by Benjoe Vidal on 01/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
#define I_WANT_TV_ID        @"com.abscbn.iwantv"
#define TFC_ID              @"com.abscbni.tfctv"
#define SKY_ON_DEMAND_ID    @"com.abs.cbn.sky.on.demand"
#define NEWS_ID             @"com.abs.cbn.news"
#define EVENTAPP_ID         @"com.ph.abscbn.ios.EventApp"
#define INVALID_ID          @"com.invalid"
#define TESTER_ID           @"com.abs.cbn.event.processing.library.test"

#define SECHASH_ERROR_REQUEST      @"SECHASH_ERRO_REQUEST"
#define DEFAULT_SESSION_EXPIRATION_IN_MINUTE(s)   10
#define DEFAULT_TOKEN_EXPIRATION_IN_MINUTE(s)   9

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

/*!
 * Method to generate Mobile header that can be used to request a security token based on the appBundleIdentifier
 */
+(NSString *) generateNewMobileHeader;
@end
