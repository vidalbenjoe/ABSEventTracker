
/**********************************************************************
 **                                                                  **
 **                                                                  **
 **                        ABSEventTracker                           **
 **           Created by Benjoe Vidal on 31/05/2017.                 **
 **                 hello@benjoeriveravidal.com                      **
 **        Copyright © 2017 ABS-CBN. All rights reserved.            **
 **                                                                  **
 **                                                                  **
 **********************************************************************
 */

#import <Foundation/Foundation.h>
#import "UserAttributes.h"
#import "EventAttributes.h"
#import "VideoAttributes.h"
#import "AudioAttributes.h"

typedef NS_ENUM(NSInteger, EnvironmentConfig){
     STAGING             =   0,
     PRODUCTION          =   1
};
@interface ABSEventTracker : NSObject

/** 
 * IMPORTANT : This method should be called on the AppDelegate didFinishLaunchingWithOptions:
 * This method will initialize multiple attribute such as SessionManager, DeviceInvariant and PropertyEventSource.
 */

+(ABSEventTracker *) initializeTracker :(EnvironmentConfig) config;

+(void) initWithUser:(UserAttributes *) attributes;

/*!
 * @discussion Initilize Event attributes by calling this method on the controller
 * @params
 * attributes -
 * clickedContent
 * searchQuery
 * actionTaken
 * readArticles
 * articleAuthor
 * articlePostDate
 * commentContent
 * loginTimeStamp
 * likedContent
 * shareRetweetContent
 * followEntity
 * metaTags
 * previousScreen
 * screenDestionation
 * latitude
 * logitude
 * articleCharacterCount
 * rating
 * duration
 */

+(void) initEventAttributes: (EventAttributes *) attributes;
/*!
 * @discussion Initilize Video attributes by calling this method on the controller
 * @params
 * attributes -
 * videoTimeStamp
 * videoTitle
 * videoURL
 * videoVolume
 * videoAdClick
 * videoAdComplete
 * videoAdSkipped
 * videoAdError
 * videoAdPlay
 * videoMeta
 * videoBuffer
 * videoWidth
 * videoHeight
 * action
 * videostate
 * isVideoEnded
 * isVideoPause
 * isVideoFullScreen
 * videoDuration
 * videoSeekStart
 * videoSeekEnd
 * videoAdTime
 * videoPlayPosition
 * videoResumePosition
 * videoStopPosition
 * videoBufferPosition
 */

+(void) initVideoAttributes: (VideoAttributes *) attributes;


+(void) initAudioAttributes: (AudioAttributes *) attributes;

@end

