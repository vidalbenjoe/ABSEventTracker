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
#import "ABSLogger.h"

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

-(void) POST:(NSURL *) url parameters:(NSDictionary *) params headerParameters:(NSDictionary* ) headers
     success:(void (^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)) successHandler errorHandler:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)) errorHandler{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    for (id key in headers){
        id token = [headers objectForKey:key];
        [sessionConfiguration setHTTPAdditionalHeaders:@{key: token}];
    }
    requestBody = [[NSMutableURLRequest alloc]
                   initWithURL:url
                   cachePolicy: NSURLRequestReturnCacheDataElseLoad
                   timeoutInterval:120.0];
    [requestBody setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestBody setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestBody setValue:[[[AttributeManager init] propertyinvariant] origin] forHTTPHeaderField:@"Origin"];
    [requestBody setHTTPMethod:@"POST"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: sessionConfiguration delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    dispatch_async(queue, ^{
        
        __block NSURLSessionDataTask *task = [session dataTaskWithRequest:self->requestBody completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                            NSHTTPURLResponse* respHttp = (NSHTTPURLResponse*) response;
                             [ABSNetworking HTTPerrorLogger:respHttp service:[NSString stringWithFormat:@"%@", url] isDebug:YES];
//                            [[ABSLogger initialize] setMessage:response.description];
                                if (respHttp.statusCode != SUCCESS) {
                                    errorHandler(task, error);
                                    return;
                                }
                            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                    successHandler(task, dictionary);
                            }];
        [task resume];
    });
}

/* This method will send string parameters into server and will return server response into blocks handler
 */
-(void) POST:(NSURL *) url URLparameters:(NSString *) parameters success:(void (^)(NSURLSessionDataTask *  task, id   responseObject)) successHandler errorHandler:(void (^)(NSURLSessionDataTask *  task, NSError *  error)) errorHandler{
    requestBody = [[NSMutableURLRequest alloc]
                   initWithURL:url
                   cachePolicy: NSURLRequestUseProtocolCachePolicy
                   timeoutInterval:120.0];
    [requestBody setHTTPMethod:@"POST"];
    [requestBody setHTTPBody:[NSData dataWithBytes:
                              [parameters UTF8String]length:strlen([parameters UTF8String])]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration: sessionConfiguration];
    __block NSURLSessionDataTask *task = [session dataTaskWithRequest:requestBody completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      NSHTTPURLResponse* respHttp = (NSHTTPURLResponse*) response;
                                      if (respHttp.statusCode != SUCCESS) {
                                          errorHandler(task, error);
                                          return;
                                      }
                                      NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                      successHandler(task, dictionary);
                                  }];
    [task resume];
}

/* This method will send request into server without parameter and will return server response into blocks handler
 */

-(void) POST:(NSURL *) url success:(void (^)(NSURLSessionDataTask *  task, id   responseObject)) successHandler errorHandler:(void (^)(NSURLSessionDataTask *  task, NSError *  error)) errorHandler{
    requestBody = [[NSMutableURLRequest alloc]
                   initWithURL:url
                   cachePolicy: NSURLRequestUseProtocolCachePolicy
                   timeoutInterval:120.0];
    [requestBody setHTTPMethod:@"POST"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration: sessionConfiguration];
    __block NSURLSessionDataTask *task = [session dataTaskWithRequest:requestBody completionHandler:
                                          ^(NSData *data, NSURLResponse *response, NSError *error) {
                                              NSHTTPURLResponse* respHttp = (NSHTTPURLResponse*) response;
                                              if (respHttp.statusCode != SUCCESS) {
                                                  errorHandler(task, error);
                                                  return;
                                              }
                                              
                                              NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                              successHandler(task, dictionary);
                                          }];
    [task resume];
}
/*
 * Method: POST
 * This post method is used for sending a string objects with multiple header into server through NSURLSession
 */
-(void) POST:(NSURL *) url URLparameters:(NSString *) parameters headerParameters:(NSDictionary* ) headers success:(void (^)(NSURLSessionDataTask *  task, id   responseObject)) successHandler errorHandler:(void (^)(NSURLSessionDataTask *  task, NSError *  error)) errorHandler{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (id key in headers){
        id token = [headers objectForKey:key];
        [sessionConfiguration setHTTPAdditionalHeaders:@{key: token}];
    }
    sessionConfiguration.URLCache = [NSURLCache sharedURLCache];
    requestBody = [[NSMutableURLRequest alloc]
                   initWithURL:url
                   cachePolicy: NSURLRequestUseProtocolCachePolicy
                   timeoutInterval:120.0
                   ];
    [requestBody setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestBody setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestBody setValue:[[[AttributeManager init] propertyinvariant] siteDomain] forHTTPHeaderField:@"SiteDomain"];
    
    [requestBody setHTTPMethod:@"POST"];
    [requestBody setHTTPBody:[NSData dataWithBytes:
                              [parameters UTF8String]length:strlen([parameters UTF8String])]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration: sessionConfiguration delegate:self delegateQueue:nil];
    dispatch_async(queue, ^{
        [[session dataTaskWithRequest:self->requestBody completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * error) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            successHandler(nil, dictionary);
            NSHTTPURLResponse* respHttp = (NSHTTPURLResponse*) response;
            [ABSNetworking HTTPerrorLogger:respHttp service:[NSString stringWithFormat:@"%@", url] isDebug:YES];
            if (respHttp.statusCode != SUCCESS) {
                errorHandler(nil, error);
                return;
            }
        }] resume];
    });
}

