//
//  EventController.m or the ABSEngineController
//  EventApp
//
//  Created by Benjoe Vidal on 24/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "EventController.h"
#import "ArbitaryVariant.h"
#import "FormatUtils.h"
#import "AttributeManager.h"
#import "ABSEventTracker.h"
#import "CacheManager.h"
#import "Constant.h"

@implementation EventController
NSDate *currentTimeStamp;
NSDate *videoEventTimeStamp;
NSDate *audioEventTimeStamp;
NSDate *videoConvertedbufferTime;
NSDate *audioConvertedbufferTime;
NSDateFormatter *dateFormatter;
NSMutableArray *videobuffDurationArray;
NSMutableArray *videoPulseArray;
NSMutableArray *audiobuffDurationArray;
NSMutableString *videoconsolidatedBufferDuration;
NSMutableString *audioconsolidatedBufferDuration;
NSDateFormatter * formatter;
NSTimer *videoPulseTimer;
double counter = 0.0;

+(id) initialize{
    static EventController *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[super alloc] init];
    });
    return shared;
}

#pragma mark - writeEvent
/**
 * Wrapper function to write event attributes -> EventAttributes.
 * Function that handle writing of Arbitary, action, and event attributes into AttributeManager
 */
+(void) writeEvent:(EventAttributes *) attributes{
    if (attributes.actionTaken == UNKNOWN) {
        NSLog(@"Please specify event action");
    }
    
    switch (attributes.actionTaken) {
        case LOAD:
            [[ArbitaryVariant init] setApplicationLaunchTimeStamp:[FormatUtils getCurrentTimeAndDate:[NSDate date]]];
            [CacheManager storeApplicationLoadTimestamp:[FormatUtils getCurrentTimeAndDate:[NSDate date]]];
            break;
        case ABANDON_APP:
            [[ArbitaryVariant init] setApplicationAbandonTimeStamp:[FormatUtils getCurrentTimeAndDate:[NSDate date]]];
            break;
        case LOGIN:
            [[ArbitaryVariant init] setLoginTimeStamp:[FormatUtils getCurrentTimeAndDate:[NSDate date]]];
            break;
        case LOGOUT:
            [[ArbitaryVariant init] setLogoutTimeStamp:[FormatUtils getCurrentTimeAndDate:[NSDate date]]];
            [UserAttributes clearUserData];
            break;
        case SEARCH:
            [[ArbitaryVariant init] setSearchTimeStamp:[FormatUtils getCurrentTimeAndDate:[NSDate date]]];
            break;
        case POST_COMMENT:
            [[ArbitaryVariant init] setPostCommentTimeStamp:[FormatUtils getCurrentTimeAndDate:[NSDate date]]];
            break;
        case ACCESS_VIEW:
            [[ArbitaryVariant init] setViewAccessTimeStamp:[FormatUtils getCurrentTimeAndDate:[NSDate date]]];
            break;
        case ABANDON_VIEW:
            [[ArbitaryVariant init] setViewAbandonTimeStamp:[FormatUtils getCurrentTimeAndDate:[NSDate date]]];
            break;
        default:
            [[ArbitaryVariant init] setLoginTimeStamp:nil];
            [[ArbitaryVariant init] setLogoutTimeStamp:nil];
            [[ArbitaryVariant init] setSearchTimeStamp:nil];
            break;
    }
    
    GenericEventController *genericAction = [GenericEventController makeWithBuilder:^(GenericBuilder *builder) {
        [builder setActionTaken:attributes.actionTaken];
    }];
    
    [[AttributeManager init] setGenericAttributes:genericAction];
    [[AttributeManager init] setArbitaryAttributes:[ArbitaryVariant init]];
    [[AttributeManager init] setEventAttributes:attributes];
    
}

/**
 * This method will gather video attributes triggered by user. It is also a wrapper function to write video event attributes -> VideoAttributes to server
 */

