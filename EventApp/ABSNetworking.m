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
@implementation ABSNetworking
NSURLSessionConfiguration *sessionConfiguration;
@synthesize requestBody;
//eventDispatcher
// request for token(saved token)
// if the token is invalid or expired request a new one and update the token from the local storage
// recursion

//same process when requesting Security hash

// Request a new access token


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
    //    NSString *post = @"targetcode=0D8tW72/qS39YRXZcR4q7HwYfsPE2cnKGkaMBLNOWtEpfEPqU8ZW8XJdtcC/D8ELzmDRJFQnj1SUTsCc+KWQ2P+lU51V5D9H+nGBycw0fGA=&grant_type=password";
    requestBody = [[NSMutableURLRequest alloc]
                   initWithURL:url
                   cachePolicy: NSURLRequestUseProtocolCachePolicy
                   timeoutInterval:60.0];
    [requestBody setHTTPMethod:@"POST"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: sessionConfiguration delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:requestBody completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (error) {
                                          // Handle error...
                                          NSHTTPURLResponse* respHttp = (NSHTTPURLResponse*) response;
                                          if (respHttp.statusCode == UNAUTHORIZE) {
                                              NSLog(@"Token_Status: anauthorize");
                                              errorHandler(task, error);
                                          }else if (respHttp.statusCode== BAD_REQUEST) {
                                              NSLog(@"Token_Status: badrequest");
                                          }else if (respHttp.statusCode == INTERNAL_SERVER_ERROR) {
                                              NSLog(@"Token_Status: internalerror");
                                          }else if (respHttp.statusCode== NOT_FOUND) {
                                              NSLog(@"Token_Status: internalerror");
                                          }
                                          return;
                                      }
                                      NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                      successHandler(task, dictionary);
                                      
                                      
                                  }];
    [task resume];
    //DELEGATE
    //     NSURLSession *session = [NSURLSession sessionWithConfiguration: sessionConfiguration delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    //        NSURLSessionDataTask * task = [session dataTaskWithRequest:requestBody];
    //        [task resume];
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
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: sessionConfiguration delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:requestBody completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      if (error) {
                                          // Handle error...
                                          NSHTTPURLResponse* respHttp = (NSHTTPURLResponse*) response;
                                          if (respHttp.statusCode == UNAUTHORIZE) {
                                              NSLog(@"Token_Status: anauthorize");
                                              errorHandler(task, error);
                                          }else if (respHttp.statusCode== BAD_REQUEST) {
                                              NSLog(@"Token_Status: badrequest");
                                          }else if (respHttp.statusCode == INTERNAL_SERVER_ERROR) {
                                              NSLog(@"Token_Status: internalerror");
                                          }else if (respHttp.statusCode== NOT_FOUND) {
                                              NSLog(@"Token_Status: internalerror");
                                          }
                                          return;
                                      }
                                      NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                      successHandler(task, dictionary);
                                      
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
        if (error) {
            // Handle error...
            if (respHttp.statusCode == UNAUTHORIZE) {
                NSLog(@"SecStatus: anauthorize");
            }else if (respHttp.statusCode== BAD_REQUEST) {
                NSLog(@"SecStatus: badrequest");
            }else if (respHttp.statusCode == INTERNAL_SERVER_ERROR) {
                NSLog(@"SecStatus: internalerror");
            }else if (respHttp.statusCode== NOT_FOUND) {
                NSLog(@"SecStatus: internalerror");
            }
            return;
        }
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        successHandler(datatask, dictionary);
        
    }];
    [datatask resume];
}

/* The task has received a response and no further messages will be
 * received until the completion block is called. The disposition
 * allows you to cancel a request or to turn a data task into a
 * download task. This delegate message is optional - if you do not
 * implement it, you can get the response as a property of the task.
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    NSLog(@"### handler 1");
    completionHandler(NSURLSessionResponseAllow);
}
/* Sent when data is available for the delegate to consume.  It is
 * assumed that the delegate will retain and not copy the data.  As
 * the data may be dis-contiguous, you should use
 * [NSData enumerateByteRangesUsingBlock:] to access it.
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Received String %@",str);
    
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    if(error == nil){
        NSLog(@"Download is Succesfull");
        
    }else
        NSLog(@"Error %@",[error userInfo]);
}

@end
