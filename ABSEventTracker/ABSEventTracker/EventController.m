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
#import "ABSRecommendationEngine.h"
#import "ABSEventTracker.h"
#import "CacheManager.h"

@implementation EventController
NSString *currentTimeStamp;
NSDate *videoEventTimeStamp;
NSDate *bufferTime;
NSDateFormatter *dateFormatter;
NSMutableArray *buffDurationArray;
NSMutableString *consolidatedBufferDuration;

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
+(void) writeVideoAttributes:(VideoAttributes *)attributes{
    if (buffDurationArray == nil) {
        buffDurationArray = [NSMutableArray array];
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        consolidatedBufferDuration = [NSMutableString string];
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
            currentTimeStamp = [FormatUtils getCurrentTimeAndDate:[NSDate date]];
            [attributes setVideostate:RESUMING];
            break;
        case VIDEO_STOPPED:
            [attributes setVideostate:COMPLETED];
            currentTimeStamp = [FormatUtils getCurrentTimeAndDate:[NSDate date]];
            break;
        case VIDEO_PLAYED:
            [attributes setVideostate:PLAYING];
            [attributes setIsVideoPaused:NO];
            break;
        case VIDEO_PAUSED:
            [attributes setVideostate:PAUSED];
            [attributes setIsVideoPaused:YES];
            break;
        case VIDEO_SEEKED:
            [attributes setVideostate:SEEKING];
            break;
        case VIDEO_COMPLETE:
            [attributes setVideostate:COMPLETED];
            break;
            
        case VIDEO_AD_PLAY:
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
            [[ArbitaryVariant init] setVideoBufferTime:[FormatUtils getCurrentTimeAndDate:[NSDate date]]];
            break;
        case PLAYING:
            currentTimeStamp = [FormatUtils getCurrentTimeAndDate:[NSDate date]];
            break;
        case SEEKING:
            currentTimeStamp = [FormatUtils getCurrentTimeAndDate:[NSDate date]];
            break;
        case COMPLETED:
            [attributes setIsVideoEnded:YES];
            break;
            
        default:
            break;
    }

    [[AttributeManager init] setArbitaryAttributes:[ArbitaryVariant init]];
    bufferTime = [dateFormatter dateFromString:[[ArbitaryVariant init] videoBufferTime]];
    videoEventTimeStamp = [dateFormatter dateFromString:currentTimeStamp];
    
    if (bufferTime != nil) {
        if (videoEventTimeStamp > bufferTime) {
            /*
             * videoEventTimeStamp(PLAY,PAUSE,STOP,RESUME) - bufferTime(VIDEO_BUFFERED)
             */
            [buffDurationArray addObject:[NSNumber numberWithLong: [FormatUtils timeDifferenceInSeconds:bufferTime endTime:videoEventTimeStamp]]];

            for (NSString* key in buffDurationArray){
                if ([consolidatedBufferDuration length]>0)
                    [consolidatedBufferDuration appendString:@"|"];
                    [consolidatedBufferDuration appendFormat:@"%@", key];
            }
            
//            NSNumber *maxValue = [buffDurationArray valueForKeyPath:@"@max.intValue"];
//            NSInteger maxtotalBuffTime = [maxValue integerValue];

            NSInteger sum = 0;
            for (NSNumber *num in buffDurationArray){
                sum += [num intValue];
            }
            
            [attributes setVideoConsolidatedBufferTime:consolidatedBufferDuration];
            [attributes setVideoTotalBufferTime:sum];
            [attributes setVideoBufferCount:[buffDurationArray count]];
            
        }
    }
    GenericEventController *genericAction = [GenericEventController makeWithBuilder:^(GenericBuilder *builder) {
        [builder setActionTaken:attributes.actionTaken];
    }];
    [[AttributeManager init] setGenericAttributes:genericAction];
    [[AttributeManager init] setVideoAttributes:attributes];
}

+(void) writeAudioAttributes:(AudioAttributes *)attributes{
    if (buffDurationArray == nil) {
        buffDurationArray = [NSMutableArray array];
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        consolidatedBufferDuration = [NSMutableString string];
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
            currentTimeStamp = [FormatUtils getCurrentTimeAndDate:[NSDate date]];
             [attributes setAudioPlayerState:AUDIO_RESUMING];
            break;
        case AUDIO_STOPPED:
            [attributes setAudioPlayerState:AUDIO_COMPLETED];
            currentTimeStamp = [FormatUtils getCurrentTimeAndDate:[NSDate date]];
            break;
        case AUDIO_PLAYED:
            [attributes setAudioPlayerState:AUDIO_PLAYING];
            break;
        case AUDIO_PAUSED:
            [attributes setAudioPlayerState:AUDIO_PAUSE];
            [attributes setIsAudioPaused:YES];
            break;
        case AUDIO_COMPLETE:
            [attributes setAudioPlayerState:AUDIO_COMPLETED];
            break;
        default:
            break;
    }
    
    switch (attributes.audioPlayerState) {
        case AUDIO_BUFFERING:
            [[ArbitaryVariant init] setVideoBufferTime:[FormatUtils getCurrentTimeAndDate:[NSDate date]]];
            break;
        case AUDIO_PLAYING:
            currentTimeStamp = [FormatUtils getCurrentTimeAndDate:[NSDate date]];
            break;
        case AUDIO_COMPLETED:
            [attributes setIsAudioEnded:YES];
            break;
        case AUDIO_PAUSE:
            [attributes setActionTaken:AUDIO_PAUSED];
            break;
        default:
            break;
    }
    
    [[AttributeManager init] setArbitaryAttributes:[ArbitaryVariant init]];
    bufferTime = [dateFormatter dateFromString:[[ArbitaryVariant init] videoBufferTime]];
    videoEventTimeStamp = [dateFormatter dateFromString:currentTimeStamp];
    
    if (bufferTime != nil) {
        if (videoEventTimeStamp > bufferTime) {
            /*
             * audioEventTimeStamp(PLAY,PAUSE,STOP,RESUME) - bufferTime(AUDIO_BUFFERED)
             */
            [buffDurationArray addObject:[NSNumber numberWithLong: [FormatUtils timeDifferenceInSeconds:bufferTime endTime:videoEventTimeStamp]]];
            
            for (NSString* key in buffDurationArray){
                if ([consolidatedBufferDuration length]>0)
                    [consolidatedBufferDuration appendString:@"|"];
                [consolidatedBufferDuration appendFormat:@"%@", key];
            }
            
            NSInteger sum = 0;
            for (NSNumber *num in buffDurationArray){sum += [num intValue];}
            
            [attributes setAudioConsolidatedBufferTime:consolidatedBufferDuration];
            [attributes setAudioTotalBufferTime:sum];
            [attributes setAudioBufferCount:[buffDurationArray count]];
            
        }
    }
    GenericEventController *genericAction = [GenericEventController makeWithBuilder:^(GenericBuilder *builder) {
        [builder setActionTaken:attributes.actionTaken];
    }];
    
    [[AttributeManager init] setGenericAttributes:genericAction];
    [[AttributeManager init] setAudioAttributes:attributes];
}

+(void) getRecommendationAttributes:(RecommendationAttributes *) attributes{
    [[AttributeManager init] setRecommendationAttributes:attributes];
}


@end

