//
//  UserAttributes.h
//  EventApp
//
//  Created by Bejoe Vidal on 22/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserBuilder;
@interface UserAttributes : NSObject
@property(nonatomic, weak) NSString *ssoID;
@property(nonatomic, weak) NSString *gigyaID;
@property(nonatomic, weak) NSString *firstName;
@property(nonatomic, weak) NSString *middleName;
@property(nonatomic, weak) NSString *lastName;
@property(nonatomic, weak) NSString *address;
@property(nonatomic, weak) NSDate *birthday;
@property(nonatomic) int mobilenumber;


+(instancetype) makeWithBuilder:(void (^) (UserBuilder *)) updateBlock;
-(instancetype) initUserWithBuilder:(UserBuilder *) builder;
-(instancetype) update:(void(^)(UserBuilder *)) updateBlock;
-(instancetype) build;
@end

@interface UserBuilder : NSObject
@property(nonatomic, assign) NSString *ssoID;
@property(nonatomic, assign) NSString *gigyaID;
@property(nonatomic, strong) NSString *firstName;
@property(nonatomic, strong) NSString *middleName;
@property(nonatomic, strong) NSString *lastName;
-(instancetype) init;

@end

