//
//  ABSNetworking.m
//  Created by Benjoe Vidal on 01/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "ABSNetworking.h"
#import "AuthManager.h"
#import "AttributeManager.h"
#import "ABSBigDataServiceDispatcher.h"
#import "ABSNetworking+HTTPErrorHandler.h"
#import "Constant.h"

@implementation ABSNetworking
NSURLSessionConfiguration *sessionConfiguration;
@synthesize requestBody;

+(instancetype) initWithSessionConfiguration:(NSURLSessionConfiguration *) config{
    static ABSNetworking *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[super alloc] init];
        sessionConfiguration = config;
    });
    return shared;
}

-(void) POST:(NSURL *) url parameters:(NSDictionary *) params success:(void (^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)) successHandler errorHandler:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)) errorHandler{
    requestBody = [[NSMutableURLRequest alloc]
                   initWithURL:url
                   cachePolicy: NSURLRequestUseProtocolCachePolicy
                   timeoutInterval:60.0];
    [requestBody setHTTPMethod:@"POST"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration: sessionConfiguration delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    __block NSURLSessionDataTask *task = [session dataTaskWithRequest:requestBody completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      NSHTTPURLResponse* respHttp = (NSHTTPURLResponse*) response;
                                      if (respHttp.statusCode != SUCCESS) {
                                          errorHandler(task, error);
                                          [ABSNetworking HTTPerrorLogger:respHttp];
                                          return;
                                      }
                                      NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                      successHandler(task, dictionary);
                                  }];
    [task resume];
}

-(void) POST:(NSURL *) url URLparameters:(NSString *) parameters success:(void (^)(NSURLSessionDataTask *  task, id   responseObject)) successHandler errorHandler:(void (^)(NSURLSessionDataTask *  task, NSError *  error)) errorHandler{
    requestBody = [[NSMutableURLRequest alloc]
                   initWithURL:url
                   cachePolicy: NSURLRequestReturnCacheDataElseLoad
                   timeoutInterval:60.0];
    [requestBody setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestBody setHTTPMethod:@"POST"];
    [requestBody setHTTPBody:[NSData dataWithBytes:
                              [parameters UTF8String]length:strlen([parameters UTF8String])]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration: sessionConfiguration];
    __block NSURLSessionDataTask *task = [session dataTaskWithRequest:requestBody completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      NSHTTPURLResponse* respHttp = (NSHTTPURLResponse*) response;
                                      if (respHttp.statusCode != SUCCESS) {
                                          [ABSNetworking HTTPerrorLogger:respHttp];
                                          errorHandler(task, error);
                                          return;
                                      }
                                      NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                      successHandler(task, dictionary);
                                  }];
    [task resume];
}

-(void) POST:(NSURL *) url URLparameters:(NSString *) parameters headerParameters:(NSDictionary* ) headers success:(void (^)(NSURLSessionDataTask *  task, id   responseObject)) successHandler errorHandler:(void (^)(NSURLSessionDataTask *  task, NSError *  error)) errorHandler{
    __block NSData *result;
    result = nil;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (id key in headers){
        id token = [headers objectForKey:key];
        [sessionConfiguration setHTTPAdditionalHeaders:@{key: token}];
    }
    sessionConfiguration.URLCache = [NSURLCache sharedURLCache];
    requestBody = [[NSMutableURLRequest alloc]
                   initWithURL:url
                   cachePolicy: NSURLRequestReturnCacheDataElseLoad
                   timeoutInterval:60.0
                   ];
    [requestBody setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestBody setHTTPMethod:@"POST"];
    [requestBody setHTTPBody:[NSData dataWithBytes:
                              [parameters UTF8String]length:strlen([parameters UTF8String])]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration: sessionConfiguration delegate:self delegateQueue:nil];
    dispatch_async(queue, ^{
        [[session dataTaskWithRequest:requestBody completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * error) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            successHandler(nil, dictionary);
            NSHTTPURLResponse* respHttp = (NSHTTPURLResponse*) response;
            if (respHttp.statusCode != SUCCESS) {
                [ABSNetworking HTTPerrorLogger:respHttp];
                errorHandler(nil, error);
                return;
            }
        }] resume];
    });
}


-(void) POST:(NSURL *) url HTTPBody:(NSData *) body headerParameters:(NSDictionary* ) headers success:(void (^)(NSURLSessionDataTask *  task, id   responseObject)) successHandler errorHandler:(void (^)(NSURLSessionDataTask *  task, NSError *  error)) errorHandler{
    for (id key in headers){
        id value = [headers objectForKey:key];
        [sessionConfiguration setHTTPAdditionalHeaders:@{key: value}];
    }
    sessionConfiguration.URLCache = [NSURLCache sharedURLCache];
    requestBody = [[NSMutableURLRequest alloc]
                   initWithURL:url
                   cachePolicy: NSURLRequestReturnCacheDataElseLoad
                   timeoutInterval:60.0
                   ];
    
    [requestBody setHTTPBody:body];
    [requestBody setHTTPMethod:@"POST"];
    [requestBody setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestBody setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration: sessionConfiguration delegate:self delegateQueue:nil];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [[session dataTaskWithRequest:requestBody completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * error) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            successHandler(nil, dictionary);
            NSHTTPURLResponse* respHttp = (NSHTTPURLResponse*) response;
             [ABSNetworking HTTPerrorLogger:respHttp];
            if (respHttp.statusCode != SUCCESS) {
                errorHandler(nil, error);
                return;
            }
        }] resume];
    });
    
}

-(void) GET:(NSString *) url path:(NSString *) path headerParameters:(NSDictionary* ) headers success:(void (^)(NSURLSessionDataTask *  task, id responseObject)) successHandler errorHandler:(void (^)(NSURLSessionDataTask *  task, NSError *  error)) errorHandler{
    for (id key in headers){
        id header = [headers objectForKey:key];
        [sessionConfiguration setHTTPAdditionalHeaders:@{key: header}];
    }
    NSURLSession *session = [NSURLSession sessionWithConfiguration: sessionConfiguration delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", url,path]]];
    request.HTTPMethod = @"GET";
    
    __block NSURLSessionDataTask *datatask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse* respHttp = (NSHTTPURLResponse*) response;
        if (respHttp.statusCode != SUCCESS) {
            [ABSNetworking HTTPerrorLogger:respHttp];
            errorHandler(datatask, error);
            return;
        }
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        successHandler(datatask, dictionary);
    }];
    [datatask resume];
    
}


@end
