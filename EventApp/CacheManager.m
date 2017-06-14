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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"cache.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath: plistPath]){
     NSString *bundle = [[NSBundle mainBundle] pathForResource:@"cache" ofType:@"plist"];
     [[NSFileManager defaultManager] copyItemAtPath:bundle toPath:plistPath error:&error];
    }
    NSMutableArray *cachedList = [NSMutableArray arrayWithContentsOfFile:plistPath];
    if (nil == cachedList) {
        cachedList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [cachedList addObject:attributes];
    BOOL success = [cachedList writeToFile:plistPath atomically: YES];
    if (success) {
        NSLog(@"Failed server response cached!");
    }else{
        NSLog(@"Failed to save cache");
    }

}

+(NSMutableDictionary *) retrieveFailedAttributesFromCacheByIndex{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *recentFilePath = [documentsDirectory stringByAppendingPathComponent:@"cache.plist"];
    NSMutableArray *history = [NSMutableArray arrayWithContentsOfFile:recentFilePath];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (history.count > 0) {
        [dic setObject:[history objectAtIndex:0] forKey:@"attributes"];
    }
    return dic;
}

+(void) removeCachedAttributeByFirstIndex{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *recentFilePath = [documentsDirectory stringByAppendingPathComponent:@"cache.plist"];
    NSMutableArray *cache = [NSMutableArray arrayWithContentsOfFile:recentFilePath];
    [cache removeObjectAtIndex:0];
    [cache writeToFile:recentFilePath atomically: YES];
}

+ (void) removeAllCachedAttributes
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"cache.plist"];
    NSError *error;
    if(![[NSFileManager defaultManager] removeItemAtPath:path error:&error])
    {
        //TODO: Handle/Log error
    }
}


@end
