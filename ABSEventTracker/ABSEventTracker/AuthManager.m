//
//  AuthManager.m
//  EventApp
//
//  Created by Benjoe Vidal on 07/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "AuthManager.h"

@implementation AuthManager

+(void) storeTokenToUserDefault: (NSString *) value{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"responseToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *) retrieveServerTokenFromUserDefault{
    NSString *token = [[NSUserDefaults standardUserDefaults]
                       stringForKey:@"responseToken"];
    return token;
}

+(void) storeSecurityHashTouserDefault: (NSString *) value{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"securityHash"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSString *) retrieveSecurityHashFromUserDefault{
    NSString *token = [[NSUserDefaults standardUserDefaults]
                       stringForKey:@"securityHash"];
    return token;
}
@end
