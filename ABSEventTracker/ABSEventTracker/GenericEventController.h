//
//  GenericEventController.h
//  ABSEventTracker
//
//  Created by Benjoe Vidal on 03/01/2018.
//  Copyright © 2018 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, ActionTaken){
    
    UNKNOWN             =   0,
    FACEBOOK_LIKE       =   1,
    FACEBOOK_SHARE      =   2,
    FACEBOOK_FOLLOW     =   3,
    TWITTER_SHARE       =   4,
    TWITTER_FOLLOW      =   5,
    INSTAGRAM_SHARE     =   6,
    INSTAGRAM_FOLLOW    =   7,
    POST_COMMENT        =   8,
    SEARCH              =   9,
    CLICK_HYPERLINK     =   10,
    SOCIAL_SHARE        =   11,
    SOCIAL_FOLLOW       =   12,
    SOCIAL_LIKE         =   13,
    RATE                =   14,
    CLICK_IMAGE         =   15,
    SLIDER              =   16,
    LOGIN               =   17,
    LOGOUT              =   18,
    READ_ARTICLES       =   19,
    ABANDON_APP         =   20,
    LOAD                =   21,
    OTHERS              =   22,
    ACCESS_VIEW         =   23,
    ABANDON_VIEW        =   24,
    
    VIDEO_PLAYED        =   25,
    VIDEO_PAUSED        =   26,
    VIDEO_RESUMED       =   27,
    VIDEO_SEEKED        =   28,
    VIDEO_STOPPED       =   29,
    VIDEO_BUFFERED      =   30,
    VIDEO_COMPLETE      =   31,
    
    AUDIO_PLAYED        =   32,
    AUDIO_PAUSED        =   33,
    AUDIO_RESUMED       =   34,
    AUDIO_SEEKED        =   35,
    AUDIO_STOPPED       =   36,
    AUDIO_BUFFERED      =   37,
    AUDIO_COMPLETE      =   38
    
};
@class GenericBuilder;
@interface GenericEventController : NSObject
@property(nonatomic) ActionTaken actionTaken;

+(instancetype) makeWithBuilder:(void (^) (GenericBuilder *)) updateBlock;
-(instancetype) initWithBuilder:(GenericBuilder *) builder;
-(instancetype) update:(void(^)(GenericBuilder *)) updateBlock;
-(instancetype) build;
+(NSString *) convertActionTaken: (ActionTaken) action;
@end

@interface GenericBuilder : NSObject
@property(assign, nonatomic) ActionTaken actionTaken;
@end
