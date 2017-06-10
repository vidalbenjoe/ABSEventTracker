//
//  CacheManager.m
//  EventApp
//
//  Created by Benjoe Vidal on 05/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "CacheManager.h"

@implementation CacheManager
@synthesize _id;
@synthesize cacheDictionary;

+(void) storeFailedAttributesToCacheManager: (NSString *) identifier attributesDictionary:(NSMutableDictionary *) attributes{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:attributes];
    NSLog(@"attributesDics: %@",attributes);
    NSString *str = attributes[@"id"];
    NSLog(@"dickkey: %@",str);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:data forKey:@"failedAttributesRequest"];
    [userDefaults synchronize];
}

+(NSMutableDictionary *) retrieveFailedAttributesFromCacheManager{
    NSData *newData = [[NSUserDefaults standardUserDefaults] objectForKey:@"failedAttributesRequest"];
    NSMutableDictionary *newDict = [NSKeyedUnarchiver unarchiveObjectWithData:newData];
    
     return newDict;
}

@end
