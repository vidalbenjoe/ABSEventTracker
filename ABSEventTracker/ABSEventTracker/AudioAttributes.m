//
//  AudioAttributes.m
//  ABSEventTracker
//
//  Created by vidalbenjoe on 07/03/2018.
//  Copyright © 2018 ABS-CBN. All rights reserved.
//

#import "AudioAttributes.h"
@implementation AudioAttributes
//@property(nonatomic) AudioPlayerState audioState;
-(instancetype) initWithBuilder:(AudioBuilder *)builder{
    if (self = [super init]) {
        _audioPlayerState = builder.audioPlayerState;
        _audioPlayPosition = builder.audioPlayPosition;
        _audioPausePosition = builder.audioPausePosition;
        _audioResumePosition = builder.audioResumePosition;
        _audioStopPosition = builder.audioStopPosition;
        _audioBufferPosition = builder.audioBufferPosition;
        _audioDuration = builder.audioDuration;
        _isAudioEnded = builder.isAudioEnded;
        _isAudioPaused = builder.isAudioPaused;
        _audioVolume = builder.audioVolume;
        _audioTitle = builder.audioTitle;
        _audioURL = builder.audioURL;
        _artist = builder.artist;
        _audioType = builder.audioType;
        _audioFormat = builder.audioFormat;
        _audioCodec = builder.audioCodec;
        _audioConsolidatedBufferTime = builder.audioConsolidatedBufferTime;
        _audioCategoryID = builder.audioCategoryID;
        _audioContentID = builder.audioContentID;
        _audioTimeStamp = builder.audioTimeStamp;
    }
        return self;
}
    
-(AudioBuilder *) makeBuilder{
    AudioBuilder *builder = [AudioBuilder new];
        builder.audioPlayerState = _audioPlayerState;
        builder.audioPlayPosition = _audioPlayPosition;
    builder.audioPausePosition = _audioPausePosition;
    builder.audioResumePosition = _audioResumePosition;
    builder.audioStopPosition = _audioStopPosition;
    builder.audioBufferPosition = _audioBufferPosition;
    builder.audioDuration = _audioDuration;
    builder.isAudioEnded = _isAudioEnded;
    builder.isAudioPaused = _isAudioPaused;
    builder.audioVolume = _audioVolume;
    builder.audioTitle = _audioTitle;
    builder.audioURL = _audioURL;
    builder.artist = _artist;
    builder.audioType = _audioType;
    builder.audioFormat = _audioFormat;
    builder.audioCodec = _audioCodec;
    builder.audioConsolidatedBufferTime = _audioConsolidatedBufferTime;
    builder.audioCategoryID = _audioCategoryID;
    builder.audioContentID = _audioContentID;
    builder.audioTimeStamp = _audioTimeStamp;
    
    
        return builder;
    }
    
+(instancetype) makeWithBuilder:(void (^)(AudioBuilder *)) updateBlock{
        AudioBuilder *builder = [AudioBuilder new];
        updateBlock(builder);
        return [[AudioAttributes alloc] initWithBuilder: builder];
}
    
-(instancetype) update:(void (^)(AudioBuilder *))updateBlock{
        AudioBuilder *builder = [self makeBuilder];
        updateBlock(builder);
        return [[AudioAttributes alloc] initWithBuilder:builder];
}
    
-(instancetype) build{
        AudioBuilder *builder = [AudioBuilder new];
        return [self initWithBuilder:builder];
}

+(NSDictionary *) audioStateByName{
    return @{@(PAUSED)          : @"PAUSED",
             @(PLAYING)         : @"PLAYING",
             @(SEEKING)         : @"SEEKING",
             @(ON_IDLE)         : @"ON_IDLE",
             @(BUFFERING)       : @"BUFFERING",
             @(COMPLETED)       : @"COMPLETED",
             };
}

+(NSString *) convertAudioStateToString: (AudioPlayerState) state{
    return [[self class] audioStateByName][@(state)];
}
    
@end
    
@implementation AudioBuilder
-(instancetype) init{
    if (self = [super init]) {
            _audioPlayerState = 0;
            _audioPlayPosition = 0;
            _audioPausePosition = 0;
            _audioResumePosition = 0;
            _audioStopPosition = 0;
            _audioBufferPosition = 0;
            _audioDuration = 0;
            _isAudioEnded = NO;
            _isAudioPaused = NO;
            _audioVolume = 0;
            _audioTitle = nil;
            _audioURL = nil;
            _artist = nil;
            _audioType = nil;
            _audioFormat = nil;
            _audioCodec = nil;
            _audioConsolidatedBufferTime = nil;
            _audioCategoryID = nil;
            _audioContentID = nil;
            _audioTimeStamp = nil;
    }
    return self;
}
@end
   
    
