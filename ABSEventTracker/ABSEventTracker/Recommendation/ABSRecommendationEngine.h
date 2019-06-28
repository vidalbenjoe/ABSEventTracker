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
#import "RecommendationAttributes.h"
@interface ABSRecommendationEngine : NSObject

+(void) recommendationUpdate:(void (^)(NSMutableDictionary *userToItem)) userToitem userID: (NSString* ) userID categoryId: (NSString*) categoryId digitalPropertyID: (NSString *) digitalPropertyID;

+(void) updateRecommendations: (RecommendationAttributes *) attributes;
@end
