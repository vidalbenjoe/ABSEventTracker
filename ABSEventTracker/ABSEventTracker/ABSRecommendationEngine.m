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
#import "PropertyEventSource.h"
#import "AttributeManager.h"
@implementation ABSRecommendationEngine

+(void) recommendationItem:(void (^)(ItemToItem *itemToItem)) itemToitem{
    NSError *error;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSMutableDictionary *itemtoitemDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           @"1" , @"recoPropertyID",
                                           @"97743" , @"contentID",nil];
    ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", ItemToItemURL]];
    
    NSDictionary *header = @{@"Authorization" : [NSString stringWithFormat:@"Bearer %@", [AuthManager retrieveServerTokenFromUserDefault]]};
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:itemtoitemDict
                                                   options:kNilOptions
                                                     error:&error];
    NSLog(@"error: %@", error);
    if (!error) {
        dispatch_async(queue, ^{
            [networking POST:url HTTPBody:body headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
                ItemToItem *item = [[ItemToItem alloc] initWithDictionary:responseObject];
                    itemToitem(item);
            } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
              
            }];
        });
    }
}

+(void) recommendationUser:(void (^)(UserToItem *userToItem)) userToitem{
    NSError *error;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSMutableDictionary *itemtoitemDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           @"ff9ef55f-3286-48fd-8b03-c09d91ab8b57" , @"userID",
                                           @"1" , @"recoPropertyID",nil];
    ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", UserToItemURL]];
    
    NSDictionary *header = @{@"Authorization" : [NSString stringWithFormat:@"Bearer %@", [AuthManager retrieveServerTokenFromUserDefault]]};
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:itemtoitemDict
                                                   options:kNilOptions
                                                     error:&error];
    if (!error) {
        dispatch_async(queue, ^{
            [networking POST:url HTTPBody:body headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
                UserToItem *item = [[UserToItem alloc] initWithDictionary:responseObject];
                userToitem(item);
            } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"errorUser:%@", error);
            }];
        });
    }
}




@end
