//
//  VideoAttributes.m
//  ABSEventTracker
//
//  Created by Benjoe Vidal on 13/07/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//
#import "VideoAttributes.h"

@implementation VideoAttributes

+(instancetype) sharedInstance{
    static VideoAttributes *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[super alloc] init];
    });
    return shared;
}
-(instancetype) initWithBuilder:(VideoBuilder *)builder{
    if (self = [super init]) {
        _videoCategoryID          = builder.videoCategoryID;
        _videoContentID           = builder.videoContentID;
        _videoTimeStamp           = builder.videoTimeStamp;
        _videoTitle               = builder.videoTitle;
        _videoURL                 = builder.videoURL;
        _videoType                = builder.videoType;
        _videoQuality             = builder.videoQuality;
        _videoVolume              = builder.videoVolume;
        
        _videoAdClick             = builder.videoAdClick;
        _videoAdComplete          = builder.videoAdComplete;
        _videoAdSkipped           = builder.videoAdSkipped;
        _videoAdError             = builder.videoAdError;
        _videoAdPlay              = builder.videoAdPlay;
        _videoMeta                = builder.videoMeta;
        
        _actionTaken              = builder.actionTaken;
        _videostate               = builder.videostate;
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
        
        _videoBufferCount         = builder.videoBufferCount;
        _videoTotalBufferTime     = builder.videoTotalBufferTime;
        _videoConsolidatedBufferTime = builder.videoConsolidatedBufferTime;
        
    }
    
    return self;
}

-(VideoBuilder *) makeBuilder{
    
    VideoBuilder *builder = [VideoBuilder new];
    builder.videoCategoryID         = _videoCategoryID;
    builder.videoContentID          = _videoContentID;
    builder.videoTimeStamp          = _videoTimeStamp;
    builder.videoTitle              = _videoTitle;
    builder.videoURL                = _videoURL;
    builder.videoType               = _videoType;
    builder.videoQuality            = _videoQuality;
    builder.videoVolume             = _videoVolume;
    
    builder.videoAdClick            = _videoAdClick;
    builder.videoAdComplete         = _videoAdComplete;
    builder.videoAdSkipped          = _videoAdSkipped;
    builder.videoAdError            = _videoAdError;
    builder.videoAdPlay             = _videoAdPlay;
    builder.videoMeta               = _videoMeta;
    
    builder.actionTaken             = _actionTaken;
    builder.videostate              = _videostate;
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
    
    builder.videoTotalBufferTime    = _videoTotalBufferTime;
    builder.videoBufferCount        = _videoBufferCount;
    builder.videoConsolidatedBufferTime = _videoConsolidatedBufferTime;
    
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
    return @{@(PAUSED)          : @"PAUSED",
             @(PLAYING)         : @"PLAYING",
             @(SEEKING)         : @"SEEKING",
             @(ON_IDLE)         : @"ON_IDLE",
             @(BUFFERING)       : @"BUFFERING",
             @(COMPLETED)       : @"COMPLETED",
             };
}

+(NSString *) convertVideoStateToString: (VideoState) state{
    return [[self class] videoStateByName][@(state)];
}
@end

@implementation VideoBuilder

-(instancetype) init{
    if (self = [super init]) {
        _videoCategoryID        = nil;
        _videoContentID         = nil;
        _videoTimeStamp         = nil;
        _videoTitle             = nil;
        _videoURL               = nil;
        _videoType              = nil;
        _videoQuality           = nil;
        
        _videoVolume            = 0;
        _videoAdClick           = nil;
        _videoAdComplete        = nil;
        _videoAdSkipped         = nil;
        _videoAdError           = nil;
        _videoAdPlay            = nil;
        _videoMeta              = nil;
        
        _videoConsolidatedBufferTime = nil;
        _videoBufferCount       = 0;
        _videoTotalBufferTime   = 0;
        
        _videoWidth             = 0;
        _videoHeight            = 0;
        _actionTaken            = 0;
        _videostate             = 0;
        _isVideoEnded           = NO;
        _isVideoPause           = NO;
        _isVideoFullScreen      = NO;
        
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
