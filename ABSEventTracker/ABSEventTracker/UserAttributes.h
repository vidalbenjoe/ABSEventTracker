//
//  UserAttributes.h
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
#import "EventAttributes.h"
@class UserBuilder;
@interface UserAttributes : NSObject<NSCoding>
@property(nonatomic, weak) NSString *ssoID;
@property(nonatomic, weak) NSString *gigyaID;
@property(nonatomic, weak) NSString *loginTimeStamp;

+(instancetype) makeWithBuilder:(void (^) (UserBuilder *)) updateBlock;
-(instancetype) initUserWithBuilder:(UserBuilder *) builder;
-(instancetype) update:(void(^)(UserBuilder *)) updateBlock;
-(instancetype) build;
+(void) cacheUserData: (UserAttributes *) userinfo;
+(void) cachedUserInfoWithID: (NSString *) userID;
+(NSString *) retrieveUserID;

+(UserAttributes *) retrieveUserInfoFromCache;
+(void) clearUserData;
@end

@interface UserBuilder : NSObject
@property(nonatomic, assign) NSString *ssoID;
@property(nonatomic, assign) NSString *gigyaID;
@property(nonatomic, strong) NSString *loginTimeStamp;
-(instancetype) init;

@end

