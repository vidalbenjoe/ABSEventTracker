//
//  ABSEventTracker.h
//  ABSEventTracker
//
//  Created by Benjoe Vidal on 31/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ABSEventTracker : NSObject

/** 
 * IMPORTANT : This method should be called on the AppDelegate didFinishLaunchingWithOptions:
 * This method will initialize multiple attribute such as DeviceInvariant and PropertyEventSource.
 * This method will also trigger SessionManager.
 */
+(ABSEventTracker *) initializeTracker;
@end

