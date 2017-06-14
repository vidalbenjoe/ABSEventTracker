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
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"myPlistFile.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath: plistPath]){
     NSString *bundle = [[NSBundle mainBundle] pathForResource:@"myPlistFile" ofType:@"plist"];
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
    NSString *recentFilePath = [documentsDirectory stringByAppendingPathComponent:@"myPlistFile.plist"];
    NSArray *history = [NSArray arrayWithContentsOfFile:recentFilePath];
    NSLog(@"historyCount: %@", [history objectAtIndex:0]);

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[history objectAtIndex:0] forKey:@"attributes"];
    return dic;
}

+(void) deleteAttributeCacheByID:(NSString *) attributeID{
//    NSMutableDictionary *cachedAttributes = [self retrieveFailedAttributesFromCacheManager];
//    NSString *cachedAttributeID = cachedAttributes[@"id"];
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [userDefaults dictionaryRepresentation];
    for (id key in dict) {
        NSLog(@"keyDic: %@", key);
//        [userDefaults removeObjectForKey:key];
    }

}

+ (void) removeAllCachedAttributes
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [userDefaults dictionaryRepresentation];
    for (id key in dict) {
//        [userDefaults removeObjectForKey:key];
         NSLog(@"removeKey: %@", key);
    }
    [userDefaults synchronize];
}


@end
