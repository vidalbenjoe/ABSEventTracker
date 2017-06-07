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
@synthesize applicationName;
@synthesize bundleIdentifier;

+(instancetype)init{
    static PropertyEventSource *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[super alloc] init];
    });
    return shared;
}

+(NSDictionary *) propertyDisplayName{
    return @{@(I_WANT_TV)           :       @"iWantTV",
             @(SKY_ON_DEMAND)       :       @"Sky On Demand",
             @(NO_INK)              :       @"NoInk"
             };
}

-(NSString *) propertyName{
    return [[self class] propertyDisplayName][@(self.property)];
}

+(NSString *) getAppName{
     NSString *appname = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey];
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
