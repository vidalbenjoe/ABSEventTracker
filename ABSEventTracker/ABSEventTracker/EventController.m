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
double pulse = 0;

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
//            [[SessionManager init] updateSessionID];
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
            currentTimeStamp = [NSDate date];
            break;
        case VIDEO_PAUSED:
            [attributes setVideostate:PAUSED];
            [attributes setIsVideoPaused:YES];
            currentTimeStamp = [NSDate date];
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

            break;
        case SEEKING:
            currentTimeStamp = [NSDate date];
            break;
        case COMPLETED:
            [attributes setIsVideoEnded:YES];
//            [self terminateVideoPulse];
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
             * videoEventTimeStamp(PLAY,PAUSE,STOxP,RESUME) - bufferTime(VIDEO_BUFFERED)
             */
            [videobuffDurationArray addObject:[NSNumber numberWithLong: [FormatUtils timeDifferenceInSeconds:videoConvertedbufferTime endTime:videoEventTimeStamp]]];
            //            NSNumber *maxValue = [buffDurationArray valueForKeyPath:@"@max.intValue"];
            //            NSInteger maxtotalBuffTime = [maxValue integerValue];
            NSInteger sum = 0;
            for (NSNumber *num in videobuffDurationArray){
                sum += [num intValue];
            }
            
//            NSLog(@"BUFFERSUME: %ld", (long)sum);
//            NSLog(@"CONSBUFFERTIME: %@",[videobuffDurationArray componentsJoinedByString: @"|"]);
            
            [attributes setVideoConsolidatedBufferTime:[videobuffDurationArray componentsJoinedByString: @"|"]];
            [attributes setVideoTotalBufferTime:sum];
            [attributes setVideoBufferCount:[videobuffDurationArray count]];
        }
    }
    
//    //Getting the percentage of total duration
//    double durationPercentage =  attributes.videoDuration * .02;
//    NSLog(@"5 percent of total duration %f" , durationPercentage);
//    pulse = durationPercentage;
//    NSLog(@"Total Duration: %f", attributes.videoDuration);
//    /**
//     * Looping the total video duration to get the segment of duration percentage within the video duration.
//     */
//    for (int i = 1; i < attributes.videoDuration; i++) {
//        // Multiply the percentage duration to get the segment
//        double segment = durationPercentage * i;
//        if (attributes.videoDuration > segment) {
//            NSLog(@"Multiple %f", segment);
//            //Start timer interval on every segment | The interval is now dynamically based on the computed segment.
//            videoPulseTimer = [NSTimer scheduledTimerWithTimeInterval:durationPercentage target:self selector: @selector(VideoPulse:) userInfo:attributes repeats:NO];
//        }else{
//            // Invalidating timer when the segment exceed the total duration
//            [videoPulseTimer invalidate];
//        }
//    }
    
    GenericEventController *genericAction = [GenericEventController makeWithBuilder:^(GenericBuilder *builder) {
        [builder setActionTaken:attributes.actionTaken];
    }];
    [[AttributeManager init] setGenericAttributes:genericAction];
    [[AttributeManager init] setVideoAttributes:attributes];
    [[AttributeManager init] setArbitaryAttributes:[ArbitaryVariant init]];
}

/*
 * This method will be called on every segment.
 * This method consolidate the video pulse.
 */

+(void) VideoPulse:(NSTimer*) timer {
//    5.23Kb Request size
//    3 Hour movie is equals to 10,800
//    5% of 10,800 is 540 secs
//    540 sec is equals to 9 minutes
//    10,800 / 540 = VideoPulse will be called 20 times
//    5.23kb * 20 = 104.6 klb
//    104.6 is equals to 0.106
    
    //Video steam 5 segments in every 5 secs
    /*
     * Increment counter on pulse
     */
    
   double count = counter += pulse;
    NSLog(@"count %f", count);
   VideoAttributes *videoattributes = [timer userInfo];
    [videoPulseArray addObject:[NSNumber numberWithDouble:count]];
    if (videoattributes.videoDuration > count) {
        [videoattributes setVideoConsolidatedPulse:[videoPulseArray componentsJoinedByString:@"|"]];
        NSLog(@"VIDEO PULSE: %@", [videoPulseArray componentsJoinedByString:@"|"]);
        //TODO send video pulse last index to API
        NSLog(@"VideoPulseTerminatedLastIndex %@", [videoPulseArray lastObject]);
        //This will send the VIDEO_PULSE action on every segment.
        
//        [VideoAttributes makeWithBuilder:^(VideoBuilder *builder) {
//            [builder setActionTaken:VIDEO_PULSE];
//        }];
        
        GenericEventController *genericAction = [GenericEventController makeWithBuilder:^(GenericBuilder *builder) {
            [builder setActionTaken:VIDEO_PULSE];
        }];
        
        [[AttributeManager init] setGenericAttributes:genericAction];
        [[AttributeManager init] setVideoAttributes:videoattributes];
    }
}


+(void) terminateVideoPulse{
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


