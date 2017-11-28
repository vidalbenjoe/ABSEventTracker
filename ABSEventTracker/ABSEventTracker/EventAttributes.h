//
//  EventAttributes.h
//  EventApp
/**********************************************************************
 **                                                                  **
 **                                                                  **
 **                        ABSEventTracker                           **
 **            Created by Benjoe Vidal on 22/05/2017.                **
 **          Copyright © 2017 ABS-CBN. All rights reserved.          **
 **                                                                  **
 **                                                                  **
 **                                                                  **
 **********************************************************************/
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
    VIDEO_COMPLETE      =   31
    
};

@class EventBuilder;
@interface EventAttributes : NSObject
@property(nonatomic, copy, readonly) NSString *clickedContent;
@property(nonatomic, copy, readonly) NSString *searchQuery;

@property(nonatomic) ActionTaken actionTaken;

@property(nonatomic, copy, readonly) NSString *readArticle;
@property(nonatomic, copy, readonly) NSString *articleAuthor;
@property(nonatomic, copy, readonly) NSString *articlePostDate;
@property(nonatomic, copy, readonly) NSString *commentedArticle;
@property(nonatomic, copy, readonly) NSString *commentContent;
@property(nonatomic, copy, readonly) NSString *likedContent;
@property(nonatomic, copy, readonly) NSString *shareRetweetContent;
@property(nonatomic, copy, readonly) NSString *followedEntity;

@property(nonatomic, copy, readonly) NSString *metaTags;
@property(nonatomic, copy, readonly) NSString *previousScreen;
@property(nonatomic, copy, readonly) NSString *screenDestination;
@property(nonatomic, copy, readonly) NSString *currentView;

@property(nonatomic) float latitute;
@property(nonatomic) float longitude;
@property(nonatomic) int articleCharacterCount;
@property(nonatomic) int rating;
@property(nonatomic) int readingDuration;

+(instancetype) makeWithBuilder:(void (^) (EventBuilder *)) updateBlock;
-(instancetype) initWithBuilder:(EventBuilder *) builder;
-(instancetype) update:(void(^)(EventBuilder *)) updateBlock;
-(instancetype) build;
+(NSString *) convertActionTaken: (ActionTaken) action;
@end

@interface EventBuilder : NSObject
@property(nonatomic, copy) NSString *clickedContent;
@property(nonatomic, copy) NSString *searchQuery;

@property(assign, nonatomic) ActionTaken actionTaken;

@property(nonatomic, copy) NSString *readArticle;
@property(nonatomic, copy) NSString *articleAuthor;
@property(nonatomic, copy) NSString *articlePostDate;
@property(nonatomic, copy) NSString *commentedArticle;
@property(nonatomic, copy) NSString *commentContent;
@property(nonatomic, copy) NSString *likedContent;
@property(nonatomic, copy) NSString *shareRetweetContent;
@property(nonatomic, copy) NSString *followedEntity;

@property(nonatomic, copy) NSString *metaTags;
@property(nonatomic, copy) NSString *previousScreen;
@property(nonatomic, copy) NSString *screenDestination;
@property(nonatomic, copy) NSString *currentView;

@property(nonatomic) float latitute;
@property(nonatomic) float longitude;
@property(nonatomic) int articleCharacterCount;
@property(nonatomic) int rating;
@property(nonatomic) int readingDuration;

-(instancetype) init;

@end