/*
 * Method: POST
 * This post method is used for sending json object with multiple header into server through NSURLSession
 */
-(void) POST:(NSURL *) url HTTPBody:(NSData *) body headerParameters:(NSDictionary* ) headers success:(void (^)(NSURLSessionDataTask *  task, id   responseObject)) successHandler errorHandler:(void (^)(NSURLSessionDataTask *  task, NSError *  error)) errorHandler{
//    NSError *error;
    for (id key in headers){
        id value = [headers objectForKey:key];
        [sessionConfiguration setHTTPAdditionalHeaders:@{key: value}];
    }
        sessionConfiguration.URLCache = [NSURLCache sharedURLCache];
        requestBody = [[NSMutableURLRequest alloc]
                       initWithURL:url
                       cachePolicy: NSURLRequestReloadIgnoringLocalCacheData
                       timeoutInterval:220.0
                       ];
        
        [requestBody setHTTPMethod:@"POST"];
        [requestBody setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [requestBody setValue:[[[AttributeManager init] propertyinvariant] siteDomain]
           forHTTPHeaderField:@"SiteDomain"];
        [requestBody setValue:[[[AttributeManager init] propertyinvariant] origin]
           forHTTPHeaderField:@"Origin"];
        [requestBody setHTTPBody:body];
    
//    NSMutableDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:body options:0 error:&error];
  
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: sessionConfiguration delegate:self delegateQueue:nil];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        [[session dataTaskWithRequest:self->requestBody completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * error) {
            NSHTTPURLResponse* respHttp = (NSHTTPURLResponse*) response;
         [ABSNetworking HTTPerrorLogger:respHttp service:[NSString stringWithFormat:@"%@", url] isDebug:YES];
            if (respHttp.statusCode != SUCCESS) {
                errorHandler(nil, error);
                return;
            }
            
            /**
             * Check the API if responding JSON data
             */
            if ([NSJSONSerialization isValidJSONObject:body] && body != nil) {
                NSMutableDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:body options:NSJSONReadingAllowFragments error:&error];
                successHandler(nil, dictionary);
                //                    [[ABSLogger initialize] setMessage:[NSString stringWithFormat:@"@BIG-DATA EVENT: JSON is not valid - %@", error]];
            }else{
                // Trim the string format JSON data to replace special character and convert to dictionary.
                NSString* returnedString = [[[[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"'" withString:@""]
                                             stringByReplacingOccurrencesOfString:@"\\" withString:@"" ]
                                            stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSCharacterSet *quoteCharset = [NSCharacterSet characterSetWithCharactersInString:@"\""];
                
                NSString *trimmedString = [returnedString stringByTrimmingCharactersInSet:quoteCharset];
                NSData *jsonData = [trimmedString dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
                if (!error) {
                    successHandler(nil, dictionary);
                }
            }
        }] resume];
        
    });
    
}
/*
 * Method: GET
 * This post method is used for retrieving a data with headers from server through NSURLSession
 */
-(void) GET:(NSString *) url path:(NSString *) path headerParameters:(NSDictionary* ) headers success:(void (^)(NSURLSessionDataTask *  task, id responseObject)) successHandler errorHandler:(void (^)(NSURLSessionDataTask *  task, NSError *  error)) errorHandler{

    for (id key in headers){
        id header = [headers objectForKey:key];
        [sessionConfiguration setHTTPAdditionalHeaders:@{key: header}];
    }
     NSURLSession *session = [NSURLSession sessionWithConfiguration: sessionConfiguration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", url,path]]];
    request.HTTPMethod = @"GET";

    [request setValue:[[[AttributeManager init] propertyinvariant] origin] forHTTPHeaderField:@"Origin"];
    
    __block NSURLSessionDataTask *datatask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse* respHttp = (NSHTTPURLResponse*) response;
       
        [ABSNetworking HTTPerrorLogger:respHttp service:[NSString stringWithFormat:@"%@%@", url,path] isDebug:YES];
        
        if (respHttp.statusCode != SUCCESS) {
            errorHandler(datatask, error);
            return;
        }
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        successHandler(datatask, dictionary);
    }];
    [datatask resume];
}

//- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
//{
//    NSLog(@"taw");
//    completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
//}
//
//-(void)connection:(NSURLSession *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
//    if ([[challenge protectionSpace] authenticationMethod] == NSURLAuthenticationMethodServerTrust) {
//        [[challenge sender] useCredential:[NSURLCredential credentialForTrust:[[challenge protectionSpace] serverTrust]] forAuthenticationChallenge:challenge];
//    }
//}
//
//-(void)connection:(NSURLSession *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
//    NSLog(@"tasw");
//}
    
  

@end
