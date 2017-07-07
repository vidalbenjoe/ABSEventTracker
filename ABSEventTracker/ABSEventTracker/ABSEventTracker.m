//
//  ABSEventTracker.m
//  EventApp
//
//  Created by Benjoe Vidal on 31/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//
#import "ABSEventTracker.h"
#import "ABSEventTracker+Initializer.h"

@implementation ABSEventTracker

+(ABSEventTracker *) initializeTracker{
    static ABSEventTracker *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[super alloc] init];
        // This line will initilize all of the required attributes and entropy to be able to gather event and device related properties.
        [self initializeProperty];
    });
    return shared;
}

@end



