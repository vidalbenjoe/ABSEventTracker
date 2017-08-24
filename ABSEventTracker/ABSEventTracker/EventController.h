//
//  EventController.h
//  EventApp
//
//  Created by Benjoe Vidal on 24/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventAttributes.h"
#import "VideoAttributes.h"
@interface EventController : NSObject
/** Method to initialize EventController class */
+(id) init;

/**
* Wrapper function to write event attributes -> EventAttributes.
* Function that handle writing of Arbitary, action, and event attributes into AttributeManager
*/

+(void) writeEvent:(EventAttributes *) attributes;
+(void) writeVideoAttributes:(VideoAttributes *) attributes;
+(NSMutableArray*) readPopularRecommendation;
+(NSArray*) readItemToItemRecommendation;
+(NSMutableArray*) readUserToItemRecommendation;
+(NSMutableArray*) readCommunityToItemRecommendation;
@end
