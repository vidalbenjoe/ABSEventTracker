//
//  CacheManager.m
//  EventApp
//
//  Created by Benjoe Vidal on 05/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.

#import "CacheManager.h"
@implementation CacheManager
@synthesize _id;
@synthesize cacheDictionary;

+(void) storeFailedAttributesToCacheManager: (NSMutableDictionary *) attributes{
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath: [self cachePath]]){
     NSString *bundle = [[NSBundle mainBundle] pathForResource:@"cache" ofType:@"plist"];
     [[NSFileManager defaultManager] copyItemAtPath:bundle toPath:[self cachePath] error:&error];
    }
    NSMutableArray *cachedList = [NSMutableArray arrayWithContentsOfFile:[self cachePath]];
    if (nil == cachedList) {
        cachedList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [cachedList addObject:attributes];
    BOOL success = [cachedList writeToFile:[self cachePath] atomically: YES];
    if (success) {
        NSLog(@"Failed server response cached!");
    }else{
        NSLog(@"Failed to save cache");
    }
}

+(NSMutableDictionary *) retrieveFailedAttributesFromCacheByIndex{
    NSMutableArray *cache = [NSMutableArray arrayWithContentsOfFile:[self cachePath]];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    if (cache.count > 0) {
        [attributes setObject:[cache objectAtIndex:0] forKey:@"attributes"];
    }
    return attributes;
}


+(NSMutableArray *) retrieveAllCacheArray{
    NSMutableArray *cache = [NSMutableArray arrayWithContentsOfFile:[self cachePath]];

    return cache;
}

+(NSMutableDictionary *) retrieveAllFailedAttributesFromCache{
    NSMutableArray *cache = [NSMutableArray arrayWithContentsOfFile:[self cachePath]];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    for (int i = 0; i < cache.count; i++) {
          [attributes setObject:[cache objectAtIndex:i] forKey:@"attributes"];
    }
    
    return attributes;
}

+(void) removeCachedAttributeByFirstIndex{
    NSMutableArray *cache = [NSMutableArray arrayWithContentsOfFile:[self cachePath]];
    [cache removeObjectAtIndex:0];
    [cache writeToFile:[self cachePath] atomically: YES];
}

+ (void) removeAllCachedAttributes{
    NSError *error;
    if(![[NSFileManager defaultManager] removeItemAtPath:[self cachePath] error:&error])
    {
        //TODO: Handle/Log error
    }
}

+(NSString*) cachePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"cache.plist"];
    return plistPath;
}

@end
