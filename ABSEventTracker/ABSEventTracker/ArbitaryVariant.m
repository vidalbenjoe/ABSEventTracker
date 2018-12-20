//
// ArbitaryVarian.h
/**********************************************************************
 **                                                                  **
 **                                                                  **
 **                        ABSEventTracker                           **
 **                   Created by Benjoe Vidal                        **
 **          Copyright © 2017 ABS-CBN. All rights reserved.          **
 **                                                                  **
 **                                                                  **
 **                                                                  **
 **********************************************************************
 */
#import "ArbitaryVariant.h"


@implementation ArbitaryVariant
+(ArbitaryVariant*) init{
    static ArbitaryVariant *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[super alloc] init];
    });
    return shared;
}

-(instancetype) initTimeStampWithBuilder:(ArbitaryBuilder *)builder{
    if (self = [super init]) {
        _applicationAbandonTimeStamp      =   builder.applicationAbandonTimeStamp;
        _applicationLaunchTimeStamp       =   builder.applicationLaunchTimeStamp;
        _postCommentTimeStamp             =   builder.postCommentTimeStamp;
        _loginTimeStamp                   =   builder.loginTimeStamp;
        _logoutTimeStamp                  =   builder.logoutTimeStamp;
        _searchTimeStamp                  =   builder.searchTimeStamp;
        _viewAccessTimeStamp              =   builder.viewAccessTimeStamp;
        _viewAbandonTimeStamp             =   builder.viewAbandonTimeStamp;
        _videoBufferTime                  =   builder.videoBufferTime;
        _audioBufferTime                  =   builder.audioBufferTime;
    }
    return self;
}

-(ArbitaryBuilder *) makeBuilder{
    ArbitaryBuilder *builder = [ArbitaryBuilder new];
    builder.applicationAbandonTimeStamp     =   _applicationAbandonTimeStamp;
    builder.applicationLaunchTimeStamp      =   _applicationLaunchTimeStamp;
    builder.postCommentTimeStamp            =   _postCommentTimeStamp;
    builder.loginTimeStamp                  =   _loginTimeStamp;
    builder.logoutTimeStamp                 =   _logoutTimeStamp;
    builder.searchTimeStamp                 =   _searchTimeStamp;
    builder.viewAccessTimeStamp             =   _viewAccessTimeStamp;
    builder.viewAbandonTimeStamp            =   _viewAbandonTimeStamp;
    builder.videoBufferTime                 =   _videoBufferTime;
    builder.audioBufferTime                 =   _audioBufferTime;
    
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
        _applicationAbandonTimeStamp            =   nil;
        _applicationLaunchTimeStamp             =   nil;
        _postCommentTimeStamp                   =   nil;
        _loginTimeStamp                         =   nil;
        _logoutTimeStamp                        =   nil;
        _searchTimeStamp                        =   nil;
        _viewAccessTimeStamp                    =   nil;
        _viewAbandonTimeStamp                   =   nil;
        _videoBufferTime                        =   nil;
        _audioBufferTime                        =   nil;
    }
    return self;
}

@end
