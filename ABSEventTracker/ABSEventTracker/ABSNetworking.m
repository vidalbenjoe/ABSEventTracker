//
//  ABSNetworking.m
//  Created by Benjoe Vidal on 01/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "ABSNetworking.h"
#import "EventAuthManager.h"
#import "AttributeManager.h"
#import "ABSBigDataServiceDispatcher.h"
#import "Constant.h"
#import "ABSLogger.h"

@implementation ABSNetworking
NSURLSessionConfiguration *sessionConfiguration;
bool isHTTPDebug;
//@synthesize requestBody;
+(instancetype) initWithSessionConfiguration:(NSURLSessionConfiguration *) config enableHTTPLog:(BOOL) isEnableHTTPLog{
    static ABSNetworking *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[super alloc] init];
        sessionConfiguration = config;
        isHTTPDebug = isEnableHTTPLog;
    });
    return shared;
}

/* This method will send string parameters into server and will return server response into blocks handler
 */
-(void) POST:(NSURL *) url URLparameters:(NSString *) parameters success:(void (^)(NSURLSessionDataTask *  task, id   responseObject)) successHandler errorHandler:(void (^)(NSURLSessionDataTask *  task, NSError *  error)) errorHandler{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSMutableURLRequest *requestBody = [[NSMutableURLRequest alloc]
                                        initWithURL:url
                                        cachePolicy: NSURLRequestReloadRevalidatingCacheData
                                        timeoutInterval:200.0];
    [requestBody setHTTPMethod:@"POST"];
    [requestBody setHTTPBody:[NSData dataWithBytes:
                              [parameters UTF8String]length:strlen([parameters UTF8String])]];
    [requestBody setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration: sessionConfiguration];
      dispatch_async(queue, ^{
          [[session dataTaskWithRequest:requestBody completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      NSHTTPURLResponse* respHttp = (NSHTTPURLResponse*) response;
                                        // Logging token
//                                      [self HTTPerrorLogger:respHttp service:[NSString stringWithFormat:@"%@", url] HTTPBody: parameters isDebug:isHTTPDebug];
                                      
                                      if (respHttp.statusCode != SUCCESS) {
                                          errorHandler(nil, error);
                                          return;
                                      }
                                      
                                      if(data != nil){
                                          NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                          successHandler(nil, dictionary);
                                      }else{
                                          errorHandler(nil, error);
                                           return;
                                      }
                                      
                                   }] resume];
      });
}

-(void) POST:(NSURL *) url URLparameters:(NSString *) parameters headerParameters:(NSDictionary* ) headers success:(void (^)(NSURLSessionDataTask *  task, id   responseObject)) successHandler errorHandler:(void (^)(NSURLSessionDataTask *  task, NSError *  error)) errorHandler{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (id key in headers){
        id token = [headers objectForKey:key];
        [sessionConfiguration setHTTPAdditionalHeaders:@{key: token}];
    }
    sessionConfiguration.URLCache = [NSURLCache sharedURLCache];
    NSMutableURLRequest *requestBody = [[NSMutableURLRequest alloc]
                                        initWithURL:url
                                        cachePolicy: NSURLRequestReloadRevalidatingCacheData
                                        timeoutInterval:200.0];
    
    [requestBody setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [requestBody setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestBody setValue:[[[AttributeManager init] propertyinvariant] siteDomain] forHTTPHeaderField:@"SiteDomain"];
    [requestBody setHTTPMethod:@"POST"];
    [requestBody setHTTPBody:[NSData dataWithBytes:
                              [parameters UTF8String]length:strlen([parameters UTF8String])]];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration: sessionConfiguration delegate:self delegateQueue:nil];
    
    dispatch_async(queue, ^{
        [[session dataTaskWithRequest:requestBody completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * error) {
            NSHTTPURLResponse* respHttp = (NSHTTPURLResponse*) response;
            
//            [self HTTPerrorLogger:respHttp service:[NSString stringWithFormat:@"%@", url] HTTPBody:[NSString stringWithFormat:@"%@", parameters] isDebug:isHTTPDebug];
            
            if (respHttp.statusCode != SUCCESS) {
                errorHandler(nil, error);
                return;
            }
            
            if(data != nil){
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                successHandler(nil, dictionary);
                
            }else{
                errorHandler(nil, error);
                return;
            }
            
            
        }] resume];
    });
}


