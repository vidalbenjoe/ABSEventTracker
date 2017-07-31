//
//  VideoAttributes.h
//  ABSEventTracker
//
//  Created by Benjoe Vidal on 13/07/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventAttributes.h"
typedef NS_ENUM(NSInteger, VideoState){
    PLAYING    =   0,
    PAUSED     =   1,
    SEEKING    =   2,
    ON_IDLE    =   3,
    BUFFERING  =   4,
    COMPLETED  =   5
};
@class VideoBuilder;
@interface VideoAttributes : NSObject
@property(nonatomic) ActionTaken action;
@property(nonatomic) VideoState state;
@property(nonatomic) NSInteger *videoWidth;
@property(nonatomic) NSInteger *videoHeight;
@property(nonatomic) Boolean isVideoEnded;
@property(nonatomic) Boolean isVideoPaused;
@property(nonatomic) Boolean isVideoFullScreen;
@property(nonatomic, copy, readonly) NSString *videoTimeStamp;
@property(nonatomic, copy, readonly) NSString *videoTitle;
@property(nonatomic, copy, readonly) NSString *videoURL;
@property(nonatomic, copy, readonly) NSString *videoVolume;
@property(nonatomic) double videoDuration;
@property(nonatomic) double videoSeekStart;
@property(nonatomic) double videoSeekEnd;
@property(nonatomic) double videoAdTime;
@property(nonatomic) double videoPlayPosition;
@property(nonatomic) double videoPausePosition;
@property(nonatomic) double videoResumePosition;
@property(nonatomic) double videoStopPosition;
@property(nonatomic) double videoBufferPosition;

+(instancetype) makeWithBuilder:(void (^) (VideoBuilder *)) updateBlock;
-(instancetype) initWithBuilder:(VideoBuilder *) builder;
-(instancetype) update:(void(^)(VideoBuilder *)) updateBlock;
-(instancetype) build;
@end

@interface VideoBuilder : NSObject
@property(nonatomic, copy) NSString *videoTimeStamp;
@property(nonatomic, copy) NSString *videoTitle;
@property(nonatomic, copy) NSString *videoURL;
@property(nonatomic, copy) NSString *videoVolume;

@property(nonatomic) ActionTaken action;
@property(nonatomic) VideoState state;
@property(nonatomic) NSInteger *videoWidth;
@property(nonatomic) NSInteger *videoHeight;

@property(nonatomic) Boolean isVideoEnded;
@property(nonatomic) Boolean isVideoPause;
@property(nonatomic) Boolean isVideoFullScreen;

@property(nonatomic) double videoDuration;
@property(nonatomic) double videoSeekStart;
@property(nonatomic) double videoSeekEnd;
@property(nonatomic) double videoAdTime;
@property(nonatomic) double videoPlayPosition;
@property(nonatomic) double videoPausePosition;
@property(nonatomic) double videoResumePosition;
@property(nonatomic) double videoStopPosition;
@property(nonatomic) double videoBufferPosition;

@end


