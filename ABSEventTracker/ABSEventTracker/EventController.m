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
+(void) writeEvent:(EventAttributes *) attributes{
    ArbitaryVariant *arbitary = [[ArbitaryVariant alloc] init];
    switch (attributes.actionTaken) {
        case LOAD:
            [arbitary setApplicationLaunchTimeStamp:[FormatUtils getCurrentTimeAndDate:[NSDate date]]];
            break;
        case LOGIN:
            [arbitary setLoginTimeStamp:[FormatUtils getCurrentTimeAndDate:[NSDate date]]];
            break;
        case ABANDON:
            [arbitary setApplicationAbandonTimeStamp:[FormatUtils getCurrentTimeAndDate:[NSDate date]]];
            break;
        case LOGOUT:
            [arbitary setLogoutTimeStamp:[FormatUtils getCurrentTimeAndDate:[NSDate date]]];
            [UserAttributes clearUserData];
            break;
        case SEARCH:
            [arbitary setSearchTimeStamp:[FormatUtils getCurrentTimeAndDate:[NSDate date]]];
            break;
        case POST_COMMENT:
            [arbitary setPostCommentTimeStamp:[FormatUtils getCurrentTimeAndDate:[NSDate date]]];
            break;
      
        default:
            break;
    }
    
    [[AttributeManager init] setArbitaryAttributes:arbitary];
    [[AttributeManager init] setEventAttributes:attributes];
}

+(void) writeVideoAttributes:(VideoAttributes *)attributes{
    switch (attributes.action) {
        case VIDEO_PLAYED:
            
            break;
        case VIDEO_PAUSED:
            [ABSEventTracker initVideoAttributes:[VideoAttributes makeWithBuilder:^(VideoBuilder *builder) {
                [builder setIsVideoPause:YES];
            }]];
            
            
            break;
        case VIDEO_RESUMED:
            
            break;
        case VIDEO_SEEK:
            
            break;
        case VIDEO_STOPPED:
            
            break;
        case VIDEO_BUFFER:
            
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
