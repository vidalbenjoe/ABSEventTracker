//
//  CacheManager.h
//  EventApp
//
//  Created by Benjoe Vidal on 05/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheManager : NSObject

@property(nonatomic) NSNumber *_id;
@property(nonatomic) NSDictionary *cacheDictionary;

+(void) storeFailedAttributesToCacheManager: (NSMutableDictionary *) attributes;
+(NSMutableDictionary *) retrieveFailedAttributesFromCacheByIndex;

@end
