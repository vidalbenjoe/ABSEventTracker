//
//  VideoAttributes.h
//  ABSEventTracker
/**********************************************************************
 **                                                                  **
 **                                                                  **
 **                        ABSEventTracker                           **
 **            Created by Benjoe Vidal on 13/07/2017.                **
 **          Copyright © 2017 ABS-CBN. All rights reserved.          **
 **                                                                  **
 **                                                                  **
 **                                                                  **
 **********************************************************************/

#import <Foundation/Foundation.h>
#import "EventAttributes.h"

// Video States
typedef NS_ENUM(NSInteger, VideoState){
    PAUSED     =   0,
    PLAYING    =   1,
    SEEKING    =   2,
    ON_IDLE    =   3,
    BUFFERING  =   4,
    COMPLETED  =   5
};
// Video Action Taken
typedef NS_ENUM(NSInteger, VideoActionTaken){
    VIDEO_PLAYED        =   0,
    VIDEO_PAUSED        =   1,
    VIDEO_RESUMED       =   2,
    VIDEO_SEEK          =   3,
    VIDEO_STOPPED       =   4,
    VIDEO_BUFFER        =   5,
    VIDEO_COMPLETE      =   6
};
@class VideoBuilder;
@interface VideoAttributes : NSObject
@property(nonatomic, readonly) VideoActionTaken action;
@property(nonatomic, readonly) VideoState videostate;
@property(nonatomic, readonly) int videoWidth;
@property(nonatomic, readonly) int videoHeight;
@property(nonatomic, readonly) BOOL isVideoEnded;
@property(nonatomic, readonly) BOOL isVideoPaused;
@property(nonatomic, readonly) BOOL isVideoFullScreen;
@property(nonatomic, copy, readonly) NSString *videoTimeStamp;
@property(nonatomic, copy, readonly) NSString *videoTitle;
@property(nonatomic, copy, readonly) NSString *videoURL;
@property(nonatomic, readonly) double videoVolume;

@property(nonatomic, copy, readonly) NSString *videoAdClick;
@property(nonatomic, copy, readonly) NSString *videoAdComplete;
@property(nonatomic, copy, readonly) NSString *videoAdSkipped;
@property(nonatomic, copy, readonly) NSString *videoAdError;
@property(nonatomic, copy, readonly) NSString *videoAdPlay;
@property(nonatomic, copy, readonly) NSString *videoMeta;
@property(nonatomic, copy, readonly) NSString *videoBufferTime;
@property(nonatomic, copy) NSString *videoConsolidatedBufferTime;


@property(nonatomic, readonly) double videoTotalBufferTime;
@property(nonatomic, readonly) double videoDuration;
@property(nonatomic, readonly) double videoSeekStart;
@property(nonatomic, readonly) double videoSeekEnd;
@property(nonatomic, readonly) double videoAdTime;
@property(nonatomic, readonly) double videoPlayPosition;
@property(nonatomic, readonly) double videoPausePosition;
@property(nonatomic, readonly) double videoResumePosition;
@property(nonatomic, readonly) double videoStopPosition;
@property(nonatomic, readonly) double videoBufferPosition;

+(instancetype) makeWithBuilder:(void (^) (VideoBuilder *)) updateBlock;
-(instancetype) initWithBuilder:(VideoBuilder *) builder;
-(instancetype) update:(void(^)(VideoBuilder *)) updateBlock;
-(instancetype) build;
+(NSString *) convertVideoStateToString: (VideoState) state;
@end

@interface VideoBuilder : NSObject
@property(nonatomic, copy) NSString *videoTimeStamp;
@property(nonatomic, copy) NSString *videoTitle;
@property(nonatomic, copy) NSString *videoURL;
@property(nonatomic) double videoVolume;

@property(nonatomic, copy) NSString *videoAdClick;
@property(nonatomic, copy) NSString *videoAdComplete;
@property(nonatomic, copy) NSString *videoAdSkipped;
@property(nonatomic, copy) NSString *videoAdError;
@property(nonatomic, copy) NSString *videoAdPlay;
@property(nonatomic, copy) NSString *videoMeta;
@property(nonatomic, copy) NSString *videoBufferTime;
@property(nonatomic, copy) NSString *videoConsolidatedBufferTime;

@property(nonatomic) VideoActionTaken action;
@property(nonatomic) VideoState videostate;
@property(nonatomic) int videoWidth;
@property(nonatomic) int videoHeight;

@property(nonatomic) BOOL isVideoEnded;
@property(nonatomic) BOOL isVideoPause;
@property(nonatomic) BOOL isVideoFullScreen;

@property(nonatomic) double videoTotalBufferTime;
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


