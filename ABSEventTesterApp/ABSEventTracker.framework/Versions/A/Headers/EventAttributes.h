//
//  EventAttributes.h
//  EventApp
//
//  Created by Benjoe Vidal on 22/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, ActionTaken){
    FACEBOOK_LIKE       =   0,
    FACEBOOK_SHARE      =   1,
    FACEBOOK_FOLLOW     =   2,
    TWITTER_SHARE       =   3,
    TWITTER_FOLLOW      =   4,
    INSTAGRAM_SHARE     =   5,
    INSTAGRAM_FOLLOW    =   6,
    POST_COMMENT        =   7,
    SEARCH              =   8,
    CLICK_HYPERLINK     =   9,
    SOCIAL_SHARE        =   10,
    SOCIAL_FOLLOW       =   11,
    SOCIAL_LIKE         =   12,
    RATE                =   13,
    CLICK_IMAGE         =   14,
    SLIDER              =   15,
    LOGIN               =   16,
    LOGOUT              =   17,
    READ_ARTICLES       =   18,
    ABANDON             =   19,
    LOAD                =   20,
    OTHERS              =   21,
    
    VIDEO_PLAYED        =   22,
    VIDEO_PAUSED        =   23,
    VIDEO_RESUMED       =   24,
    VIDEO_SEEK          =   25,
    VIDEO_STOPPED       =   26,
    VIDEO_BUFFER        =   27,
    VIDEO_COMPLETE      =   28
};


@class EventBuilder;
@interface EventAttributes : NSObject
@property(nonatomic, copy, readonly) NSString *clickedContent;
@property(nonatomic, copy, readonly) NSString *searchQuery;

@property(nonatomic) ActionTaken actionTaken;

@property(nonatomic, copy, readonly) NSString *readArticles;
@property(nonatomic, copy, readonly) NSString *articleAuthor;
@property(nonatomic, copy, readonly) NSString *articlePostDate;
@property(nonatomic, copy, readonly) NSString *commentContent;
@property(nonatomic, copy, readonly) NSString *loginTimeStamp;
@property(nonatomic, copy, readonly) NSString *likedContent;
@property(nonatomic, copy, readonly) NSString *shareRetweetContent;
@property(nonatomic, copy, readonly) NSString *followEntity;

@property(nonatomic, copy, readonly) NSString *metaTags;
@property(nonatomic, copy, readonly) NSString *previousScreen;
@property(nonatomic, copy, readonly) NSString *screenDestination;

@property(nonatomic) float latitute;
@property(nonatomic) float longitude;
@property(nonatomic) int articleCharacterCount;
@property(nonatomic) int rating;
@property(nonatomic) int duration;

+(instancetype) makeWithBuilder:(void (^) (EventBuilder *)) updateBlock;
-(instancetype) initWithBuilder:(EventBuilder *) builder;
-(instancetype) update:(void(^)(EventBuilder *)) updateBlock;
-(instancetype) build;
+(NSString *) convertActionTaken: (ActionTaken) action;
@end

@interface EventBuilder : NSObject
@property(nonatomic, copy) NSString *clickedContent;
@property(nonatomic, copy) NSString *searchQuery;

@property(nonatomic) ActionTaken actionTaken;

@property(nonatomic, copy) NSString *readArticles;
@property(nonatomic, copy) NSString *articleAuthor;
@property(nonatomic, copy) NSString *articlePostDate;
@property(nonatomic, copy) NSString *commentContent;
@property(nonatomic, copy) NSString *loginTimeStamp;
@property(nonatomic, copy) NSString *likedContent;
@property(nonatomic, copy) NSString *shareRetweetContent;
@property(nonatomic, copy) NSString *followEntity;

@property(nonatomic, copy) NSString *metaTags;
@property(nonatomic, copy) NSString *previousScreen;
@property(nonatomic, copy) NSString *screenDestination;

@property(nonatomic) float latitute;
@property(nonatomic) float longitude;
@property(nonatomic) int articleCharacterCount;
@property(nonatomic) int rating;
@property(nonatomic) int duration;

-(instancetype) init;


@end





