//
//  VideoAttributes.m
//  ABSEventTracker
//
//  Created by Benjoe Vidal on 13/07/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//
#import "VideoAttributes.h"

@implementation VideoAttributes
-(instancetype) initWithBuilder:(VideoBuilder *)builder{
    if (self = [super init]) {
        _videoTimeStamp           = builder.videoTimeStamp;
        _videoTitle               = builder.videoTitle;
        _videoURL                 = builder.videoURL;
        _videoVolume              = builder.videoVolume;
        
        _videoAdClick             = builder.videoAdClick;
        _videoAdComplete          = builder.videoAdComplete;
        _videoAdSkipped           = builder.videoAdSkipped;
        _videoAdError             = builder.videoAdError;
        _videoAdPlay              = builder.videoAdPlay;
        _videoMeta                = builder.videoMeta;
        _videoBuffer              = builder.videoBuffer;
        
        _action                   = builder.action;
        _state                    = builder.state;
        _videoWidth               = builder.videoWidth;
        _videoHeight              = builder.videoHeight;
        _isVideoEnded             = builder.isVideoEnded;
        _isVideoPaused            = builder.isVideoPause;
        _isVideoFullScreen        = builder.isVideoFullScreen;
        
        _videoDuration            = builder.videoDuration;
        _videoSeekStart           = builder.videoSeekStart;
        _videoSeekEnd             = builder.videoSeekEnd;
        _videoAdTime              = builder.videoAdTime;
        _videoPlayPosition        = builder.videoPlayPosition;
        _videoPausePosition       = builder.videoPausePosition;
        _videoResumePosition      = builder.videoResumePosition;
        _videoStopPosition        = builder.videoStopPosition;
        _videoBufferPosition      = builder.videoBufferPosition;
    }
    
    return self;
}

-(VideoBuilder *) makeBuilder{
    VideoBuilder *builder = [VideoBuilder new];
    builder.videoTimeStamp          = _videoTimeStamp;
    builder.videoTitle              = _videoTitle;
    builder.videoURL                = _videoURL;
    builder.videoVolume             = _videoVolume;
    
    builder.videoAdClick            = _videoAdClick;
    builder.videoAdComplete         = _videoAdComplete;
    builder.videoAdSkipped          = _videoAdSkipped;
    builder.videoAdError            = _videoAdError;
    builder.videoAdPlay             = _videoAdPlay;
    builder.videoMeta               = _videoMeta;
    builder.videoBuffer             = _videoBuffer;
    
    builder.action                  = _action;
    builder.state                   = _state;
    builder.videoWidth              = _videoWidth;
    builder.videoHeight             = _videoHeight;
    builder.isVideoEnded            = _isVideoEnded;
    builder.isVideoPause            = _isVideoPaused;
    builder.isVideoFullScreen       = _isVideoFullScreen;
    builder.videoDuration           = _videoDuration;
    builder.videoSeekStart          = _videoSeekStart;
    builder.videoSeekEnd            = _videoSeekEnd;
    builder.videoAdTime             = _videoAdTime;
    builder.videoPlayPosition       = _videoPlayPosition;
    builder.videoPausePosition      = _videoPausePosition;
    builder.videoResumePosition     = _videoResumePosition;
    builder.videoStopPosition       = _videoStopPosition;
    builder.videoBufferPosition     = _videoBufferPosition;
    return builder;
}

+(instancetype) makeWithBuilder:(void (^)(VideoBuilder *))updateBlock{
    VideoBuilder *builder = [VideoBuilder new];
    updateBlock(builder);
    return [[VideoAttributes alloc] initWithBuilder: builder];
}

-(instancetype) update:(void (^)(VideoBuilder *))updateBlock{
    VideoBuilder *builder = [self makeBuilder];
    updateBlock(builder);
    return [[VideoAttributes alloc] initWithBuilder:builder];
}
-(instancetype) build{
    VideoBuilder *builder = [VideoBuilder new];
    return [self initWithBuilder:builder];
}

+(NSDictionary *) videoStateByName{
    return @{@(PLAYING)       : @"Playing",
             @(PAUSED)      : @"Paused",
             @(SEEKING)     : @"Seeking",
             @(ON_IDLE)     : @"On Idle",
             @(BUFFERING)     : @"Buffering",
             @(COMPLETED)     : @"Completed",
             };
}

+(NSString *) convertVideoStateToString: (VideoState) state{
    return [[self class] videoStateByName][@(state)];
}

@end

@implementation VideoBuilder

-(instancetype) init{
    if (self = [super init]) {
        _videoTimeStamp         = nil;
        _videoTitle             = nil;
        _videoURL               = nil;
        
        _videoVolume            = 0;
        _videoAdClick           = nil;
        _videoAdComplete        = nil;
        _videoAdSkipped         = nil;
        _videoAdError           = nil;
        _videoAdPlay            = nil;
        _videoMeta              = nil;
        _videoBuffer            = nil;
        
        _videoWidth             = 0;
        _videoHeight            = 0;
        _action                 = 0;
        _state                  = 0;
        _isVideoEnded           = 0;
        _isVideoPause           = 0;
        _isVideoFullScreen      = 0;
        
        _videoDuration          = 0;
        _videoSeekStart         = 0;
        _videoSeekEnd           = 0;
        
        _videoAdTime            = 0;
        
        _videoPlayPosition      = 0;
        _videoPausePosition     = 0;
        
        _videoResumePosition    = 0;
        _videoStopPosition      = 0;
        _videoBufferPosition    = 0;
    }
    return self;
}

@end
