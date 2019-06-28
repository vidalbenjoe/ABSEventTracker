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

+(void) recommendationUser:(void (^)(NSMutableDictionary *userToItem)) userToitem userID: (NSString* ) userID digitalPropertyID: (NSString *) digitalPropertyID;

+(void) updateRecommendation: (RecommendationAttributes *) attributes;
@end
