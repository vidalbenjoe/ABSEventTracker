//
//  Invariant.m
//  EventApp
//
//  Created by Benjoe Vidal on 25/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "Invariant.h"

@implementation Invariant

@synthesize deviceInvariant;
@synthesize propertyInvariant;

-(id) initInvariant:(DeviceInvariant*) deviceinvariant propertyInvariant:(PropertyInvariant*) property{
    deviceInvariant = deviceinvariant;
    propertyInvariant = property;
    return self;
}


@end
