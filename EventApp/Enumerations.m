//
//  Enumerations.m
//  EventApp
//
//  Created by Benjoe Vidal on 26/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "Enumerations.h"

@implementation Enumerations
+(NSDictionary *) actionTakenByName{
    return @{@(FACEBOOK_LIKE)       : @"FacebookLike",
             @(FACEBOOK_SHARE)      : @"FaceboookShare",
             @(FACEBOOK_FOLLOW)     : @"FacebookFollow",
             @(TWITTER_SHARE)       : @"TwitterShare",
             @(TWITTER_FOLLOW)      : @"TwitterFollow",
             @(INSTAGRAM_SHARE)     : @"InstagramShare",
             @(INSTAGRAM_FOLLOW)    : @"InstagramFollow",
             @(LOGOUT)              : @"Logout",
             @(POST_COMMENT)        : @"PostComment",
             @(SEARCH)              : @"Searh",
             @(SOCIAL_SHARE)        : @"SocialShare",
             @(SOCIAL_FOLLOW)       : @"SocialFollow",
             @(SOCIAL_LIKE)         : @"SocialLike",
             @(CLICK_HYPERLINK)     : @"ClickHyperlink",
             @(RATE)                : @"Rate",
             @(CLICK_IMAGE)         : @"ClikImage",
             @(FACEBOOK_FOLLOW)     : @"FacebookFollow",
             @(SLIDER)              : @"Slider",
             @(READ_ARTICLES)       : @"ReadArticle",
             @(ABANDON)             : @"Abandon"
             };
}


-(NSString *) actionTakenName{
    return [[self class] actionTakenByName][@(self.property)];
}
@end
