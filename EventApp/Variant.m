//
//  Variant.m
//  EventApp
//
//  Created by Benjoe Vidal on 25/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
// Hey guys! We just recently published our South Cebu - Bohol travel guide with itinerary for under 6500. For traveler and adventurer out there, this post will help you throughout your journey to the province of Cebu and Bohol.//

#import "Variant.h"

@implementation Variant
enum ActionTaken *actiontaken;
-(instancetype) initWithBuilder:(VariantBuilder *)builder{
    if (self = [super init]) {
        _persistentVariant          = builder.persistentVariant;
        _arbitaryVariant            = builder.arbitaryVariant;
    }
    return self;
}

-(VariantBuilder *) makeBuilder{
    VariantBuilder *builder = [VariantBuilder new];
    builder.persistentVariant       =   _persistentVariant;
    builder.arbitaryVariant         =   _arbitaryVariant;
    return builder;
}

+(instancetype) makeWithBuilder:(void (^)(VariantBuilder *))updateBlock{
    VariantBuilder *builder = [VariantBuilder new];
    updateBlock(builder);
    return [[Variant alloc] initWithBuilder: builder];
}

-(instancetype) update:(void (^)(VariantBuilder *))updateBlock{
    VariantBuilder *builder = [self makeBuilder];
    updateBlock(builder);
    return [[Variant alloc] initWithBuilder:builder];
}
-(instancetype) build{
    VariantBuilder *builder = [VariantBuilder new];
    return [self initWithBuilder:builder];
}

@end

@implementation VariantBuilder

-(instancetype) init{
    if (self = [super init]) {
        _persistentVariant          =   nil;
        _arbitaryVariant            =   nil;
    }
    return self;
}

@end