#pragma mark - writeVideo
+(void) writeVideoAttributes:(VideoAttributes *) attributes{
    if (videobuffDurationArray == nil) {
        videobuffDurationArray = [NSMutableArray array];
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        videoconsolidatedBufferDuration = [[NSMutableString alloc] init];
        formatter = [[NSDateFormatter alloc] init];
    }
    
    if (videoPulseArray == nil) {
         videoPulseArray = [NSMutableArray array];
    }
    
    if (attributes.actionTaken == UNKNOWN) {
        NSLog(@"Please specify video action");
    }
    
    [attributes setVideoTimeStamp:[FormatUtils getCurrentTimeAndDate:[NSDate date]]];
    switch (attributes.actionTaken) {
            
        case VIDEO_BUFFERED:
            [attributes setVideostate:BUFFERING];
            break;
        case VIDEO_RESUMED:
            currentTimeStamp = [NSDate date];
            [attributes setVideostate:RESUMING];
            break;
        case VIDEO_STOPPED:
            [attributes setVideostate:COMPLETED];
            currentTimeStamp = [NSDate date];
            break;
        case VIDEO_PLAYED:
            [attributes setVideostate:PLAYING];
            [attributes setIsVideoPaused:NO];
            NSLog(@"nalog %f", attributes.videoPulseTimeStamp);
            currentTimeStamp = [NSDate date];
            break;
        case VIDEO_PAUSED:
            [attributes setVideostate:PAUSED];
            [attributes setIsVideoPaused:YES];
            currentTimeStamp = [NSDate date];
            [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector: @selector(terminateVideoPulse) userInfo:nil repeats:NO]; // 5 minutes delay
            // Create condition to determine if idle is below 5 minutes
            break;
        case VIDEO_SEEKED:
            [attributes setVideostate:SEEKING];
            break;
        case VIDEO_COMPLETE:
            [attributes setVideostate:COMPLETED];
            break;
        case VIDEO_AD_PLAY:
            // Should Pause Video Pulse
            [attributes setVideoAdPlay:YES];
            [attributes setVideoAdClick:NO];
            [attributes setVideoAdError:NO];
            [attributes setVideoAdSkipped:NO];
            [attributes setVideoAdComplete:NO];
            break;
        case VIDEO_AD_CLICK:
            [attributes setVideoAdClick:YES];
            [attributes setVideoAdPlay:NO];
            [attributes setVideoAdError:NO];
            [attributes setVideoAdSkipped:NO];
            [attributes setVideoAdComplete:NO];
            break;
        case VIDEO_AD_ERROR:
            [attributes setVideoAdError:YES];
            [attributes setVideoAdPlay:NO];
            [attributes setVideoAdClick:NO];
            [attributes setVideoAdSkipped:NO];
            [attributes setVideoAdComplete:NO];
            break;
        case VIDEO_AD_SKIPPED:
            [attributes setVideoAdSkipped:YES];
            [attributes setVideoAdPlay:NO];
            [attributes setVideoAdClick:NO];
            [attributes setVideoAdError:NO];
            [attributes setVideoAdComplete:NO];
            break;
        case VIDEO_AD_COMPLETE:
            [attributes setVideoAdComplete:YES];
            [attributes setVideoAdSkipped:NO];
            [attributes setVideoAdPlay:NO];
            [attributes setVideoAdClick:NO];
            [attributes setVideoAdError:NO];
            break;
        default:
            break;
    }
    
    switch (attributes.videostate) {
        case BUFFERING:
            [[ArbitaryVariant init] setVideoBufferTime:[NSDate date]];
            break;
        case PLAYING:
            currentTimeStamp = [NSDate date];
            videoPulseTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector: @selector(VideoPulse:) userInfo:attributes repeats:YES]; // 5 seconds delay
            break;
        case SEEKING:
            currentTimeStamp = [NSDate date];
            break;
        case COMPLETED:
            [attributes setIsVideoEnded:YES];
            break;
        default:
            break;
    }
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *videocurrentTime = [formatter stringFromDate:[[ArbitaryVariant init] videoBufferTime]];
    videoConvertedbufferTime = [formatter dateFromString:videocurrentTime];
  
    videoEventTimeStamp = currentTimeStamp;
    // Getting the Video buffer time.
    if (videoConvertedbufferTime != nil) {
        NSComparisonResult result;
        //has three possible values: NSOrderedSame,NSOrderedDescending, NSOrderedAscending
        result = [videoEventTimeStamp compare:videoConvertedbufferTime]; // comparing two dates
        if(result == NSOrderedDescending){
            /*
             * videoEventTimeStamp(PLAY,PAUSE,STOP,RESUME) - bufferTime(VIDEO_BUFFERED)
             */
            [videobuffDurationArray addObject:[NSNumber numberWithLong: [FormatUtils timeDifferenceInSeconds:videoConvertedbufferTime endTime:videoEventTimeStamp]]];
            //            NSNumber *maxValue = [buffDurationArray valueForKeyPath:@"@max.intValue"];
            //            NSInteger maxtotalBuffTime = [maxValue integerValue];/Users/indra/Documents/BIGDATA-MOBILE-LIBRARY/iOS/ABSCBNBigdataAnalyticsiOS/ABSEventTracker/ABSEventTracker/Recommendation/ABSRecommendationEngine.m
            NSInteger sum = 0;
            for (NSNumber *num in videobuffDurationArray){
                sum += [num intValue];
            }
            [attributes setVideoConsolidatedBufferTime:[videobuffDurationArray componentsJoinedByString: @"|"]];
            [attributes setVideoTotalBufferTime:sum];
            [attributes setVideoBufferCount:[videobuffDurationArray count]];
        }
    }
    
    // Get pulse timestamp and store it into string

    GenericEventController *genericAction = [GenericEventController makeWithBuilder:^(GenericBuilder *builder) {
        [builder setActionTaken:attributes.actionTaken];
    }];
    [[AttributeManager init] setGenericAttributes:genericAction];
    [[AttributeManager init] setVideoAttributes:attributes];
    [[AttributeManager init] setArbitaryAttributes:[ArbitaryVariant init]];
}

