
//  ABSBigDataServiceDispatcher.h
//  EventApp
//
//  Created by Benjoe Vidal on 07/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.


#import <Foundation/Foundation.h>
#import "AttributeManager.h"
#import "ArbitaryVariant.h"
@interface ABSBigDataServiceDispatcher : NSObject


+(void) requestSecurityHash: (void (^)(NSString *sechash))handler;

+(void) requestToken: (void (^)(NSString *token))handler;

/*!
 * Method for requesting server token. This method will return the server token via block(handler)
 */
+(void) recoTokenRequest: (void (^)(NSString *token))handler;
/*!
 * Method for event attributes dispatcher. This method is responsible for sending events attributes into the data lake.
 */
+(void) dispatchAttribute:(AttributeManager *) attributes;
+(void) dispatchCachedAttributes;
@end
