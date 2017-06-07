//
//  ABSNetworking.h
//  EventApp
//
//  Created by Benjoe Vidal on 01/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "AttributeManager.h"
@interface ABSNetworking : NSURLProtocol  <NSURLSessionDelegate, NSURLSessionDataDelegate>{
@private
    NSMutableData* _receivedData;
}
@property(nonatomic) NSMutableURLRequest *requestBody;
+(instancetype) initWithSessionConfiguration:(NSURLSessionConfiguration *) config;
-(void) POST:(NSURL *) url parameters:(NSDictionary *) params success:(void (^)(NSURLSessionDataTask * task, id  responseObject)) successHandler errorHandler:(void (^)(NSURLSessionDataTask *  task, NSError * error)) errorHandler;

-(void) POST:(NSURL *) url URLparameters:(NSString *) parameters success:(void (^)(NSURLSessionDataTask *  task, id   responseObject)) successHandler errorHandler:(void (^)(NSURLSessionDataTask *  task, NSError *  error)) errorHandler;

-(void) GET:(NSString *) url path:(NSString *) path headerParameters:(NSDictionary* ) headers success:(void (^)(NSURLSessionDataTask *  task, id   responseObject)) successHandler errorHandler:(void (^)(NSURLSessionDataTask *  task, NSError *  error)) errorHandler;

@end
