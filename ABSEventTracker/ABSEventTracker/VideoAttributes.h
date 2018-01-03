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
#import "GenericEventController.h"
// Video States
typedef NS_ENUM(NSInteger, VideoState){
    PAUSED     =   0,
    PLAYING    =   1,
    SEEKING    =   2,
    ON_IDLE    =   3,
    BUFFERING  =   4,
    COMPLETED  =   5
};

@class VideoBuilder;
@interface VideoAttributes : NSObject
@property(nonatomic) ActionTaken actionTaken;
@property(nonatomic) VideoState videostate;
@property(nonatomic, readonly) int videoWidth;
@property(nonatomic, readonly) int videoHeight;
@property(nonatomic) BOOL isVideoEnded;
@property(nonatomic) BOOL isVideoPaused;
@property(nonatomic) BOOL isVideoFullScreen;
@property(nonatomic, assign, readonly) NSString *videoTimeStamp;
@property(nonatomic, assign, readonly) NSString *videoTitle;
@property(nonatomic, assign, readonly) NSString *videoURL;
@property(nonatomic, readonly) double videoVolume;

@property(nonatomic, assign, readonly) NSString *videoAdClick;
@property(nonatomic, assign, readonly) NSString *videoAdComplete;
@property(nonatomic, assign, readonly) NSString *videoAdSkipped;
@property(nonatomic, assign, readonly) NSString *videoAdError;
@property(nonatomic, assign, readonly) NSString *videoAdPlay;
@property(nonatomic, assign, readonly) NSString *videoMeta;
@property(nonatomic, assign) NSString *videoConsolidatedBufferTime;

@property(nonatomic) NSInteger videoTotalBufferTime;
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
+(instancetype) sharedInstance;
-(instancetype) build;
@end

@interface VideoBuilder : NSObject
@property(nonatomic, copy) NSString *videoTimeStamp;
@property(nonatomic, copy) NSString *videoTitle;
@property(nonatomic, assign) NSString *videoURL;
@property(nonatomic) double videoVolume;

@property(nonatomic, assign) NSString *videoAdClick;
@property(nonatomic, assign) NSString *videoAdComplete;
@property(nonatomic, assign) NSString *videoAdSkipped;
@property(nonatomic, assign) NSString *videoAdError;
@property(nonatomic, assign) NSString *videoAdPlay;
@property(nonatomic, assign) NSString *videoMeta;
@property(nonatomic, assign) NSString *videoConsolidatedBufferTime;

@property(assign, nonatomic) ActionTaken actionTaken;
@property(nonatomic) VideoState videostate;
@property(nonatomic) int videoWidth;
@property(nonatomic) int videoHeight;
@property(nonatomic) BOOL isVideoEnded;
@property(nonatomic) BOOL isVideoPause;
@property(nonatomic) BOOL isVideoFullScreen;

@property(nonatomic) NSInteger videoTotalBufferTime;
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


