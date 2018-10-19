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
        _userId                 = builder.userId;
        _categoryId             = builder.categoryId;
        _digitalPropertyId      = builder.digitalPropertyId;
    }
    return self;
}

-(RecommendationBuilder *) makeBuilder{
    RecommendationBuilder *builder = [RecommendationBuilder new];
    builder.userId                  = _userId;
    builder.categoryId              = _categoryId;
    builder.digitalPropertyId       = _digitalPropertyId;
  
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
        _userId                 = nil;
        _categoryId             = nil;
        _digitalPropertyId      = nil;
    }
    return self;
}

@end
