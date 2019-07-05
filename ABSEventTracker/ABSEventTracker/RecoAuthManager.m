//
//  RecoAuthManager.m
//  ABSEventTracker
//
//  Created by Indra on 22/10/2018.
//  Copyright © 2018 ABS-CBN. All rights reserved.
//

#import "RecoAuthManager.h"
#import "Constant.h"

@implementation RecoAuthManager
+(void) storeRecoTokenReceivedTimestamp: (NSDate *) received{
    [[NSUserDefaults standardUserDefaults] setObject:received forKey:@"recotokenreceivedTimestamp"];
    [self storeRecoTokenExpirationTimestamp:received];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
+(NSDate *) retrieveRecoTokenReceivedTimestamp{
    NSDate *token = (NSDate*) [[NSUserDefaults standardUserDefaults] stringForKey:@"recotokenreceivedTimestamp"];
    return token;
}
+(void) storeRecoTokenExpirationTimestamp:(NSDate *) expiration{
    NSDate *tokenExpirationTime = [expiration dateByAddingTimeInterval:(DEFAULT_RECO_TOKEN_EXPIRATION_IN_MINUTE(s)*60)];
    [[NSUserDefaults standardUserDefaults] setObject:tokenExpirationTime forKey:@"recotokenExpirationTimestamp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSDate *) retrieveRecoTokenExpirationTimestamp{
    NSDate *expiration = (NSDate *)[[NSUserDefaults standardUserDefaults]
                                    objectForKey:@"recotokenExpirationTimestamp"];
    return expiration;
}
/*!
 * Method to store token to NSUserDefault
 */
+(void) storeRecoTokenToUserDefault: (NSString *) value{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"responseRecoToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*!
 * Method to retrieve token from NSUserDefault
 */
+(NSString *) retrieveServerRecoTokenFromUserDefault{
    NSString *token = [[NSUserDefaults standardUserDefaults]
                       stringForKey:@"responseRecoToken"];
    return token;
}
+(void) storeRecoSechashReceivedTimestamp: (NSDate *) received{
    [[NSUserDefaults standardUserDefaults] setObject:received forKey:@"recosechashreceivedTimestamp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self storeRecoTokenExpirationTimestamp:received];
}
+(NSDate *) retrieveRecoSecHashReceivedTimestamp{
    NSDate *token = (NSDate*) [[NSUserDefaults standardUserDefaults] stringForKey:@"recosechashreceivedTimestamp"];
    return token;
}
+(void) storeRecoSecHashExpirationTimestamp:(NSDate *) expiration{
    NSDate *tokenExpirationTime = [expiration dateByAddingTimeInterval:(DEFAULT_RECO_TOKEN_EXPIRATION_IN_MINUTE(s)*60)];
    
    [[NSUserDefaults standardUserDefaults] setObject:tokenExpirationTime forKey:@"recosechashreceivedTimestamp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/*!
 * Method to store securit hash to NSUserDefault
 */
+(void) storeRecoSecurityHashTouserDefault: (NSString *) value{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"recosecurityHash"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*!
 * Method to retrieve security hash to NSUserDefault
 */
+(NSString *) retrieveRecoSecurityHashFromUserDefault{
    NSString *token = [[NSUserDefaults standardUserDefaults]
                       stringForKey:@"recosecurityHash"];
    return token;
}
+(void) removeRecoToken{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"responseRecoToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void) removeRecoSechHash{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"recosecurityHash"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end



