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
#import "EventController.h"

@implementation ABSRecommendationEngine
+(void) recommendationItem:(void (^)(NSMutableDictionary *itemToItem)) itemToitem categoryID:(NSString *) categoryID contentID: (NSString *) contentID digitalProperyID: (NSString* ) digitalproperyID{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] enableHTTPLog: YES];
    
    [ABSBigDataServiceDispatcher recoTokenRequest:^(NSString *token) {
        NSError *error;
        NSDictionary *header = @{@"Authorization" : [NSString stringWithFormat:@"Bearer %@", token]};
        if (!error) {
            dispatch_async(queue, ^{
                [networking GET:[NSString stringWithFormat:@"%@%@?categoryId=%@&contentId=%@&digitalPropertyId=%@", devRecoURL, ItemToItemURL, categoryID, contentID, digitalproperyID] path:@"" headerParameters:header
                        success:^(NSURLSessionDataTask *task, id responseObject) {
                            itemToitem(responseObject);
                        } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                            
                        }];
            });
        }
    }];
}

+(void) recommendationUser:(void (^)(NSMutableDictionary *userToItem)) userToitem userID: (NSString* ) userID digitalPropertyID: (NSString *) digitalPropertyID{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] enableHTTPLog: YES];
    [ABSBigDataServiceDispatcher recoTokenRequest:^(NSString *token) {
        NSError *error;
        NSDictionary *header = @{@"Authorization" : [NSString stringWithFormat:@"Bearer %@", token]};
        if (!error) {
            dispatch_async(queue, ^{
                [networking GET:[NSString stringWithFormat:@"%@%@?userId=%@&digitalPropertyId=%@", devRecoURL, UserToItemURL, userID, digitalPropertyID] path:@"" headerParameters:header
                        success:^(NSURLSessionDataTask *task, id responseObject) {
                            userToitem(responseObject);
                        } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                           
                            return;
                        }];
            });
        }
    }];
}

+(void) recommendationCommunity:(void (^)(NSMutableDictionary *communityToItem)) communityToitem userID: (NSString* ) userID digitalPropertyID: (NSString *) digitalPropertyID{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] enableHTTPLog: YES];
    [ABSBigDataServiceDispatcher recoTokenRequest:^(NSString *token) {
        NSError *error;
        NSDictionary *header = @{@"Authorization" : [NSString stringWithFormat:@"Bearer %@", token]};
        if (!error) {
            dispatch_async(queue, ^{
                [networking GET:[NSString stringWithFormat:@"%@%@?userId=%@&digitalPropertyId=%@", devRecoURL, recommendationCommunityToItem, userID, digitalPropertyID] path:@"" headerParameters:header
                        success:^(NSURLSessionDataTask *task, id responseObject) {
                            communityToitem(responseObject);
                        } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                            
                        }];
            });
        }
    }];
    
}

+(void) updateRecommendation: (RecommendationAttributes *) attributes{
    [EventController getRecommendationAttributes:attributes];
}

@end
