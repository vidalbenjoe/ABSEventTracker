//
//  ABSRecommendationEngine.m
//  ABSEventTracker
//
//  Created by Benjoe Vidal on 10/07/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "ABSRecommendationEngine.h"
#import "PropertyEventSource.h"
#import "ABSNetworking.h"
#import "AuthManager.h"

#import "Popular.h"
@implementation ABSRecommendationEngine

/********************RECOMMENDATION********************/

+(NSDictionary *) recommendationPopular {
    NSMutableDictionary *popularRecomendation = [[NSMutableDictionary alloc] init];
    NSString *proprty = [PropertyEventSource convertPropertyTaken:I_WANT_TV];
    NSLog(@"proproprty: %@",proprty);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSDictionary *header = @{@"propertyID" : proprty,
                                 @"authorization" : [AuthManager retrieveServerTokenFromUserDefault]};
        [networking GET:eventAppsBaseURL path:eventMobileResourceURL headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
            NSArray *results = [responseObject valueForKey:@"recommendationDetails"];
            for (NSDictionary *groupDic in results) {
                Popular *popular = [[Popular alloc] init];
                for (NSString *key in groupDic) {
                    if ([popular respondsToSelector:NSSelectorFromString(key)]) {
                        [popular setValue:[groupDic valueForKey:key] forKey:key];
                    }
                }
                [popularRecomendation setObject:popular forKey:@"popular"];
            }
        } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"resporeerrorreco: %@", error);
        }];
    });
    
    return popularRecomendation;
}

+(NSMutableArray *) recommendationItemToItem{
    NSMutableArray *itemtoitemArr = [[NSMutableArray alloc] init];
    NSMutableDictionary *itemtoitemDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           @"0123456" , @"FingerPrintId",
                                           @"jophet_test" , @"SiteDomain",
                                           @"1" , @"RecoItemCount",
                                           @"0" , @"GigyaID",
                                           @"3" , @"RecoPropertyId",nil];
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:itemtoitemDict
                                                       options:0
                                                         error:nil];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    dispatch_async(queue, ^{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?contentID=%@", eventAppsBaseURL,recommendationItemToItem, @"243"]];
        NSDictionary *header = @{@"Content-Type" : @"application/json"};
        [networking POST:url HTTPBody:JSONData headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"requestItemToItem: %@", [responseObject description]);
            [itemtoitemArr addObject:responseObject];
        } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    });
    
    return itemtoitemArr;
    
}

+(NSMutableArray *) recommendationUserToItem{
    NSMutableArray *userToItemArr = [[NSMutableArray alloc] init];
    NSMutableDictionary *usertoitemDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           @"0123456" , @"FingerPrintId",
                                           @"jophet_test" , @"SiteDomain",
                                           @"1" , @"IsReco",
                                           @"2" , @"RecoType",
                                           @"001cea84-00fc-466d-80c4-2f49794f6a2f"  , @"GigyaID",
                                           @"3" , @"RecoPropertyId",nil];
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:usertoitemDict
                                                       options:0
                                                         error:nil];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    dispatch_async(queue, ^{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", eventAppsBaseURL,recommendationUserToItem]];
        NSDictionary *header = @{@"Content-Type" : @"application/json"};
        [networking POST:url HTTPBody:JSONData headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"requestUserToItem: %@", [responseObject description]);
            [userToItemArr addObject:responseObject];
        } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    });
    
    return userToItemArr;
}


+(NSMutableArray *) recommendationCommunityToItem{
    NSMutableArray *userToItemArr = [[NSMutableArray alloc] init];
    NSMutableDictionary *usertoitemDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           @"0123456" , @"FingerPrintId",
                                           @"jophet_test" , @"SiteDomain",
                                           @"1" , @"IsReco",
                                           @"2" , @"RecoType",
                                           @"001cea84-00fc-466d-80c4-2f49794f6a2f"  , @"GigyaID",
                                           @"3" , @"RecoPropertyId",nil];
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:usertoitemDict
                                                       options:0
                                                         error:nil];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    dispatch_async(queue, ^{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", eventAppsBaseURL,recommendationCommunityToItem]];
        NSDictionary *header = @{@"Content-Type" : @"application/json"};
        [networking POST:url HTTPBody:JSONData headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"requestUserToItem: %@", [responseObject description]);
            [userToItemArr addObject:responseObject];
        } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    });
    
    return userToItemArr;
}

@end
