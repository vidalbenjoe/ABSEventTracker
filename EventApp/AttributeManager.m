//
//  AttributeManager.m
//  EventApp
//
//  Created by Benjoe Vidal on 25/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "AttributeManager.h"


@implementation AttributeManager
@synthesize userattributes;
@synthesize eventattributes;

-(void) att{
    [userattributes setFirstName:@""];
}

+(id) init{
    static AttributeManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[super alloc] init];
    
    });
    return shared;
}

-(void) setEventAttributes:(EventAttributes*) eventAttrib{
    eventattributes = eventAttrib;
}

@end
