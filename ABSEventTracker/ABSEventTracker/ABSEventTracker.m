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

+(ABSEventTracker *) init{
    static ABSEventTracker *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[super alloc] init];
        [self initializeProperty];
    });
    return shared;
}

@end



