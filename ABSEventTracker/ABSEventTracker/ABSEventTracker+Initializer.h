//
//  ABSEventTracker+Initializer.h
//  ABSEventTracker
//
//  Created by Benjoe Vidal on 30/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//
#import <ABSEventTracker/ABSEventTracker.h>
#import "UserAttributes.h"
#import "EventAttributes.h"
@interface ABSEventTracker (Initializer)
/*!
 * Underlying implentation for ABSEventTracker
 * This class will act as a Facade for different sub-modules that constitutes the entire ABS-CBN BigData iOS library event processing functionality.
 */
+(void) initializeProperty;
/*!
 * Method name: initWithUser
 * Method Description: Initilize User attributes by calling this method on the controller
 * Parameters: UserAttributes - gigyaID, firstname, middleName, lastname
 */
+(void) initWithUser:(UserAttributes *) attributes;
/*!
 * @discussion Initilize Event attributes by calling this method on the controller
 * @params
 * attributes -
 * clickedContent
 * searchQuery
 * actionTaken
 * readArticles
 * articleAuthor
 * articlePostDate
 * commentContent
 * loginTimeStamp
 * likedContent
 * shareRetweetContent
 * followEntity
 * metaTags
 * previousScreen
 * screenDestionation
 * latitude
 * logitude
 * articleCharacterCount
 * rating
 * duration
 */
+(void) initEventAttributes: (EventAttributes *) attributes;
/*!
 * This method returns recommendation from API
 */
+(NSMutableArray*) readPopularRecommendation;

@end
