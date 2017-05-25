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

+(NSDictionary *) propertyDisplayName{
    return @{@(SKY_ON_DEMAND) : @"Sky On Demand",
             @(I_WANT_TV)    : @"iWantTV",
             @(NO_INK)       : @"NoInk"};
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
