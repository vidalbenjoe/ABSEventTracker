//
//  GenericEventController.m
//  ABSEventTracker
//
//  Created by Benjoe Vidal on 03/01/2018.
//  Copyright © 2018 ABS-CBN. All rights reserved.
//

#import "GenericEventController.h"

@implementation GenericEventController
-(instancetype) initWithBuilder:(GenericBuilder *)builder{
    if (self = [super init]) {
        _actionTaken = builder.actionTaken;
    }
    return self;
}

-(GenericBuilder *) makeBuilder{
    GenericBuilder *builder = [GenericBuilder new];
    builder.actionTaken             = _actionTaken;
    return builder;
}

+(instancetype) makeWithBuilder:(void (^)(GenericBuilder *))updateBlock{
    GenericBuilder *builder = [GenericBuilder new];
    updateBlock(builder);
    return [[GenericEventController alloc] initWithBuilder: builder];
}

-(instancetype) update:(void (^)(GenericBuilder *))updateBlock{
    GenericBuilder *builder = [self makeBuilder];
    updateBlock(builder);
    return [[GenericEventController alloc] initWithBuilder:builder];
}
-(instancetype) build{
    GenericBuilder *builder = [GenericBuilder new];
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
             @(ABANDON_APP)         : @"AbandonApp",
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

@implementation GenericBuilder
-(instancetype) init{
    if (self = [super init]) {
        _actionTaken       = 0;
    }
    return self;
}
@end
