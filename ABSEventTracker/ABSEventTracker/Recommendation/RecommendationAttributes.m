//
//  RecommendationAttributes.m
//  ABSEventTracker
//
//  Created by Indra on 19/10/2018.
//  Copyright © 2018 ABS-CBN. All rights reserved.
//

#import "RecommendationAttributes.h"

@implementation RecommendationAttributes

+(instancetype) sharedInstance{
    static RecommendationAttributes *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[super alloc] init];
    });
    return shared;
}

-(instancetype) initWithBuilder:(RecommendationBuilder *)builder{
    if (self = [super init]) {
        _actionTaken                    = builder.actionTaken;
        _recoCategoryId                 = builder.recoCategoryId;
        _recoItemCount                  = builder.recoItemCount;
        _recoPropertyId                 = builder.recoPropertyId;
        _recoType                       = builder.recoType;
    }
    return self;
}

-(RecommendationBuilder *) makeBuilder{
    RecommendationBuilder *builder = [RecommendationBuilder new];
    builder.actionTaken                 = _actionTaken;
    builder.recoCategoryId              = _recoCategoryId;
    builder.recoItemCount               = _recoItemCount;
    builder.recoPropertyId              = _recoPropertyId;
    builder.recoType                    = _recoType;
  
    return builder;
}

+(instancetype) makeWithBuilder:(void (^)(RecommendationBuilder *))updateBlock{
    RecommendationBuilder *builder = [RecommendationBuilder new];
    updateBlock(builder);
    return [[RecommendationAttributes alloc] initWithBuilder: builder];
}

-(instancetype) update:(void (^)(RecommendationBuilder *))updateBlock{
    RecommendationBuilder *builder = [self makeBuilder];
    updateBlock(builder);
    return [[RecommendationAttributes alloc] initWithBuilder:builder];
}
-(instancetype) build{
    RecommendationBuilder *builder = [RecommendationBuilder new];
    return [self initWithBuilder:builder];
}

@end

@implementation RecommendationBuilder

-(instancetype) init{
    if (self = [super init]) {
        _actionTaken            = 0;
        _recoCategoryId         = nil;
        _recoItemCount          = 0;
        _recoPropertyId         = nil;
        _recoType               = nil;
    }
    return self;
}


@end
