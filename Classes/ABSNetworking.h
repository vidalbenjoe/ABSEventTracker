//
//  ABSNetworking.h
//  EventApp
//
//  Created by Benjoe Vidal on 01/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constant.h"
#import "AttributeManager.h"
typedef NS_ENUM(NSUInteger, HTTPStatus){
    SUCCESS                =    200,
    UNAUTHORIZE             =   401,
    BAD_REQUEST             =   400,
    NOT_FOUND               =   404,
    INTERNAL_SERVER_ERROR   =   500
    
};
@interface ABSNetworking : NSURLProtocol  <NSURLSessionDelegate, NSURLSessionDataDelegate>{
    
@private NSMutableData* _receivedData;
}
@property(nonatomic) NSMutableURLRequest *requestBody;

+(instancetype) initWithSessionConfiguration:(NSURLSessionConfiguration *) config;
-(void) POST:(NSURL *) url parameters:(NSDictionary *) params success:(void (^)(NSURLSessionDataTask * task, id  responseObject)) successHandler errorHandler:(void (^)(NSURLSessionDataTask *  task, NSError * error)) errorHandler;

-(void) POST:(NSURL *) url URLparameters:(NSString *) parameters success:(void (^)(NSURLSessionDataTask *  task, id   responseObject)) successHandler errorHandler:(void (^)(NSURLSessionDataTask *  task, NSError *  error)) errorHandler;

-(void) POST:(NSURL *) url URLparameters:(NSString *) parameters headerParameters:(NSDictionary* ) headers success:(void (^)(NSURLSessionDataTask *  task, id   responseObject)) successHandler errorHandler:(void (^)(NSURLSessionDataTask *  task, NSError *  error)) errorHandler;

-(void) GET:(NSString *) url path:(NSString *) path headerParameters:(NSDictionary* ) headers success:(void (^)(NSURLSessionDataTask *  task, id   responseObject)) successHandler errorHandler:(void (^)(NSURLSessionDataTask *  task, NSError *  error)) errorHandler;


@end
