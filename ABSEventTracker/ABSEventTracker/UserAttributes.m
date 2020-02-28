//
//  UserAttributes.m
//  EventApp
//
//  Created by Benjoe Vidal on 22/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "UserAttributes.h"

@implementation UserAttributes

NSString* cachedUserName = @"cachedUserName";
NSString* cachedUserID = @"cachedUserID";

-(instancetype) initUserWithBuilder:(UserBuilder *)builder{
    if (self = [super init]) {
        _ssoID          =   builder.ssoID;
        _gigyaID        =   builder.gigyaID;
        _loginTimeStamp =   builder.loginTimeStamp;
        _userName       =   builder.userName;
    }
    return self;
}

+(instancetype) makeWithBuilder:(void (^)(UserBuilder *))updateBlock{
    UserBuilder *builder = [UserBuilder new];
    updateBlock(builder);
    return [[UserAttributes alloc] initUserWithBuilder: builder];
}

-(UserBuilder *) makeBuilder{
    UserBuilder *builder = [UserBuilder new];
    builder.ssoID           =   _ssoID;
    builder.gigyaID         =   _gigyaID;
    builder.userName        =   _userName;
    builder.loginTimeStamp  =   _loginTimeStamp;
    return builder;
}

-(instancetype) update:(void (^)(UserBuilder *)) updateBlock{
    UserBuilder *builder = [self makeBuilder];
    updateBlock(builder);
    return [[UserAttributes alloc] initUserWithBuilder:builder];
}

-(instancetype) build{
    UserBuilder *builder = [UserBuilder new];
    return [self initUserWithBuilder:builder];
}

+(void) cacheUserData: (UserAttributes *) userinfo{
    NSData *encodedPerson = [NSKeyedArchiver archivedDataWithRootObject:userinfo];
    [[NSUserDefaults standardUserDefaults] setObject:encodedPerson forKey:@"encodedPersonKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void) cachedUserInfoWithID: (NSString *) userID name: (NSString*) userName{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:userID forKey:cachedUserID];
    [prefs setValue:userName forKey:cachedUserName];
    [prefs synchronize];
}

+(NSString *) retrieveUserID{
    NSString *userID = [[NSUserDefaults standardUserDefaults]
                       stringForKey:cachedUserID];
    return userID;
}

+(NSString *) retrieveUserName{
    NSString *userName = [[NSUserDefaults standardUserDefaults]
                       stringForKey:cachedUserName];
    return userName;
}

+(UserAttributes *) retrieveUserInfoFromCache{
    //retrieving
    NSData *encodedPerson = [[NSUserDefaults standardUserDefaults] objectForKey:@"encodedPersonKey"];
    UserAttributes *person = (UserAttributes *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedPerson];
    return person;
}

+(void) clearUserData{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cachedUserID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end

@implementation UserBuilder

-(instancetype) init{
    if (self = [super init]) {
        _ssoID                      =   nil;
        _gigyaID                    =   nil;
        _userName                   =   nil;
        _loginTimeStamp             =   nil;
        
    }
    return self;
}

@end
