//
//  Action.h
//  Pods
//
//  Created by Flydubai on 30/06/2017.
//
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
    OTHERS              =   21
};
@interface Action : NSObject
+(NSString *) convertActionTaken: (ActionTaken) action;
@end
