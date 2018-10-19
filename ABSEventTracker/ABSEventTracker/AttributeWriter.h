//
//  AttributeWriter.h
/**********************************************************************
 **                                                                  **
 **                                                                  **
 **                        ABSEventTracker                           **
 **            Created by Benjoe Vidal on 09/06/2017.                **
 **          Copyright © 2017 ABS-CBN. All rights reserved.          **
 **                                                                  **
 **                                                                  **
 **                                                                  **
 **********************************************************************/
#import <Foundation/Foundation.h>
#import "AttributeManager.h"
@interface AttributeWriter : NSObject
/**
 * This method is resposible for writing event attributes into the server data like.
 * @parameters manager
 */
+(void) writer:(AttributeManager *) manager;
+(void) recommendationWriter:(AttributeManager *) manager;
@end
