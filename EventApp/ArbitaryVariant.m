//
//  ArbitaryVariant.m
//  EventApp
//
//  Created by Flydubai on 25/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "ArbitaryVariant.h"

@implementation ArbitaryVariant
@synthesize applicationLaunchTimeStamp;
+(ArbitaryVariant*) init{
    static ArbitaryVariant *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[super alloc] init];
    });
    return shared;
}

-(NSString*) getLaunchTime{
    return applicationLaunchTimeStamp;
}

-(instancetype) initTimeStampWithBuilder:(ArbitaryBuilder *)builder{
    if (self = [super init]) {
        _applicationAbandonTimeStamp      =   builder.applicationAbandonTimeStamp;
        applicationLaunchTimeStamp       =   builder.applicationLaunchTimeStamp;
        _postCommentTimeStamp             =   builder.postCommentTimeStamp;
        _logoutTimeStamp                  =   builder.logoutTimeStamp;
        _searchTimeStamp                  =   builder.searchTimeStamp;
    }
    return self;
}

-(ArbitaryBuilder *) makeBuilder{
    ArbitaryBuilder *builder = [ArbitaryBuilder new];
    builder.applicationAbandonTimeStamp     =   _applicationAbandonTimeStamp;
    builder.applicationLaunchTimeStamp     =   applicationLaunchTimeStamp;
    builder.postCommentTimeStamp            =   _postCommentTimeStamp;
    builder.logoutTimeStamp                 =   _logoutTimeStamp;
    builder.searchTimeStamp                 =   _searchTimeStamp;
    
    return builder;
}

+(instancetype) makeWithBuilder:(void (^)(ArbitaryBuilder *))updateBlock{
    ArbitaryBuilder *builder = [ArbitaryBuilder new];
    updateBlock(builder);
    return [[ArbitaryVariant alloc] initTimeStampWithBuilder: builder];
}

-(instancetype) update:(void (^)(ArbitaryBuilder *))updateBlock{
    ArbitaryBuilder *builder = [self makeBuilder];
    updateBlock(builder);
    return [[ArbitaryVariant alloc] initTimeStampWithBuilder:builder];
}
-(instancetype) build{
    ArbitaryBuilder *builder = [ArbitaryBuilder new];
    return [self initTimeStampWithBuilder:builder];
}

@end


@implementation ArbitaryBuilder

-(instancetype) init{
    if (self = [super init]) {
        _applicationAbandonTimeStamp                      =   nil;
        _applicationLaunchTimeStamp                    =   nil;
        _postCommentTimeStamp                  =   nil;
        _logoutTimeStamp                 =   nil;
        _searchTimeStamp                   =   nil;
    }
    return self;
}

@end
