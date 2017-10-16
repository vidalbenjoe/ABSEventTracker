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
#import "ItemToItem.h"
#import "UserToItem.h"
@interface ABSRecommendationEngine : NSObject
+(void) recommendationItem:(void (^)(ItemToItem *itemToItem)) itemToitem;
+(void) recommendationUser:(void (^)(UserToItem *userToItem)) userToitem;
@end
