//
//  PropertyEventSource.h
//  EventApp
//
//  Created by Benjoe Vidal on 24/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#define I_WANT_TV_ID        @"com.abs.cbn.iwanttv"
#define TFC_ID              @"com.ph.abscbn.tfc"
#define SKY_ON_DEMAND_ID    @"com.abs.cbn.sky.on.demand"
#define NEWS_ID             @"com.abs.cbn.news"
#define EVENTAPP_ID         @"com.ph.abscbn.ios.EventApp"
#define INVALID_ID          @"com.invalid"

#import <Foundation/Foundation.h>
#import "Enumerations.h"

@interface PropertyEventSource : NSObject

@property(nonatomic, assign) DigitalProperty property;
@property(nonatomic, assign) NSString *applicationName;
@property(nonatomic, assign) NSString *bundleIdentifier;
extern NSString* const eventAppsBaseURL;
extern NSString* const eventWriteURL;

+(instancetype) init;

+(NSDictionary *) propertyDisplayName;
-(NSString *) propertyName;

+(NSString *) getAppName;
+(NSString *) getBundleIdentifier;
-(void) setDigitalProperty:(DigitalProperty) digitalProperty;
-(DigitalProperty) getProperty;
@end
