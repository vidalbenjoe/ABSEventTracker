//
//  ABSRecommendationEngine.h
//  ABSEventTracker
/**********************************************************************
 **                                                                  **
 **                                                                  **
 **                        ABSEventTracker                           **
 **            Created by Benjoe Vidal on 10/07/2017.                **
 **          Copyright © 2017 ABS-CBN. All rights reserved.          **
 **                                                                  **
 **                                                                  **
 **                                                                  **
 **********************************************************************/
#import <Foundation/Foundation.h>
#import "ItemToItemRecommendation.h"
#import "UserToItem.h"
#import "RecommendationAttributes.h"
@interface ABSRecommendationEngine : NSObject

+(void) recommendationItem:(void (^)(NSMutableDictionary *itemToItem)) itemToitem categoryID:(NSString *) categoryID contentID: (NSString *) contentID digitalProperyID: (NSString* ) digitalproperyID;
+(void) recommendationUser:(void (^)(NSMutableDictionary *userToItem)) userToitem userID: (NSString* ) userID digitalPropertyID: (NSString *) digitalPropertyID;
+(void) recommendationCommunity:(void (^)(NSMutableDictionary *communityToItem)) communityToitem userID: (NSString* ) userID digitalPropertyID: (NSString *) digitalPropertyID;

+(void) updateRecommendation: (RecommendationAttributes *) attributes;
@end
