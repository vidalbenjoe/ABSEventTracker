//
//  CacheManager.h
//  EventApp
/**********************************************************************
 **                                                                  **
 **                                                                  **
 **                        ABSEventTracker                           **
 **            Created by Benjoe Vidal on 05/06/2017.                **
 **          Copyright © 2017 ABS-CBN. All rights reserved.          **
 **                                                                  **
 **                                                                  **
 **                                                                  **
 **********************************************************************/
#import <Foundation/Foundation.h>

@interface CacheManager : NSObject
@property(nonatomic) NSNumber *_id;
@property(nonatomic) NSDictionary *cacheDictionary;
/*
 * Method for storing failed attributes 
 */
+(void) storeApplicationLoadTimestamp: (NSString *) value;
+(NSString *) retrieveApplicationLoadTimestamp;
+(void) storeFailedAttributesToCacheManager: (NSMutableDictionary *) attributes;
+(void) removeCachedAttributeByFirstIndex;
+(void) removeAllCachedAttributes;
+(NSMutableDictionary *) retrieveFailedAttributesFromCacheByIndex;
+(NSMutableDictionary *) retrieveAllFailedAttributesFromCache;
+(NSMutableArray *) retrieveAllCacheArray;
@end
