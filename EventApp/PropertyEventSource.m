//
//  PropertyEventSource.m
//  EventApp
//
//  Created by Benjoe Vidal on 24/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "PropertyEventSource.h"

@implementation PropertyEventSource
@synthesize property;

NSString* const eventAppsBaseURL        = @"http://indraeventsapi.azurewebsites.net";
NSString* const eventTokenURL           = @"/token";
NSString* const eventWriteURL           = @"/api/event/write";
NSString* const eventMobileResourceURL  = @"/api/event/mobiledatasource";


+(instancetype)init{
    static PropertyEventSource *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[super alloc] init];
    });
    return shared;
}

+(NSDictionary *) propertyDisplayName{
    return @{@(SKY_ON_DEMAND)   :   @"Sky On Demand",
             @(I_WANT_TV)       :   @"iWantTV",
             @(NO_INK)          :   @"NoInk"
             };
}

-(NSString *) propertyName{
    return [[self class] propertyDisplayName][@(self.property)];
}

+(NSString *) getAppName{
    NSString *appname = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    return appname;
}

+(NSString *) getBundleIdentifier{
    NSString * bundleidentifier = [[NSBundle mainBundle] bundleIdentifier];
    return bundleidentifier;
}

-(void) setDigitalProperty:(DigitalProperty) digitalProperty{
    property = digitalProperty;
}

-(DigitalProperty) getProperty{
    return property;
}


@end
