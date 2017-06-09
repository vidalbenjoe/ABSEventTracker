//
//  ABSNetworking.m
//  EventApp
//
//  Created by Benjoe Vidal on 01/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//
#import "ABSNetworking.h"
#import "AttributeManager.h"
#import "Constants.h"
#import "ABSBigDataServiceDispatcher.h"
#import "AuthManager.h"
@implementation ABSNetworking
NSURLSessionConfiguration *sessionConfiguration;
@synthesize requestBody;
//eventDispatcher
+(instancetype) initWithSessionConfiguration:(NSURLSessionConfiguration *) config{
    static ABSNetworking *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[super alloc] init];
        sessionConfiguration = config;
    });
    return shared;
}
// Send a dictionary to server
-(void) POST:(NSURL *) url parameters:(NSDictionary *) params success:(void (^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)) successHandler errorHandler:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)) errorHandler{
    requestBody = [[NSMutableURLRequest alloc]
                   initWithURL:url
                   cachePolicy: NSURLRequestUseProtocolCachePolicy
                   timeoutInterval:60.0];
    [requestBody setHTTPMethod:@"POST"];
    
    
//    [sessionConfiguration setHTTPAdditionalHeaders:@{@"authorization": [NSString stringWithFormat:@"bearer %@",[AuthManager retrieveServerTokenFromUserDefault]]}];
//    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: sessionConfiguration delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:requestBody completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                     NSHTTPURLResponse* respHttp = (NSHTTPURLResponse*) response;
                                      if (respHttp.statusCode != SUCCESS) {
                                          [self HTTPerrorLogger:respHttp];
                                          errorHandler(task, error);
                                          return;
                                      }
                                      NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                      successHandler(task, dictionary);
                                      NSLog(@"HTTP_STATUS: success %@", response);
                                  }];
    [task resume];
}
-(void) POST:(NSURL *) url URLparameters:(NSString *) parameters success:(void (^)(NSURLSessionDataTask *  task, id   responseObject)) successHandler errorHandler:(void (^)(NSURLSessionDataTask *  task, NSError *  error)) errorHandler{
     requestBody = [[NSMutableURLRequest alloc]
                   initWithURL:url
                   cachePolicy: NSURLRequestUseProtocolCachePolicy
                   timeoutInterval:60.0];
    [requestBody setHTTPMethod:@"POST"];
    [requestBody setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestBody setHTTPBody:[NSData dataWithBytes:
                              [parameters UTF8String]length:strlen([parameters UTF8String])]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration: sessionConfiguration];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:requestBody completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      NSHTTPURLResponse* respHttp = (NSHTTPURLResponse*) response;
                                      if (respHttp.statusCode != SUCCESS) {
                                          [self HTTPerrorLogger:respHttp];
                                          errorHandler(task, error);
                                          return;
                                      }
                                      
                                      NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                      successHandler(task, dictionary);
                                      NSLog(@"HTTP_STATUS: success %@", response);
                                  }];
    [task resume];
}

-(void) POST:(NSURL *) url URLparameters:(NSString *) parameters headerParameters:(NSDictionary* ) headers success:(void (^)(NSURLSessionDataTask *  task, id   responseObject)) successHandler errorHandler:(void (^)(NSURLSessionDataTask *  task, NSError *  error)) errorHandler{
    
    for (id key in headers){
        id token = [headers objectForKey:key];
        [sessionConfiguration setHTTPAdditionalHeaders:@{key: token}];
    }
    
    requestBody = [[NSMutableURLRequest alloc]
                   initWithURL:url
                   cachePolicy: NSURLRequestUseProtocolCachePolicy
                   timeoutInterval:60.0];
    [requestBody setHTTPMethod:@"POST"];
    [requestBody setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestBody setHTTPBody:[NSData dataWithBytes:
                              [parameters UTF8String]length:strlen([parameters UTF8String])]];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: sessionConfiguration];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:requestBody completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      NSHTTPURLResponse* respHttp = (NSHTTPURLResponse*) response;
                                      if (respHttp.statusCode != SUCCESS) {
                                          [self HTTPerrorLogger:respHttp];
                                          errorHandler(task, error);
                                          return;
                                      }
                                      
                                      NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                      successHandler(task, dictionary);
                                      NSLog(@"HTTP_STATUS: success %@", response);
                                  }];
    [task resume];
}


-(void) GET:(NSString *) url path:(NSString *) path headerParameters:(NSDictionary* ) headers success:(void (^)(NSURLSessionDataTask *  task, id   responseObject)) successHandler errorHandler:(void (^)(NSURLSessionDataTask *  task, NSError *  error)) errorHandler{
    NSURL *urlString = [NSURL URLWithString:url];
    for (id key in headers){
        id mobileHeaderValue = [headers objectForKey:key];
        [sessionConfiguration setHTTPAdditionalHeaders:@{key: mobileHeaderValue}];
    }
    NSURLSession *session = [NSURLSession sessionWithConfiguration: sessionConfiguration delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", url,path]]];
    NSLog(@"GETSTring: %@", [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", urlString,path]]);
    request.HTTPMethod = @"GET";
    NSURLSessionDataTask *datatask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse* respHttp = (NSHTTPURLResponse*) response;
        
        if (respHttp.statusCode != SUCCESS) {
            [self HTTPerrorLogger:respHttp];
            errorHandler(datatask, error);
            return;
        }
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        successHandler(datatask, dictionary);
    }];
    [datatask resume];
}

-(void) HTTPerrorLogger: (NSHTTPURLResponse *) respHttp{
    if (respHttp.statusCode == UNAUTHORIZE) {
        NSLog(@"HTTP_STATUS: anauthorize");
    }else if (respHttp.statusCode== BAD_REQUEST) {
        NSLog(@"HTTP_STATUS: badrequest");
    }else if (respHttp.statusCode == INTERNAL_SERVER_ERROR) {
        NSLog(@"HTTP_STATUS: internalerror");
    }else if (respHttp.statusCode== NOT_FOUND) {
        NSLog(@"HTTP_STATUS: internalerror");
    }
}
@end
