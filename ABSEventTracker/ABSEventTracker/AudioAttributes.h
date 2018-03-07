//
//  AudioAttributes.h
//  ABSEventTracker
//
//  Created by vidalbenjoe on 07/03/2018.
//  Copyright © 2018 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, AudioPlayerState){
    PAUSED     =   0,
    PLAYING    =   1,
    SEEKING    =   2,
    ON_IDLE    =   3,
    BUFFERING  =   4,
    COMPLETED  =   5
};

@class AudioBuilder;
@interface AudioAttributes : NSObject
@property(nonatomic) AudioPlayerState audioPlayerState;
@property(nonatomic, readonly) double audioPlayPosition;
@property(nonatomic, readonly) double audioPausePosition;
@property(nonatomic, readonly) double audioResumePosition;
@property(nonatomic, readonly) double audioStopPosition;
@property(nonatomic, readonly) double audioBufferPosition;
@property(nonatomic, readonly) double audioDuration;

@property(nonatomic) BOOL isAudioEnded;
@property(nonatomic) BOOL isAudioPaused;
@property(nonatomic, readonly) double audioVolume;

@property(nonatomic, copy, readonly) NSString *audioTitle;
@property(nonatomic, copy, readonly) NSString *audioURL;
@property(nonatomic, copy, readonly) NSString *artist;
@property(nonatomic, copy, readonly) NSString *audioType;
@property(nonatomic, copy, readonly) NSString *audioFormat;
@property(nonatomic, copy, readonly) NSString *audioCodec;
@property(nonatomic, copy, readonly) NSString *audioConsolidatedBufferTime;
@property(nonatomic, copy, readonly) NSString *audioCategoryID;
@property(nonatomic, copy, readonly) NSString *audioContentID;
@property(nonatomic, copy, readonly) NSString *audioTimeStamp;

+(instancetype) makeWithBuilder:(void (^) (AudioBuilder *)) updateBlock;
-(instancetype) initWithBuilder:(AudioBuilder *) builder;
-(instancetype) update:(void(^)(AudioBuilder *)) updateBlock;
+(instancetype) sharedInstance;
-(instancetype) build;
+(NSString *) convertAudioStateToString: (AudioPlayerState) state;


@end

@interface AudioBuilder : NSObject

@property(assign, nonatomic) AudioPlayerState audioPlayerState;
@property(nonatomic) double audioPlayPosition;
@property(nonatomic) double audioPausePosition;
@property(nonatomic) double audioResumePosition;
@property(nonatomic) double audioStopPosition;
@property(nonatomic) double audioBufferPosition;
@property(nonatomic) double audioDuration;

@property(nonatomic) BOOL isAudioEnded;
@property(nonatomic) BOOL isAudioPaused;
@property(nonatomic) double audioVolume;

@property(nonatomic, copy) NSString *audioTitle;
@property(nonatomic, copy) NSString *audioURL;
@property(nonatomic, copy) NSString *artist;
@property(nonatomic, copy) NSString *audioType;
@property(nonatomic, copy) NSString *audioFormat;
@property(nonatomic, copy) NSString *audioCodec;
@property(nonatomic, copy) NSString *audioConsolidatedBufferTime;
@property(nonatomic, copy) NSString *audioCategoryID;
@property(nonatomic, copy) NSString *audioContentID;
@property(nonatomic, copy) NSString *audioTimeStamp;
@end
