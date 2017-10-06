//
//  AuthManager.h
//  ABSEventTracker
//
//  Created by Benjoe Vidal on 07/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthManager : NSObject
@property(nonatomic, retain) NSDate *tokenReceivedDate;
@property(nonatomic, retain) NSDate *tokenExpirationDate;

+(void) storeTokenReceivedTimestamp: (NSDate *) received;
+(NSDate *) retrieveTokenReceivedTimestamp;
+(void) storeTokenExpirationTimestamp:(NSDate *) expiration;
+(NSDate *) retrieveTokenExpirationTimestamp;

/*!
 * Method to store token to NSUserDefault
 */
+(void) storeTokenToUserDefault: (NSString *) value;

/*!
 * Method to store securit hash to NSUserDefault
 */
+(void) storeSecurityHashTouserDefault: (NSString *) value;
/*!
 * Method to retrieve token from NSUserDefault
 */
+(NSString *) retrieveServerTokenFromUserDefault;
/*!
 * Method to retrieve security hash to NSUserDefault
 */
+(NSString *) retrieveSecurityHashFromUserDefault;
+(void) removeToken;
@end
