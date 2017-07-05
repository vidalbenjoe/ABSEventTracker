//
//  Enumerations.h
//  EventApp
//
//  Created by Benjoe Vidal on 26/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef Enumarations_h
#define Enumarations_h



/// The battery state
///
/// - unknown:   State unknown
/// - unplugged: Battery is not plugged in
/// - charging:  Battery is charging
/// - full:      Battery is full charged

typedef enum{
    UNKNOWN,
    UNPLUGGED,
    CHARGING,
    FULL
} batteryState;


#endif /* Enumarations_h */

@interface Enumerations : NSObject

@end

