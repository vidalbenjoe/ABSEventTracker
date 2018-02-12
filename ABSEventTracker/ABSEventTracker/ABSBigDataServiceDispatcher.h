
//  ABSBigDataServiceDispatcher.h

/**********************************************************************
 **                                                                  **
 **                                                                  **
 **                        ABSEventTracker                           **
 **           Created by Benjoe Vidal on 07/06/2017.                 **
 **                 hello@benjoeriveravidal.com                      **
 **        Copyright © 2017 ABS-CBN. All rights reserved.            **
 **                                                                  **
 **                                                                  **
 **********************************************************************
 */
#import <Foundation/Foundation.h>
#import "AttributeManager.h"
#import "ArbitaryVariant.h"
@interface ABSBigDataServiceDispatcher : NSObject
/*!
 * Method for requesting security hash. This method will return a security hash via block(handler)
 */
+(void) requestSecurityHash: (void (^)(NSString *sechash))handler;
/*!
 * Method for requesting server token. This method will return the server token via block(handler)
 */
//+(void) requestToken: (void (^)(NSString *token))handler;
+(void) requestNewToken: (void (^)(NSString *token))handler;
/*!
 * Method for requesting reco server token. This method will return the recommendation server token via block(handler)
 */
+(void) recoTokenRequest: (void (^)(NSString *token))handler;
/*!
 * Method for event attributes dispatcher. This method is responsible for sending events attributes into the data lake.
 */
//+(void) dispatchAttribute:(AttributeManager *) attributes;
/*!
 * Method for event attributes dispatcher. This method is responsible for sending cached events attributes into the data lake.
 */
+(void) dispatchCachedAttributes;
+(void) dispatcher:(AttributeManager *) attributes;
@end
