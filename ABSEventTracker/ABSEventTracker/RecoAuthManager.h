//
//  RecoAuthManager.h
//  ABSEventTracker
//
//  Created by Indra on 22/10/2018.
//  Copyright © 2018 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecoAuthManager : NSObject
@property(nonatomic, retain) NSDate *recoTokenReceivedDate;
@property(nonatomic, retain) NSDate *recoTokenExpirationDate;

+(void) storeRecoTokenReceivedTimestamp: (NSDate *) received;
+(NSDate *) retrieveRecoTokenReceivedTimestamp;
+(void) storeRecoTokenExpirationTimestamp:(NSDate *) expiration;
+(NSDate *) retrieveRecoTokenExpirationTimestamp;
/*!
 * Method to store token to NSUserDefault
 */
+(void) storeRecoTokenToUserDefault: (NSString *) value;
+(void) storeRecoSechashReceivedTimestamp: (NSDate *) received;
+(NSDate *) retrieveRecoSecHashReceivedTimestamp;
+(void) storeRecoSecHashExpirationTimestamp:(NSDate *) expiration;
/*!
 * Method to store securit hash to NSUserDefault
 */
+(void) storeRecoSecurityHashTouserDefault: (NSString *) value;
/*!
 * Method to retrieve token from NSUserDefault
 */
+(NSString *) retrieveServerRecoTokenFromUserDefault;
/*!
 * Method to retrieve security hash to NSUserDefault
 */
+(NSString *) retrieveRecoSecurityHashFromUserDefault;
+(void) removeRecoToken;
+(void) removeRecoSechHash;

@end

NS_ASSUME_NONNULL_END
