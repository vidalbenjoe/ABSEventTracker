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
#import "Popular.h"

@implementation ABSRecommendationEngine
@synthesize attributesManager;

+(NSMutableArray *) recommendationPopular {
    PropertyEventSource *eventsource = [PropertyEventSource init];
    NSMutableArray *popularRecomendation = [[NSMutableArray alloc] init];
    NSString *proprty = [PropertyEventSource convertPropertyTaken:eventsource.property];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSDictionary *header = @{@"Authorization":[AuthManager retrieveServerTokenFromUserDefault]};
    
    dispatch_async(queue, ^{
        [networking GET:eventAppsBaseURL path:[NSString stringWithFormat:@"%@?propertyID=%@",recommendationPopular, proprty] headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
            [popularRecomendation addObject:responseObject];
        } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    });
    return popularRecomendation;
}

+(NSMutableArray *) recommendationItemToItem{
    PropertyEventSource *eventsource = [PropertyEventSource init];
    AttributeManager *attrib = [AttributeManager init];
    NSMutableArray *itemtoitemArr = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *itemtoitemDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           attrib.deviceinvariant.deviceFingerprint , @"FingerPrintId",
                                           attrib.propertyinvariant.applicationName , @"SiteDomain",
                                           @"1" , @"RecoItemCount",
                                           attrib.userattributes.gigyaID ? @"" : attrib.userattributes.ssoID , @"GigyaID",
                                           eventsource.property , @"RecoPropertyId",nil];
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:itemtoitemDict
                                                       options:0
                                                         error:nil];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?contentID=%@", eventAppsBaseURL,recommendationItemToItem, @"243"]];
    NSDictionary *header = @{@"Content-Type" : @"application/json"};
    dispatch_async(queue, ^{
        [networking POST:url HTTPBody:body headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
            [itemtoitemArr addObject:responseObject];
        } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    });
    
    return itemtoitemArr;
}

+(NSMutableArray *) recommendationUserToItem{
    PropertyEventSource *eventsource = [PropertyEventSource init];
    AttributeManager *attrib = [AttributeManager init];
    NSMutableArray *userToItemArr = [[NSMutableArray alloc] init];
    NSMutableDictionary *usertoitemDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           attrib.userattributes.gigyaID , @"userID",
                                           eventsource.property , @"RecoPropertyId",nil];
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:usertoitemDict
                                                       options:0
                                                         error:nil];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    dispatch_async(queue, ^{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", eventAppsBaseURL,recommendationUserToItem]];
        NSDictionary *header = @{@"Content-Type" : @"application/json", @"Authorization" : [NSString stringWithFormat:@"Bearer %@", [AuthManager retrieveServerTokenFromUserDefault]]};
        
        [networking POST:url HTTPBody:body headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"requestUserToItem: %@", [responseObject description]);
            [userToItemArr addObject:responseObject];
        } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    });
    
    return userToItemArr;
}

+(NSMutableArray *) recommendationCommunityToItem{
    PropertyEventSource *eventsource = [PropertyEventSource init];
    AttributeManager *attrib = [AttributeManager init];
    NSMutableArray *userToItemArr = [[NSMutableArray alloc] init];
    NSMutableDictionary *usertoitemDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           attrib.deviceinvariant.deviceFingerprint , @"FingerPrintId",
                                           attrib.propertyinvariant.applicationName , @"SiteDomain",
                                           @"1" , @"IsReco",
                                           @"4" , @"RecoType",
                                           attrib.userattributes.gigyaID  , @"GigyaID",
                                           eventsource.property , @"RecoPropertyId",nil];
    NSData *body = [NSJSONSerialization dataWithJSONObject:usertoitemDict
                                                       options:0
                                                         error:nil];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    dispatch_async(queue, ^{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", eventAppsBaseURL,recommendationCommunityToItem]];
        NSDictionary *header = @{@"Content-Type" : @"application/json"};
        [networking POST:url HTTPBody:body headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"requestUserToItem: %@", [responseObject description]);
            [userToItemArr addObject:responseObject];
        } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    });
    
    return userToItemArr;
}

@end
