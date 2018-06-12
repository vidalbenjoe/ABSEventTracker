//
//  ABSRecommendationEngine.m
//  ABSEventTracker
//
//  Created by Benjoe Vidal on 10/07/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "ABSRecommendationEngine.h"
#import "ABSBigDataServiceDispatcher.h"
#import "PropertyEventSource.h"
#import "ABSNetworking.h"
#import "AuthManager.h"
#import "PropertyEventSource.h"
#import "AttributeManager.h"
#import "ABSLogger.h"

@implementation ABSRecommendationEngine
+(void) recommendationItem:(void (^)(ItemToItem *itemToItem)) itemToitem{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSMutableDictionary *itemtoitemDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                @"2", @"recoPropertyId",
                                                @"05947;9A5-DA03-459F-A3FD-D3C6E26126AA" , @"userId",nil];

   ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] enableHTTPLog: YES];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", recoURL, ItemToItemURL]];
    [ABSBigDataServiceDispatcher recoTokenRequest:^(NSString *token) {
     
        NSError *error;
        NSDictionary *header = @{@"Authorization" : [NSString stringWithFormat:@"Bearer %@", token]};
        NSData *body = [NSJSONSerialization dataWithJSONObject:itemtoitemDict
                                                       options:kNilOptions
                                                         error:&error];
      
        if (!error) {
            dispatch_async(queue, ^{
                [networking POST:url HTTPBody:body headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
                    ItemToItem *item = [[ItemToItem alloc] initWithDictionary:responseObject];
                    itemToitem(item);
                    
                } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                    [[ABSLogger initialize] setMessage:error.description];
                }];
            });
        }
    }];
}

+(void) recommendationUser:(void (^)(UserToItem *userToItem)) userToitem{
   
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSMutableDictionary *itemtoitemDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           @"2", @"recoPropertyId",
                                           @"05947;9A5-DA03-459F-A3FD-D3C6E26126AA" , @"userId",nil];
    
  ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] enableHTTPLog: YES];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", recoURL, UserToItemURL]];
     [ABSBigDataServiceDispatcher recoTokenRequest:^(NSString *token) {
        NSError *error;
         NSDictionary *header = @{@"Authorization" : [NSString stringWithFormat:@"Bearer %@", token]};
         NSData *body = [NSJSONSerialization dataWithJSONObject:itemtoitemDict
                                                        options:kNilOptions
                                                          error:&error];
             dispatch_async(queue, ^{
                 [networking POST:url HTTPBody:body headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
                     UserToItem *item = [[UserToItem alloc] initWithDictionary:responseObject];
                     userToitem(item);
                 } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                     [[ABSLogger initialize] setMessage:error.description];
                 }];
             });
          }];
}


@end
