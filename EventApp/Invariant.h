//
//  Invariant.h
//  EventApp
//
//  Created by Benjoe Vidal on 25/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceInvariant.h"
#import "PropertyInvariant.h"
@interface Invariant : NSObject

@property(nonatomic) DeviceInvariant *deviceInvariant;
@property(nonatomic) PropertyInvariant *propertyInvariant;


-(id) initInvariant:(DeviceInvariant*) deviceinvariant propertyInvariant:(PropertyInvariant*) property;



@end
