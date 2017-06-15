//
//  EventAttributes.m
//  EventApp
//
//  Created by Benjoe Vidal on 22/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "EventAttributes.h"
#import "ABSEventAttributeQualifier.h"
#import "ArbitaryVariant.h"
#import "FormatUtils.h"
@implementation EventAttributes
@synthesize violatedQualifiers;
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
    [self action];
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


-(void) action{
    NSLog(@"acion");
    ArbitaryVariant *arbitary = [[ArbitaryVariant alloc] init];
    switch (_actionTaken) {
        case FACEBOOK_LIKE:
            
            break;
            
        case FACEBOOK_SHARE:
            
            break;
            
        case FACEBOOK_FOLLOW:
            break;
            
        case TWITTER_SHARE:
            break;
        case TWITTER_FOLLOW:
            break;
            
        case INSTAGRAM_SHARE:
            break;
            
        case INSTAGRAM_FOLLOW:
            break;
            
        case CLICK_HYPERLINK:
            
            break;
            
        case SOCIAL_SHARE:
            
            break;
            
        case SOCIAL_FOLLOW:
            
            break;
        
        case SOCIAL_LIKE:
            break;
            
        case RATE:
            
            break;
            
        case CLICK_IMAGE:
            break;
            
        case SLIDER:
            break;
            
        case LOGIN:
            break;
        case READ_ARTICLES:
            break;
        case OTHERS:
            break;
        case LOAD:
            NSLog(@"loadwd");
            [arbitary setApplicationLaunchTimeStamp:[FormatUtils getCurrentTimeAndDate]];
            break;
        case ABANDON:
            [arbitary setApplicationAbandonTimeStamp:[FormatUtils getCurrentTimeAndDate]];
            break;
        case LOGOUT:
            [arbitary setLogoutTimeStamp:[FormatUtils getCurrentTimeAndDate]];
            break;
        case SEARCH:
            [arbitary setSearchTimeStamp:[FormatUtils getCurrentTimeAndDate]];
            break;
        case POST_COMMENT:
            [arbitary setPostCommentTimeStamp:[FormatUtils getCurrentTimeAndDate]];
            break;
        default:
            break;
    }
}

@end
