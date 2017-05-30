//
//  UserAttributes.h
//  EventApp
//
//  Created by Bejoe Vidal on 22/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserAttributes : NSObject
@property(nonatomic, weak) NSString *ssoID;
@property(nonatomic, weak) NSString *gigyaID;
@property(nonatomic, weak) NSString *firstName;
@property(nonatomic, weak) NSString *middleName;
@property(nonatomic, weak) NSString *lastName;
@end
