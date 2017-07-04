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
        _actionTaken           = builder.actionTaken;
        _readArticles           = builder.readArticles;
        _articleAuthor          = builder.articleAuthor;
        _articlePostDate        = builder.articlePostDate;
        _commentContent         = builder.commentContent;
        _loginTimeStamp         = builder.loginTimeStamp;
        _likedContent           = builder.likedContent;
        _shareRetweetContent    = builder.shareRetweetContent;
        _followEntity           = builder.followEntity;
        
        _metaTags               = builder.metaTags;
        _previousScreen         = builder.previousScreen;
        _screenDestination      = builder.screenDestination;
        
        _latitute               = builder.latitute;
        _longitude              = builder.longitude;
        
        _articleCharacterCount  = builder.articleCharacterCount;
        _rating                 = builder.rating;
        _duration               = builder.duration;
    }
    
    return self;
}

-(EventBuilder *) makeBuilder{
    EventBuilder *builder = [EventBuilder new];
    builder.clickedContent          = _clickedContent;
    builder.searchQuery             = _searchQuery;
    builder.readArticles            = _readArticles;
    builder.articleAuthor           = _articleAuthor;
    builder.articlePostDate         = _articlePostDate;
    builder.commentContent          = _commentContent;
    builder.loginTimeStamp          = _loginTimeStamp;
    builder.likedContent            = _likedContent;
    builder.shareRetweetContent     = _shareRetweetContent;
    builder.followEntity            = _followEntity;
    builder.metaTags                = _metaTags;
    builder.previousScreen          = _previousScreen;
    builder.screenDestination       = _screenDestination;
    builder.latitute                = _latitute;
    builder.longitude               = _longitude;
    builder.articleCharacterCount   = _articleCharacterCount;
    builder.rating                  = _rating;
    builder.duration = _duration;
    
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
             @(SEARCH)              : @"Searh",
             @(SOCIAL_SHARE)        : @"SocialShare",
             @(SOCIAL_FOLLOW)       : @"SocialFollow",
             @(SOCIAL_LIKE)         : @"SocialLike",
             @(CLICK_HYPERLINK)     : @"ClickHyperlink",
             @(RATE)                : @"Rate",
             @(LOAD)                : @"Load",
             @(CLICK_IMAGE)         : @"ClikImage",
             @(SLIDER)              : @"Slider",
             @(READ_ARTICLES)       : @"ReadArticle",
             @(ABANDON)             : @"Abandon",
             @(OTHERS)              : @"Other"
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
        
        _actionTaken            = 0;
        
        _readArticles           = nil;
        _articleAuthor          = nil;
        _articlePostDate        = nil;
        _commentContent         = nil;
        _loginTimeStamp         = nil;
        _likedContent           = nil;
        _shareRetweetContent    = nil;
        _followEntity           = nil;
        
        _metaTags               = nil;
        _previousScreen         = nil;
        _screenDestination      = nil;
        
        _latitute               = 0;
        _longitude              = 0;
        
        _articleCharacterCount  = 0;
        _rating                 = 0;
        _duration               = 0;
        
    }
    return self;
}
    

@end

