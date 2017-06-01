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
#import "Enumerations.h"
@class VariantBuilder;
@interface Variant : NSObject



@property(nonatomic, readonly) PersistentVariant *persistentVariant;
@property(nonatomic, readonly) ArbitaryVariant *arbitaryVariant;

+(instancetype) makeWithBuilder:(void (^) (VariantBuilder *)) updateBlock;
-(instancetype) initWithBuilder:(VariantBuilder *) builder;
-(instancetype) update:(void(^)(VariantBuilder *)) updateBlock;
-(instancetype) build;

@end

@interface VariantBuilder : NSObject
@property(nonatomic, assign) PersistentVariant *persistentVariant;
@property(nonatomic, assign) ArbitaryVariant *arbitaryVariant;
-(instancetype) init;
@end