+(void) VideoPulse:(NSTimer*) timer {
   double i = counter+=5;
   VideoAttributes *videoattributes = [timer userInfo];
    [videoPulseArray addObject:[NSNumber numberWithDouble:i]];
    [videoattributes setVideoConsolidatedPulse:[videoPulseArray componentsJoinedByString:@"|"]];
    NSLog(@"VIDEO PULSE: %@", [videoPulseArray componentsJoinedByString:@"|"]);
    NSLog(@"cpos PULSE: %@", videoattributes.videoConsolidatedPulse);
    NSLog(@"cpos title: %@", videoattributes.videoTitle);
}

+(void) terminateVideoPulse{
    NSLog(@"VideoPulseTerminatedLastIndex %@", [videoPulseArray lastObject]);
    [videoPulseTimer invalidate];
    videoPulseTimer = nil;
    
    [VideoAttributes makeWithBuilder:^(VideoBuilder *builder) {
        [builder setActionTaken:TERMINATE_VIDEO_PULSE];
        [builder setVideoConsolidatedPulse:[videoPulseArray lastObject]];
    }];
}
+(void) writeAudioAttributes:(AudioAttributes *)attributes{
    if (audiobuffDurationArray == nil) {
        audiobuffDurationArray = [NSMutableArray array];
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        audioconsolidatedBufferDuration = [[NSMutableString alloc] init];
    }
    
    if (attributes.actionTaken == UNKNOWN) {
        NSLog(@"Please specify video action");
    }
    
    [attributes setAudioTimeStamp:[FormatUtils getCurrentTimeAndDate:[NSDate date]]];
    
    switch (attributes.actionTaken) {
        case AUDIO_BUFFERED:
            [attributes setAudioPlayerState:AUDIO_BUFFERING];
            break;
        case AUDIO_RESUMED:
            currentTimeStamp = [NSDate date];
             [attributes setAudioPlayerState:AUDIO_RESUMING];
            break;
        case AUDIO_STOPPED:
            [attributes setAudioPlayerState:AUDIO_COMPLETED];
            currentTimeStamp = [NSDate date];
            break;
        case AUDIO_PLAYED:
            currentTimeStamp = [NSDate date];
            [attributes setAudioPlayerState:AUDIO_PLAYING];
            break;
        case AUDIO_PAUSED:
            currentTimeStamp = [NSDate date];
            [attributes setAudioPlayerState:AUDIO_PAUSE];
            [attributes setIsAudioPaused:YES];
            break;
        case AUDIO_COMPLETE:
            [attributes setAudioPlayerState:AUDIO_COMPLETED];
            break;
        case AUDIO_NEXT:
            [attributes setAudioConsolidatedBufferTime:nil];
            [attributes setAudioTotalBufferTime:0];
            [attributes setAudioBufferCount:0];
            break;
        default:
            break;
    }
    
    switch (attributes.audioPlayerState) {
        case AUDIO_BUFFERING:
             [[ArbitaryVariant init] setAudioBufferTime:[NSDate date]];
            break;
        case AUDIO_PLAYING:
            currentTimeStamp = [NSDate date];
            break;
        case AUDIO_COMPLETED:
            [attributes setIsAudioEnded:YES];
            break;
        case AUDIO_PAUSE:
            [attributes setActionTaken:AUDIO_PAUSED];
            currentTimeStamp = [NSDate date];
            break;
        default:
            break;
    }
    
    NSString *audiocurrentTime = [dateFormatter stringFromDate:[[ArbitaryVariant init] audioBufferTime]];
    audioConvertedbufferTime = [dateFormatter dateFromString:audiocurrentTime];
    audioEventTimeStamp = currentTimeStamp;

    if (audioConvertedbufferTime != nil) {
        NSComparisonResult result;
        //has three possible values: NSOrderedSame,NSOrderedDescending, NSOrderedAscending
        result = [audioEventTimeStamp compare:audioConvertedbufferTime]; // comparing two dates
        if(result==NSOrderedDescending){
            /*
             * audioEventTimeStamp(PLAY,PAUSE,STOP,RESUME) - bufferTime(AUDIO_BUFFERED)
             */
            [audiobuffDurationArray addObject:[NSNumber numberWithLong: [FormatUtils timeDifferenceInSeconds:audioConvertedbufferTime endTime:audioEventTimeStamp]]];
            NSInteger sum = 0;
            for (NSNumber *num in audiobuffDurationArray){
                sum += [num intValue];
            }
            [attributes setAudioConsolidatedBufferTime:[audiobuffDurationArray componentsJoinedByString: @"|"]];
            [attributes setAudioTotalBufferTime:sum];
            [attributes setAudioBufferCount:[audiobuffDurationArray count]];
        }
    }
    GenericEventController *genericAction = [GenericEventController makeWithBuilder:^(GenericBuilder *builder) {
        [builder setActionTaken:attributes.actionTaken];
    }];
    if (genericAction.actionTaken != AUDIO_NEXT) {
        [[AttributeManager init] setGenericAttributes:genericAction];
        [[AttributeManager init] setAudioAttributes:attributes];
        [[AttributeManager init] setArbitaryAttributes:[ArbitaryVariant init]];
    }
}

+(void) writeRecommendationAttributes:(RecommendationAttributes *) attributes{
    if (attributes.actionTaken == UNKNOWN) {
        NSLog(@"Please specify video action");
    }
    GenericEventController *genericAction = [GenericEventController makeWithBuilder:^(GenericBuilder *builder) {
        [builder setActionTaken:attributes.actionTaken];
    }];
    
    [[AttributeManager init] setGenericAttributes:genericAction];
    [[AttributeManager init] setRecommendationAttributes:attributes];
}

+(void) getRecommendationAttributes:(RecommendationAttributes *) attributes{
        [[AttributeManager init] updateRecommendation:attributes];
}

@end

