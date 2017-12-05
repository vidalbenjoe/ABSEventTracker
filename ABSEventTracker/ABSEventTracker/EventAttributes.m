//
//  EventAttributes.m
//  EventApp
//
//  Created by Benjoe Vidal on 22/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "EventAttributes.h"
@implementation EventAttributes

-(instancetype) initWithBuilder:(EventBuilder *)builder{
    if (self = [super init]) {
        
        _clickedContent         = builder.clickedContent;
        _searchQuery            = builder.searchQuery;
        _actionTaken            = builder.actionTaken;
        _readArticle            = builder.readArticle;
        _articleAuthor          = builder.articleAuthor;
        _articlePostDate        = builder.articlePostDate;
        _commentedArticle       = builder.commentedArticle;
        _commentContent         = builder.commentContent;
        _likedContent           = builder.likedContent;
        _shareRetweetContent    = builder.shareRetweetContent;
        _followedEntity         = builder.followedEntity;
        
        _metaTags               = builder.metaTags;
        _previousView           = builder.previousView;
        _destinationView        = builder.destinationView;
        _currentView            = builder.currentView;
        
        _latitute               = builder.latitute;
        _longitude              = builder.longitude;
        
        _articleCharacterCount  = builder.articleCharacterCount;
        _rating                 = builder.rating;
        _readingDuration        = builder.readingDuration;
    }
    
    return self;
}

-(EventBuilder *) makeBuilder{
    EventBuilder *builder = [EventBuilder new];
    builder.actionTaken             = _actionTaken;
    builder.clickedContent          = _clickedContent;
    builder.searchQuery             = _searchQuery;
    builder.readArticle             = _readArticle;
    builder.articleAuthor           = _articleAuthor;
    builder.articlePostDate         = _articlePostDate;
    builder.commentedArticle        = _commentedArticle;
    builder.commentContent          = _commentContent;
    builder.likedContent            = _likedContent;
    builder.shareRetweetContent     = _shareRetweetContent;
    builder.followedEntity          = _followedEntity;
    builder.metaTags                = _metaTags;
    builder.previousView            = _previousView;
    builder.destinationView         = _destinationView;
    builder.currentView             = _currentView;
    builder.latitute                = _latitute;
    builder.longitude               = _longitude;
    builder.articleCharacterCount   = _articleCharacterCount;
    builder.rating                  = _rating;
    builder.readingDuration         = _readingDuration;
    return builder;
}

+(instancetype) makeWithBuilder:(void (^)(EventBuilder *))updateBlock{
    EventBuilder *builder = [EventBuilder new];
    updateBlock(builder);
    
    return [[EventAttributes alloc] initWithBuilder: builder];
}

-(instancetype) update:(void (^)(EventBuilder *))updateBlock{
    EventBuilder *builder = [self makeBuilder];
    updateBlock(builder);
    return [[EventAttributes alloc] initWithBuilder:builder];
}
-(instancetype) build{
    EventBuilder *builder = [EventBuilder new];
    return [self initWithBuilder:builder];
}

+(NSDictionary *) actionTakenByName{
    return @{@(FACEBOOK_LIKE)       : @"FacebookLike",
             @(FACEBOOK_SHARE)      : @"FaceboookShare",
             @(FACEBOOK_FOLLOW)     : @"FacebookFollow",
             @(TWITTER_SHARE)       : @"TwitterShare",
             @(TWITTER_FOLLOW)      : @"TwitterFollow",
             @(INSTAGRAM_SHARE)     : @"InstagramShare",
             @(INSTAGRAM_FOLLOW)    : @"InstagramFollow",
             @(LOGIN)               : @"Login",
             @(LOGOUT)              : @"Logout",
             @(POST_COMMENT)        : @"PostComment",
             @(SEARCH)              : @"Search",
             @(SOCIAL_SHARE)        : @"SocialShare",
             @(SOCIAL_FOLLOW)       : @"SocialFollow",
             @(SOCIAL_LIKE)         : @"SocialLike",
             @(CLICK_HYPERLINK)     : @"ClickHyperlink",
             @(RATE)                : @"Rate",
             @(LOAD)                : @"Load",
             @(CLICK_IMAGE)         : @"ClickImage",
             @(SLIDER)              : @"Slider",
             @(READ_ARTICLES)       : @"ReadArticle",
             @(ABANDON_APP)         : @"Abandon",
             @(OTHERS)              : @"Other",
             @(ACCESS_VIEW)         : @"AccessView",
             @(ABANDON_VIEW)        : @"AbandonView",
             @(VIDEO_PLAYED)        : @"VideoPlayed",
             @(VIDEO_PAUSED)        : @"VideoPaused",
             @(VIDEO_RESUMED)       : @"VideioResumed",
             @(VIDEO_SEEKED)        : @"VideoSeek",
             @(VIDEO_STOPPED)       : @"VideoStopped",
             @(VIDEO_BUFFERED)      : @"VideoBuff",
             @(VIDEO_COMPLETE)      : @"VideoCompleted"
             };
}

+(NSString *) convertActionTaken: (ActionTaken) action{
    return [[self class] actionTakenByName][@(action)];
}

@end

@implementation EventBuilder

-(instancetype) init{
    if (self = [super init]) {
        _clickedContent         = nil;
        _searchQuery            = nil;
        
        _readArticle            = nil;
        _articleAuthor          = nil;
        _articlePostDate        = nil;
        _commentedArticle       = nil;
        _commentContent         = nil;
        _likedContent           = nil;
        _shareRetweetContent    = nil;
        _followedEntity         = nil;
        
        _metaTags               = nil;
        _previousView           = nil;
        _destinationView        = nil;
        _currentView            = nil;
        
        _actionTaken            = 0;
        _latitute               = 0;
        _longitude              = 0;
        
        _articleCharacterCount  = 0;
        _rating                 = 0;
        _readingDuration        = 0;
        
    }
    return self;
}

@end


