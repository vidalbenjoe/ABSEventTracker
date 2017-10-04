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
        _address        =   builder.address;
        _birthday       =   builder.birthday;
        _mobilenumber   =   builder.mobilenumber;
   
    }
    return self;
}

-(UserBuilder *) makeBuilder{
    UserBuilder *builder = [UserBuilder new];
    builder.ssoID           =   _ssoID;
    builder.gigyaID         =   _gigyaID;
    builder.firstName       =   _firstName;
    builder.middleName      =   _middleName;
    builder.lastName        =   _lastName;
    builder.address         =   _address;
    builder.birthday        =   _birthday;
    builder.mobilenumber    =   _mobilenumber;
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

-(void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.ssoID forKey:@"ssoID"];
    [encoder encodeObject:self.gigyaID forKey:@"gigyaID"];
    [encoder encodeObject:self.firstName forKey:@"firstName"];
    [encoder encodeObject:self.middleName forKey:@"middleName"];
    [encoder encodeObject:self.lastName forKey:@"lastName"];
    [encoder encodeObject:self.address forKey:@"address"];
    [encoder encodeObject:self.birthday forKey:@"birthday"];
}

-(id)initWithCoder:(NSCoder *)decoder {
    self.ssoID = [decoder decodeObjectForKey:@"ssoID"];
    self.gigyaID = [decoder decodeObjectForKey:@"gigyaID"];
    self.firstName = [decoder decodeObjectForKey:@"firstName"];
    self.middleName = [decoder decodeObjectForKey:@"middleName"];
    self.lastName = [decoder decodeObjectForKey:@"lastName"];
    self.address = [decoder decodeObjectForKey:@"address"];
    self.birthday = [decoder decodeObjectForKey:@"birthday"];
    return self;
}

+(void) cacheUserData: (UserAttributes *) userinfo{
    NSData *encodedPerson = [NSKeyedArchiver archivedDataWithRootObject:userinfo];
    [[NSUserDefaults standardUserDefaults] setObject:encodedPerson forKey:@"encodedPersonKey"];
}
+(UserAttributes *) retrieveUserInfoFromCache{
    //retrieving
    NSData *encodedPerson = [[NSUserDefaults standardUserDefaults] objectForKey:@"encodedPersonKey"];
    UserAttributes *person = (UserAttributes *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedPerson];
    return person;
}
+(void) clearUserData{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"encodedPersonKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
        _address                    =   nil;
        _birthday                   =   nil;
        _mobilenumber               =   0;
        
    }
    return self;
}

@end
