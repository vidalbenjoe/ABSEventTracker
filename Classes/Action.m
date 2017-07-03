//
//  Action.m
//  Pods
//
//  Created by Flydubai on 30/06/2017.
//
//

#import "Action.h"

@implementation Action

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
