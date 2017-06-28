//
//  Validator.m
//  EventApp
//
//  Created by Benjoe Vidal on 25/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "Validator.h"
#import "PropertyEventSource.h"
@implementation Validator

+(BOOL) isSourcePropertyValid:(NSNumber*) property{
    if (property == 0) {
        return false;
    }
    return true;
}

@end

