//
//  EventAuthManager.h
//  ABSEventTracker

/**********************************************************************
 **                                                                  **
 **                                                                  **
 **                        ABSEventTracker                           **
 **            Created by Benjoe Vidal on 07/06/2017.                **
 **          Copyright © 2017 ABS-CBN. All rights reserved.          **
 **                                                                  **
 **                                                                  **
 **                                                                  **
 **********************************************************************/

#import <Foundation/Foundation.h>

@interface EventAuthManager : NSObject
@property(nonatomic, retain) NSDate *tokenReceivedDate;
@property(nonatomic, retain) NSDate *tokenExpirationDate;

+(void) storeFingerPrintID: (NSString *) value;
+(NSString *) retrievedFingerPrintID;

+(void) storeTokenReceivedTimestamp: (NSDate *) received;
+(NSDate *) retrieveTokenReceivedTimestamp;
+(void) storeTokenExpirationTimestamp:(NSDate *) expiration;
+(NSDate *) retrieveTokenExpirationTimestamp;
/*!
 * Method to store token to NSUserDefault
 */
+(void) storeTokenToUserDefault: (NSString *) value;
+(void) storeSechashReceivedTimestamp: (NSDate *) received;
+(NSDate *) retrieveSecHashReceivedTimestamp;
+(void) storeSecHashExpirationTimestamp:(NSDate *) expiration;
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
+(void) removeSechHash;

@end
