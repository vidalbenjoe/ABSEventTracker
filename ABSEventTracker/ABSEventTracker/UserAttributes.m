//
//  UserAttributes.m
//  EventApp
//
//  Created by Benjoe Vidal on 22/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "UserAttributes.h"

@implementation UserAttributes

-(instancetype) initUserWithBuilder:(UserBuilder *)builder{
    if (self = [super init]) {
        _ssoID          =   builder.ssoID;
        _gigyaID        =   builder.gigyaID;
        _firstName      =   builder.firstName;
        _middleName     =   builder.middleName;
        _lastName       =   builder.lastName;
    }
    
    return self;
}

-(UserBuilder *) makeBuilder{
    UserBuilder *builder = [UserBuilder new];
    builder.ssoID       =   _ssoID;
    builder.gigyaID     =   _gigyaID;
    builder.firstName   =   _firstName;
    builder.middleName  =   _middleName;
    builder.lastName    =   _lastName;
    return builder;
}

+(instancetype) makeWithBuilder:(void (^)(UserBuilder *))updateBlock{
    UserBuilder *builder = [UserBuilder new];
    updateBlock(builder);
    return [[UserAttributes alloc] initUserWithBuilder: builder];
}

-(instancetype) update:(void (^)(UserBuilder *))updateBlock{
    UserBuilder *builder = [self makeBuilder];
    updateBlock(builder);
    return [[UserAttributes alloc] initUserWithBuilder:builder];
}
-(instancetype) build{
    UserBuilder *builder = [UserBuilder new];
    return [self initUserWithBuilder:builder];
}

@end


@implementation UserBuilder

-(instancetype) init{
    if (self = [super init]) {
        _ssoID                      =   nil;
        _gigyaID                    =   nil;
        _firstName                  =   nil;
        _middleName                 =   nil;
        _lastName                   =   nil;
    }
    return self;
}

@end
