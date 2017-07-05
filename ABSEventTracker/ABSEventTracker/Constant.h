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

#define SECHASH_ERROR_REQUEST      @"SECHASH_ERROR"
#define DEFAULT_SESSION_EXPIRATION_IN_MINUTES   1

@interface Constant : NSObject
extern NSString* const eventAppsBaseURL; // Base server URL ex: https:www.google.com
extern NSString* const eventTokenURL; // token sub url
extern NSString* const eventWriteURL;
extern NSString* const eventMobileResourceURL;
/*!
 * Method to generate Mobile header that can be used to request a security token based on the appBundleIdentifier
 */
+(NSString *) generateNewMobileHeader;
@end
