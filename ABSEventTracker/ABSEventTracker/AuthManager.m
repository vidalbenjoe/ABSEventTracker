//
//  AuthManager.m
//  EventApp
//
//  Created by Benjoe Vidal on 07/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "AuthManager.h"
#import "Constant.h"
@implementation AuthManager
@synthesize tokenReceivedDate;
@synthesize tokenExpirationDate;

+(void) storeTokenReceivedTimestamp: (NSDate *) received{
    [[NSUserDefaults standardUserDefaults] setObject:received forKey:@"tokenreceivedTimestamp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self storeTokenExpirationTimestamp:received];
}

+(NSDate *) retrieveTokenReceivedTimestamp{
    NSDate *token = (NSDate*) [[NSUserDefaults standardUserDefaults] stringForKey:@"tokenreceivedTimestamp"];
    return token;
}

+(void) storeTokenExpirationTimestamp:(NSDate *) expiration{
    NSDate *tokenExpirationTime = [expiration dateByAddingTimeInterval:(DEFAULT_TOKEN_EXPIRATION_IN_MINUTE(s)*60)];
    [[NSUserDefaults standardUserDefaults] setObject:tokenExpirationTime forKey:@"tokenExpirationTimestamp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSDate *) retrieveTokenExpirationTimestamp{
    NSDate *expiration = (NSDate *)[[NSUserDefaults standardUserDefaults]
                       objectForKey:@"tokenExpirationTimestamp"];
    NSLog(@"Timeintervalsince originalEnd: %@",expiration);
    return expiration;
}

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
