//
//  Variant.h
//  EventApp
//
//  Created by Benjoe Vidal on 25/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersistentVariant.h"
#import "ArbitaryVariant.h"
@interface Variant : NSObject

@property(nonatomic) PersistentVariant *persistentVariant;
@property(nonatomic) ArbitaryVariant *arbitaryVariant;

@end
