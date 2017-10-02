
/**********************************************************************
 **                                                                  **
 **                                                                  **
 **                        ABSEventTracker                           **
 **           Created by Benjoe Vidal on 31/05/2017.                 **
 **        Copyright © 2017 ABS-CBN. All rights reserved.            **
 **                                                                  **
 **                                                                  **
 **                                                                  **
 **********************************************************************
 */

#import <Foundation/Foundation.h>
#import "UserAttributes.h"
#import "EventAttributes.h"
#import "VideoAttributes.h"
@interface ABSEventTracker : NSObject

/** 
 * IMPORTANT : This method should be called on the AppDelegate didFinishLaunchingWithOptions:
 * This method will initialize multiple attribute such as SessionManager, DeviceInvariant and PropertyEventSource.
 */
+(ABSEventTracker *) initializeTrackerForProd :(BOOL) isProd;

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
+(void) initVideoAttributes: (VideoAttributes *) attributes;

@end

