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

+(BOOL) isSourcePropertyValid:(enum DigitalProperty) property{

    if (property == INVALID) {
        
        return false;
    }
    return true;
}



@end

