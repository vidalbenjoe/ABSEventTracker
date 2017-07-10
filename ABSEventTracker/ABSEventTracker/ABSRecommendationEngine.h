//
//  ABSRecommendationEngine.h
//  ABSEventTracker
//
//  Created by Benjoe Vidal on 10/07/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AttributeManager.h"
@interface ABSRecommendationEngine : NSObject
@property(nonatomic) AttributeManager *attributesManager;

+(NSMutableArray *) recommendationPopular;
+(NSMutableArray *) recommendationItemToItem;
+(NSMutableArray *) recommendationUserToItem;
+(NSMutableArray *) recommendationCommunityToItem;

@end
