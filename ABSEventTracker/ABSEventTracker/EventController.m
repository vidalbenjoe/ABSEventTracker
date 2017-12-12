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
BOOL hasInitialized = false;
NSMutableArray *buffDurationArray;
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

#pragma mark - EventAttributes
/**
 * Wrapper function to write event attributes -> EventAttributes.
 * Function that handle writing of Arbitary, action, and event attributes into AttributeManager
 */
+(void) writeEvent:(EventAttributes *) attributes{
//    NSLog(@"writesterAc %ld", (long)attributes.actionTaken);
    //    ArbitaryVariant *arbitary = [[ArbitaryVariant alloc] init];
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
            break;
    }
    
    [[AttributeManager init] setArbitaryAttributes:[ArbitaryVariant init]];
    [[AttributeManager init] setEventAttributes:attributes];
}
/**
 * This method will gather video attributes triggered by user. It is also a wrapper function to write video event attributes -> VideoAttributes to server
 */
+(void) writeVideoAttributes:(VideoAttributes *)attributes{
    if (buffDurationArray == nil) {
        buffDurationArray = [NSMutableArray array];
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        consolidatedBufferDuration = [NSMutableString string];
    }
    switch (attributes.action) {
        case VIDEO_BUFFERED:
            [attributes setVideostate:BUFFERING];
            break;
        case VIDEO_RESUMED:
            currentTimeStamp = [FormatUtils getCurrentTimeAndDate:[NSDate date]];
            break;
        case VIDEO_STOPPED:
            currentTimeStamp = [FormatUtils getCurrentTimeAndDate:[NSDate date]];
            break;
        case VIDEO_PLAYED:
            [attributes setVideostate:PLAYING];
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
    
    if (attributes.action == UNKNOWN) {
        NSLog(@"Please specify video action");
    }
    
    [[AttributeManager init] setArbitaryAttributes:[ArbitaryVariant init]];
    
    bufferTime = [dateFormatter dateFromString:[[ArbitaryVariant init] videoBufferTime]];
    videoEventTimeStamp = [dateFormatter dateFromString:currentTimeStamp];
    if (bufferTime != nil) {
        if (videoEventTimeStamp > bufferTime) {
            //Formula:  videoEventTimeStamp - bufferTime
            [buffDurationArray addObject:[NSNumber numberWithLong: [FormatUtils timeDifferenceInSeconds:bufferTime endTime:videoEventTimeStamp]]];
        
            for (NSString* key in buffDurationArray){
                if ([consolidatedBufferDuration length]>0)
                    [consolidatedBufferDuration appendString:@"|"];
                    [consolidatedBufferDuration appendFormat:@"%@", key];
            }
//            NSLog(@"consolidatedBufferDuration %@", consolidatedBufferDuration);
//            NSLog(@"buffDurationArray %@", buffDurationArray);

            NSNumber *maxValue = [buffDurationArray valueForKeyPath:@"@max.intValue"];
            NSInteger maxtotalBuffTime = [maxValue integerValue];
            [attributes setVideoConsolidatedBufferTime:consolidatedBufferDuration];
            [attributes setVideoTotalBufferTime:maxtotalBuffTime];
        }
    }
    
    [self writeEvent:[EventAttributes makeWithBuilder:^(EventBuilder *builder) {
        [builder setActionTaken:attributes.action];
    }]];
    
    [[AttributeManager init] setVideoAttributes:attributes];
}



@end