-(void) POST:(NSURL *) url JSONString:(NSString *) parameters headerParameters:(NSDictionary* ) headers success:(void (^)(NSURLSessionDataTask *  task, id   responseObject)) successHandler errorHandler:(void (^)(NSURLSessionDataTask *  task, NSError *  error)) errorHandler{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (id key in headers){
        id token = [headers objectForKey:key];
        [sessionConfiguration setHTTPAdditionalHeaders:@{key: token}];
    }
    sessionConfiguration.URLCache = [NSURLCache sharedURLCache];
    NSMutableURLRequest *requestBody = [[NSMutableURLRequest alloc]
                                        initWithURL:url
                                        cachePolicy: NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                        timeoutInterval:200.0];
    
    [requestBody setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
//    [requestBody setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestBody setValue:[[[AttributeManager init] propertyinvariant] siteDomain] forHTTPHeaderField:@"SiteDomain"];
    [requestBody setHTTPMethod:@"POST"];
    
//    NSString* JSONDataString = [[[[NSString alloc] initWithData:writerAttributes encoding:NSASCIIStringEncoding] stringByReplacingOccurrencesOfString:@"'" withString:@""]
//        stringByReplacingOccurrencesOfString:@"\\" withString:@""];

//    NSString* JSONDataString = [[[[NSString alloc] initWithString:parameters] stringByReplacingOccurrencesOfString:@"'" withString:@""]
//                                stringByReplacingOccurrencesOfString:@"\\" withString:@""];
//
//    NSCharacterSet *quoteCharset = [NSCharacterSet characterSetWithCharactersInString:@"\""];
//    NSString *trimmedString = [JSONDataString stringByTrimmingCharactersInSet:quoteCharset];
//    NSLog(@"loggingJSON: %@", [NSString stringWithFormat:@"\"%@\"", parameters]);
    [requestBody setHTTPBody:[[NSString stringWithFormat:@"\"%@\"", parameters] dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration: sessionConfiguration delegate:self delegateQueue:nil];
    dispatch_async(queue, ^{
        [[session dataTaskWithRequest:requestBody completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * error) {
            NSHTTPURLResponse* respHttp = (NSHTTPURLResponse*) response;
            if(data != nil){
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                NSString *ksomnda = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                [self HTTPerrorLogger:respHttp service:[NSString stringWithFormat:@"%@", url] HTTPBody:[NSString stringWithFormat:@"%@ Body %@",[respHttp allHeaderFields], ksomnda ] isDebug: isHTTPDebug];
                successHandler(nil, dictionary);
                
            }else{
                errorHandler(nil, error);
                return;
            }
            
            if (respHttp.statusCode != SUCCESS) {
                errorHandler(nil, error);
                return;
            }
            
            
        }] resume];
    });
}

/*
 * Method: POST
 * This post method is used for sending a request with query parameter along side with the URL with multiple header into server through NSURLSession
 */

-(void) POST:(NSURL *) url queryParams:(NSString *) parameters headerParameters:(NSDictionary* ) headers success:(void (^)(NSURLSessionDataTask *  task, id   responseObject)) successHandler errorHandler:(void (^)(NSURLSessionDataTask *  task, NSError *  error)) errorHandler{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (id key in headers){
        id token = [headers objectForKey:key];
        [sessionConfiguration setHTTPAdditionalHeaders:@{key: token}];
    }
    sessionConfiguration.URLCache = [NSURLCache sharedURLCache];
    NSMutableURLRequest *requestBody = [NSMutableURLRequest requestWithURL:url];
    
     [requestBody setValue:[[[AttributeManager init] propertyinvariant] siteDomain] forHTTPHeaderField:@"SiteDomain"];
     [requestBody setHTTPMethod:@"POST"];

    NSURLSession *session = [NSURLSession sessionWithConfiguration: sessionConfiguration delegate:self delegateQueue:nil];
    dispatch_async(queue, ^{
        [[session dataTaskWithRequest:requestBody completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * error) {
            NSHTTPURLResponse* respHttp = (NSHTTPURLResponse*) response;
            
            NSString *ksomnda = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [self HTTPerrorLogger:respHttp service:[NSString stringWithFormat:@"%@", url] HTTPBody:[NSString stringWithFormat:@"%@ Body %@",[respHttp allHeaderFields], ksomnda ] isDebug: isHTTPDebug];
            
            if (respHttp.statusCode != SUCCESS) {
                errorHandler(nil, error);
                return;
            }
            
            if(data != nil){
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                successHandler(nil, dictionary);
            }else{
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
    for (id key in headers){
        id value = [headers objectForKey:key];
        [sessionConfiguration setHTTPAdditionalHeaders:@{key: value}];
    }
        sessionConfiguration.URLCache = [NSURLCache sharedURLCache];
        NSMutableURLRequest *requestBody = [[NSMutableURLRequest alloc]
                                        initWithURL:url
                                        cachePolicy: NSURLRequestReloadRevalidatingCacheData
                                        timeoutInterval:200.0];
    
        [requestBody setHTTPMethod:@"POST"];
        [requestBody setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [requestBody setValue:[[[AttributeManager init] propertyinvariant] siteDomain]
           forHTTPHeaderField:@"SiteDomain"];
//        [requestBody setValue:[[[AttributeManager init] propertyinvariant] origin]
//           forHTTPHeaderField:@"Origin"];
        [requestBody setHTTPBody:body];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
    NSURLSession *session = [NSURLSession sessionWithConfiguration: sessionConfiguration delegate:self delegateQueue:nil];
    
        [[session dataTaskWithRequest:requestBody completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * error) {
            NSHTTPURLResponse* respHttp = (NSHTTPURLResponse*) response;
            /**
             * Checking the returned JSON
             */
            if ([NSJSONSerialization isValidJSONObject:body]) {
                NSMutableDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:body options:NSJSONReadingAllowFragments error:&error];
            
                [self HTTPerrorLogger:respHttp service:[NSString stringWithFormat:@"%@", url] HTTPBody:[NSString stringWithFormat:@"%@ Body %@",[respHttp allHeaderFields], dictionary ] isDebug: isHTTPDebug];
                
                if (respHttp.statusCode != SUCCESS) {
                    errorHandler(nil, error);
                    return;
                }else{
                     successHandler(nil, dictionary);
                    return;
                }
            }else{
                // Trim the string format JSON data to replace special character and convert to dictionary.
                NSString* returnedString = [[[[NSString alloc] initWithData:body encoding:NSASCIIStringEncoding] stringByReplacingOccurrencesOfString:@"'" withString:@""]
                                             stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                NSCharacterSet *quoteCharset = [NSCharacterSet characterSetWithCharactersInString:@"\""];
                NSString *trimmedString = [returnedString stringByTrimmingCharactersInSet:quoteCharset];
                NSData *jsonData = [trimmedString dataUsingEncoding:NSUTF8StringEncoding];
                
                 NSMutableDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:body options:NSJSONReadingAllowFragments error:&error];
                
                NSMutableArray *arrayOfDictionaries = [NSMutableArray array];
                [arrayOfDictionaries addObject:dictionary];
                
                 [self HTTPerrorLogger:respHttp service:[NSString stringWithFormat:@"%@", url] HTTPBody:[NSString stringWithFormat:@"%@ Body %@",[respHttp allHeaderFields], arrayOfDictionaries ] isDebug: isHTTPDebug];
               
                if(data != nil && !error){
                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
                    successHandler(nil, dictionary);
                }else{
                    errorHandler(nil, error);
                    return;
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
    [request setValue:[[[AttributeManager init] propertyinvariant] siteDomain] forHTTPHeaderField:@"SiteDomain"];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
    __block NSURLSessionDataTask *datatask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse* respHttp = (NSHTTPURLResponse*) response;
        if (respHttp.statusCode != SUCCESS) {
            errorHandler(datatask, error);
            [self HTTPerrorLogger:respHttp service:[NSString stringWithFormat:@"%@", url] HTTPBody:[NSString stringWithFormat:@"%@", headers] isDebug:isHTTPDebug];
            return;
        }
        if(data != nil && !error){
               NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
//            [self HTTPerrorLogger:respHttp service:[NSString stringWithFormat:@"%@", url] HTTPBody:[NSString stringWithFormat:@"%@", dictionary] isDebug:isHTTPDebug];
            
            successHandler(nil, dictionary);
            
        }else{
            errorHandler(nil, error);
            return;
        }
    }];
    [datatask resume];
    });
}

-(void) HTTPerrorLogger: (NSHTTPURLResponse *) http service:(NSString *) request HTTPBody:(NSString *) body isDebug:(BOOL) debug{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        if (debug == YES) {
            NSLog(@"BIG-DATA-STATUSCODE: %ld", (long) http.statusCode);
            NSLog(@"%@", [NSString stringWithFormat:@"ABS-CBN BIG DATA RESPONSE : %ld - SERVICE: %@ - HTTPHeaders: %@",(long) http.statusCode, request, body]);
        }
        
        if (http.statusCode == UNAUTHORIZE) {
            [[ABSLogger initialize] setMessage:@"UNAUTHORIZE"];
            [self onTokenRefresh];
        }else if (http.statusCode== BAD_REQUEST) {
            [[ABSLogger initialize] setMessage:@"BAD REQUEST"];
        }else if (http.statusCode == INTERNAL_SERVER_ERROR) {
            [[ABSLogger initialize] setMessage:@"INTERNAL SERVER ERROR"];
        }else if (http.statusCode == NOT_FOUND) {
            [[ABSLogger initialize] setMessage:@"SERVER NOT FOUND"];
        }else if(http.statusCode == PERMISSION_DENIED){
            [self onTokenRefresh];
        }
    });
    
}

/*************************HTTP CALLBACK*****************************/

#pragma mark - Token
/*!
 *This method will refresh token once the server response received HTTP error code 401
 */

-(void) onTokenRefresh{
    //TODO: Need to create separarate token refresh for Recommendation.
    //Double calling
    [ABSBigDataServiceDispatcher requestToken:^(NSString *token) {
        [EventAuthManager storeTokenToUserDefault:token];
    }];
}

@end
