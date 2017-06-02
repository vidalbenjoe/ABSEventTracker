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

#define GET                 @"GET"
#define POST_METHOD         @"POST"
#define PUT_METHOD          @"PUT"
#define DELETE_METHODs

@interface Constants : NSObject
extern NSString* const eventAppsBaseURL;
extern NSString* const eventWriteURL;



@end
