//
//  Validator.h
//  EventApp
//
//  Created by Benjoe Vidal on 25/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PropertyEventSource.h"
#import "Enumerations.h"
@interface Validator : NSObject


+(BOOL) isSourcePropertyValid:(NSNumber *) property;

@end
