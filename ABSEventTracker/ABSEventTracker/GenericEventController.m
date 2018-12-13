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
    return @{@(FACEBOOK_LIKE)       : @"facebooklike",
             @(FACEBOOK_SHARE)      : @"facebookshare",
             @(FACEBOOK_FOLLOW)     : @"facebookfollow",
             @(TWITTER_SHARE)       : @"twittershare",
             @(TWITTER_FOLLOW)      : @"twitterfollow",
             @(INSTAGRAM_SHARE)     : @"instagramshare",
             @(INSTAGRAM_FOLLOW)    : @"instagramfollow",
             @(LOGIN)               : @"login",
             @(LOGOUT)              : @"logout",
             @(POST_COMMENT)        : @"postcomment",
             @(SEARCH)              : @"search",
             @(SOCIAL_SHARE)        : @"socialshare",
             @(SOCIAL_FOLLOW)       : @"socialfollow",
             @(CLICK_HYPERLINK)     : @"clickhyperlink",
             @(RATE)                : @"rate",
             @(LOAD)                : @"load",
             @(CLICK_IMAGE)         : @"clickimage",
             @(SLIDER)              : @"slider",
             @(READ_ARTICLES)       : @"readarticle",
             @(ABANDON_APP)         : @"abandonapp",
             @(OTHERS)              : @"Other",
             @(ACCESS_VIEW)         : @"accessview",
             @(ABANDON_VIEW)        : @"abandonview",
             @(ABANDON_VIEW)        : @"abandonview",
             
             @(VIDEO_PLAYED)        : @"videoplay",
             @(VIDEO_PAUSED)        : @"videopause",
             @(VIDEO_RESUMED)       : @"videoresume",
             @(VIDEO_SEEKED)        : @"videoseek",
             @(VIDEO_STOPPED)       : @"videostop",
             @(VIDEO_BUFFERED)      : @"videobuff",
             @(VIDEO_COMPLETE)      : @"videocomplete",
             
             @(AUDIO_PLAYED)        : @"audioplay",
             @(AUDIO_PAUSED)        : @"audiopause",
             @(AUDIO_RESUMED)       : @"audioresume",
             @(AUDIO_SEEKED)        : @"audioseek",
             @(AUDIO_STOPPED)       : @"audiostop",
             @(AUDIO_BUFFERED)      : @"audiobuff",
             @(AUDIO_COMPLETE)      : @"audiocomplete",
             @(SESSION_EXPIRED)     : @"sessionexpired",
             
             @(VIDEO_AD_CLICK)      : @"videoadclick",
             @(VIDEO_AD_ERROR)      : @"videoaderror",
             @(VIDEO_AD_PLAY)       : @"videoadplay",
             @(VIDEO_AD_SKIPPED)    : @"videoadskipped"
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
