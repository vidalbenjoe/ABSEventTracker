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
    UNKNOWNSTATE = 0,
    PAUSED     =   1,
    PLAYING    =   2,
    SEEKING    =   3,
    RESUMING   =   4,
    BUFFERING  =   5,
    COMPLETED  =   6
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
@property(nonatomic, copy, readonly) NSString *videoCategoryID;
@property(nonatomic, copy, readonly) NSString *videoContentID;
@property(nonatomic, copy) NSString *videoTimeStamp;
@property(nonatomic, copy, readonly) NSString *videoTitle;
@property(nonatomic, copy, readonly) NSString *videoURL;
@property(nonatomic, copy, readonly) NSString *videoType;
@property(nonatomic, copy, readonly) NSString *videoQuality;
@property(nonatomic, readonly) double videoVolume;

@property(nonatomic) BOOL videoAdClick;
@property(nonatomic) BOOL videoAdComplete;
@property(nonatomic) BOOL videoAdSkipped;
@property(nonatomic) BOOL videoAdError;
@property(nonatomic) BOOL videoAdPlay;

@property(nonatomic, copy, readonly) NSString *videoMeta;
@property(nonatomic, copy) NSString *videoConsolidatedBufferTime;
@property(nonatomic) NSInteger videoTotalBufferTime;
@property(nonatomic) NSInteger videoBufferCount;
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
+(NSString *) convertVideoStateToString: (VideoState) state;
@end

@interface VideoBuilder : NSObject
@property(nonatomic, copy) NSString *videoCategoryID;
@property(nonatomic, copy) NSString *videoContentID;
@property(nonatomic, copy) NSString *videoTimeStamp;
@property(nonatomic, copy) NSString *videoTitle;
@property(nonatomic, copy) NSString *videoURL;
@property(nonatomic, copy) NSString *videoType;
@property(nonatomic, copy) NSString *videoQuality;
@property(nonatomic) double videoVolume;

@property(nonatomic) BOOL videoAdClick;
@property(nonatomic) BOOL videoAdComplete;
@property(nonatomic) BOOL videoAdSkipped;
@property(nonatomic) BOOL videoAdError;
@property(nonatomic) BOOL videoAdPlay;

@property(nonatomic, copy) NSString *videoMeta;
@property(nonatomic, copy) NSString *videoConsolidatedBufferTime;
@property(nonatomic) NSInteger videoTotalBufferTime;
@property(nonatomic) NSInteger videoBufferCount;

@property(assign, nonatomic) ActionTaken actionTaken;
@property(nonatomic) VideoState videostate;
@property(nonatomic) int videoWidth;
@property(nonatomic) int videoHeight;
@property(nonatomic) BOOL isVideoEnded;
@property(nonatomic) BOOL isVideoPause;
@property(nonatomic) BOOL isVideoFullScreen;

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


