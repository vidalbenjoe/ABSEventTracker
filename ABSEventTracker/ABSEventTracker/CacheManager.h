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
@property(nonatomic) NSDictionary *cacheDictionary;

+(void) storeApplicationLoadTimestamp: (NSString *) value;
+(NSString *) retrieveApplicationLoadTimestamp;
/** Method for storing failed attributes*/
+(void) storeFailedAttributesToCacheManager: (NSMutableDictionary *) attributes;
/** Method for removing the first index of cached attributes after dispatched*/
+(void) removeCachedAttributeByFirstIndex;
/** Method for removing all cached attributes*/
+(void) removeAllCachedAttributes;
/** Method for retrieving failed attrivutes from cached by index*/
+(NSMutableDictionary *) retrieveFailedAttributesFromCacheByIndex;
/** Method for retrivieng all failedd attributes from cache*/
+(NSMutableDictionary *) retrieveAllFailedAttributesFromCache;
+(NSMutableArray *) retrieveAllCacheArray;
@end
