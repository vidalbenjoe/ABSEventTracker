//
//  EventController.m or the ABSEngineController
// Act as a Facade(Reading and writing event attributes)
//  EventApp
//
//  Created by Benjoe Vidal on 24/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "EventController.h"
#import "ArbitaryVariant.h"
#import "FormatUtils.h"
#import "AttributeManager.h"
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
    NSLog(@"luggs:%ld",(long)attributes.actionTaken);
    switch (attributes.actionTaken) {
        case LOAD:
            NSLog(@"action-w: Abandoned");
            [arbitary setApplicationLaunchTimeStamp:[FormatUtils getCurrentTimeAndDate:[NSDate date]]];
            break;
        case LOGIN:
            NSLog(@"action-w: LOGIN");
            [arbitary setLoginTimeStamp:[FormatUtils getCurrentTimeAndDate:[NSDate date]]];
            break;
        case ABANDON:
            NSLog(@"action-w: Abandoned");
            [arbitary setApplicationAbandonTimeStamp:[FormatUtils getCurrentTimeAndDate:[NSDate date]]];
            break;
        case LOGOUT:
            NSLog(@"action-w:Logout");
            [arbitary setLogoutTimeStamp:[FormatUtils getCurrentTimeAndDate:[NSDate date]]];
            break;
        case SEARCH:
            NSLog(@"action-w:Search");
            [arbitary setSearchTimeStamp:[FormatUtils getCurrentTimeAndDate:[NSDate date]]];
            break;
        case POST_COMMENT:
            NSLog(@"action-w:Post");
            [arbitary setPostCommentTimeStamp:[FormatUtils getCurrentTimeAndDate:[NSDate date]]];
            break;
        default:
            break;
    }
    [[AttributeManager init] setArbitaryAttributes:arbitary];
    [[AttributeManager init] setEventAttributes:attributes];
}

@end
