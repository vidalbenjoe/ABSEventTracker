//
//  EventAuthManager.h
//  EventApp
//
//  Created by Benjoe Vidal on 07/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "EventAuthManager.h"
#import "Constant.h"
@implementation EventAuthManager
@synthesize tokenReceivedDate;
@synthesize tokenExpirationDate;

+(void) storeTokenReceivedTimestamp: (NSDate *) received{
    [[NSUserDefaults standardUserDefaults] setObject:received forKey:@"tokenreceivedTimestamp"];
    [self storeTokenExpirationTimestamp:received];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSDate *) retrieveTokenReceivedTimestamp{
    NSLog(@"RETTT");
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
    return expiration;
}

+(void) storeFingerPrintID: (NSString *) value{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"fingerID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *) retrievedFingerPrintID{
    NSString *fingerPrintID = [[NSUserDefaults standardUserDefaults]
                       stringForKey:@"fingerID"];
    return fingerPrintID;
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

+(void) storeSechashReceivedTimestamp: (NSDate *) received{
    [[NSUserDefaults standardUserDefaults] setObject:received forKey:@"sechashreceivedTimestamp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self storeTokenExpirationTimestamp:received];
}
+(NSDate *) retrieveSecHashReceivedTimestamp{
    NSDate *token = (NSDate*) [[NSUserDefaults standardUserDefaults] stringForKey:@"sechashreceivedTimestamp"];
    return token;
}
+(void) storeSecHashExpirationTimestamp:(NSDate *) expiration{
    NSDate *tokenExpirationTime = [expiration dateByAddingTimeInterval:(DEFAULT_SECHASH_EXPIRATION_IN_MINUTE(s)*60)];
    /*
     Multiply by 60 to get the equivalent of seconds to minutes.
     Eq: 50*60 = 3000
     3000 is equivalent to 50 minutes.
     */
    [[NSUserDefaults standardUserDefaults] setObject:tokenExpirationTime forKey:@"sechashreceivedTimestamp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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

+(void) removeToken{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"responseToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void) removeSechHash{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"securityHash"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void) storeSendFlag:(BOOL)sendFlag{
    [[NSUserDefaults standardUserDefaults] setBool:sendFlag forKey:@"sendflag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL) retrieveSendFlag{
   return [[NSUserDefaults standardUserDefaults]
                       boolForKey:@"sendflag"];
}

@end
