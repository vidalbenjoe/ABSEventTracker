//
//  PropertyEventSource.m
//  ABSEventTracker
//
//  Created by Benjoe Vidal on 24/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "PropertyEventSource.h"
@implementation PropertyEventSource
@synthesize property;
@synthesize applicationName;
@synthesize bundleIdentifier;
@synthesize siteDomain;

+(instancetype)init{
    static PropertyEventSource *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[super alloc] init];
    });
    return shared;
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

+(NSDictionary *) properyTakenByName{
    return @{@(GIGYA)               : @"1",
             @(I_WANT_TV)           : @"2",
             @(TFC)                 : @"3",
             @(SKY_ON_DEMAND)       : @"4",
             @(ONE_MUSIC)           : @"5",
             @(NO_INK)              : @"6",
             @(SINEHUB)             : @"7",
             @(NEWS)                : @"8",
             @(INVALID)             : @"9",
             @(TEST)                : @"10"
             };
}

+(NSString *) convertPropertyTaken: (DigitalProperty) property{
    return [[self class] properyTakenByName][@(property)];
}



@end
