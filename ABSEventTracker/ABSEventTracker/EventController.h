//
//  EventController.h
/**********************************************************************
 **                                                                  **
 **                                                                  **
 **                        ABSEventTracker                           **
 **           Created by Benjoe Vidal on 31/05/2017.                 **
 **                 hello@benjoeriveravidal.com                      **
 **        Copyright © 2017 ABS-CBN. All rights reserved.            **
 **                                                                  **
 **                                                                  **
 **********************************************************************
 */
#import <Foundation/Foundation.h>
#import "EventAttributes.h"
#import "VideoAttributes.h"
#import "AudioAttributes.h"
@interface EventController : NSObject

/** Method to initialize EventController class */
+(id) initialize;

/**
* Wrapper function to write event attributes -> EventAttributes.
* Function that handle writing of Arbitary, action, and event attributes into AttributeManager
*/

+(void) writeEvent:(EventAttributes *) attributes;
+(void) writeVideoAttributes:(VideoAttributes *) attributes;
+(void) writeAudioAttributes:(AudioAttributes *) attributes;
@end
