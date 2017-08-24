//
//  ABSRecommendationEngine.h
//  ABSEventTracker
//
//  Created by Benjoe Vidal on 10/07/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ABSRecommendationEngine : NSObject

+(NSMutableArray *) recommendationPopular;
+(NSArray *) recommendationItemToItem;
+(void) recommendation:(void (^)(id itemToItem)) itemToitem;
+(NSMutableArray *) recommendationUserToItem;
+(NSMutableArray *) recommendationCommunityToItem;

@end
