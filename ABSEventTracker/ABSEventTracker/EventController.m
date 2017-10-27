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
@implementation EventController
BOOL hasInitialized = false;

+(id) init{
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
//    ArbitaryVariant *arbitary = [[ArbitaryVariant alloc] init];
    switch (attributes.actionTaken) {
        case LOAD:
            [[ArbitaryVariant init] setApplicationLaunchTimeStamp:[FormatUtils getCurrentTimeAndDate:[NSDate date]]];
            break;
        case ABANDON_APP:
            [[ArbitaryVariant init] setApplicationAbandonTimeStamp:[FormatUtils getCurrentTimeAndDate:[NSDate date]]];
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
    
    int counter;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *videoBufferedTime = [dateFormatter dateFromString:attributes.videoBufferTime];
    counter = 0;
    
    counter = counter+1;
    NSLog(@"ccou3nter: %i", ++counter);
    NSMutableArray *arrayBuff = [NSMutableArray array];
    for(int i = 0; i < counter; i++) {
        
        NSLog(@"ccounter: %i", counter);
//        [arrayBuff addObject:[NSNumber numberWithInt:i]];
    }
    
//[arrayBuff addObject:[FormatUtils timeDifferenceInSeconds:videoBufferedTime endTime:[NSDate date]]];
    
    
    NSMutableString *resultString = [NSMutableString string];
    for (NSString* key in arrayBuff){
        if ([resultString length]>0)
            [resultString appendString:@"|"];
        [resultString appendFormat:@"%@", key];
    }
    NSLog(@"resutltBug %@", resultString);
    NSLog(@"arrayBuff %@", arrayBuff);
    
    [attributes setVideoConsolidatedBufferTime:resultString];
   
//    [VideoAttributes makeWithBuilder:^(VideoBuilder *builder) {
//        [builder setVideoConsolidatedBufferTime:resultString];
//    }];
    
    switch (attributes.videostate) {
        case PAUSED:
            
            break;
            
        case PLAYING:
            
            break;
            
        case SEEKING:
            
            break;
            
        case ON_IDLE:
            
            break;
            
        case BUFFERING:
            [VideoAttributes makeWithBuilder:^(VideoBuilder *builder) {
                [builder setVideoBufferTime:[FormatUtils getCurrentTimeAndDate:[NSDate date]]];
            }];
            break;
            
        case COMPLETED:
            
            break;
        default:
            break;
    }
    
    
    switch (attributes.action) {

        case VIDEO_RESUMED:
            break;
        case VIDEO_SEEK:
            break;
        case VIDEO_STOPPED:
            break;
        case VIDEO_BUFFER:
            
            break;
        case VIDEO_PLAYED:
            break;
        case VIDEO_PAUSED:
            [ABSEventTracker initVideoAttributes:[VideoAttributes makeWithBuilder:^(VideoBuilder *builder) {
                [builder setIsVideoPause:YES];
            }]];
            break;
        case VIDEO_COMPLETE:
            [ABSEventTracker initVideoAttributes:[VideoAttributes makeWithBuilder:^(VideoBuilder *builder) {
               [builder setIsVideoEnded:YES];
            }]];
            break;
    }
         [[AttributeManager init] setVideoAttributes:attributes];
}

/*!
 * @discussion This method will fetch recommendation by popular
 */

@end
