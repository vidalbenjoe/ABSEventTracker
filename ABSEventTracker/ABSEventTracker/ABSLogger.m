//
//  ABSLogger.m
//  ABSEventTracker
//
//  Created by Benjoe Vidal on 19/07/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "ABSLogger.h"
@implementation ABSLogger
@synthesize message;
@synthesize displayHTTPLogs;
+(instancetype) initialize{
    static ABSLogger *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[super alloc] init];
        
    });
    return shared;
}

-(NSString*) log{
    return message;
}

@end
