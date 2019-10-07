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
@interface UserAttributes : NSObject
@property(nonatomic, copy, readonly) NSString *ssoID;
@property(nonatomic, copy, readonly) NSString *gigyaID;

@property(nonatomic, copy, readonly) NSString *loginTimeStamp;

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
@property(nonatomic, copy) NSString *ssoID;
@property(nonatomic, copy) NSString *gigyaID;

@property(nonatomic, copy) NSString *loginTimeStamp;
-(instancetype) init;

@end

