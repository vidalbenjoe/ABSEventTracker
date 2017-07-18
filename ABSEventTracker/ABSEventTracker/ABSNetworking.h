//
//  ABSNetworking.h
//  EventApp
//
//  Created by Benjoe Vidal on 01/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AttributeManager.h"
#import "Constant.h"

// HTTP STATUS CODE
typedef NS_ENUM(NSUInteger, HTTPStatus){
    SUCCESS                =    200,
    UNAUTHORIZE             =   401,
    BAD_REQUEST             =   400,
    PERMISSION_DENIED       =   403,
    NOT_FOUND               =   404,
    INTERNAL_SERVER_ERROR   =   500
};

@interface ABSNetworking : NSURLProtocol  <NSURLSessionDelegate, NSURLSessionDataDelegate>{
@private NSMutableData* _receivedData;
}

@property(nonatomic) NSMutableURLRequest *requestBody;
/*!
 * This method will initialize the ABSNetworking instance with session configuration
 *
 */
+(instancetype) initWithSessionConfiguration:(NSURLSessionConfiguration *) config;

/*!
 * This method will send dictionary object into server and will return server response into blocks handler
 * @params
 * url
 * params
 * successHandler
 * errorHandler
 * Server response code: 
 * 200 - SUCCESS
 * 401 - UNAUTHORIZE
 * 400 - BAD REQUEST
 * 404 - NOT FOUND
 * 500 - INTERNL SERVER ERROR
 */

-(void) POST:(NSURL *) url parameters:(NSDictionary *) params success:(void (^)(NSURLSessionDataTask * task, id  responseObject)) successHandler errorHandler:(void (^)(NSURLSessionDataTask *  task, NSError * error)) errorHandler;
/*!
 * This method will send string parameters into server and will return server response into blocks handler
 * @params
 * url
 * params
 * successHandler
 * errorHandler
 * Server response code:
 * 200 - SUCCESS
 * 401 - UNAUTHORIZE
 * 400 - BAD REQUEST
 * 404 - NOT FOUND
 * 500 - INTERNL SERVER ERROR
 */

-(void) POST:(NSURL *) url URLparameters:(NSString *) parameters success:(void (^)(NSURLSessionDataTask *  task, id   responseObject)) successHandler errorHandler:(void (^)(NSURLSessionDataTask *  task, NSError *  error)) errorHandler;
/*!
 * This method will send string parameters with headers into server and will return server response into blocks handler
 * @params
 * url
 * params
 * headers
 * successHandler
 * errorHandler
 * Server response code:
 * 200 - SUCCESS
 * 401 - UNAUTHORIZE
 * 400 - BAD REQUEST
 * 404 - NOT FOUND
 * 500 - INTERNL SERVER ERROR
 */
-(void) POST:(NSURL *) url URLparameters:(NSString *) parameters headerParameters:(NSDictionary* ) headers success:(void (^)(NSURLSessionDataTask *  task, id   responseObject)) successHandler errorHandler:(void (^)(NSURLSessionDataTask *  task, NSError *  error)) errorHandler;

/*!
 * This method will send http body raw data with headers into the server and will return server response into blocks handler
 * @params
 * url
 * httpBody
 * headers
 * successHandler
 * errorHandler
 * Server response code:
 * 200 - SUCCESS
 * 401 - UNAUTHORIZE
 * 400 - BAD REQUEST
 * 404 - NOT FOUND
 * 500 - INTERNL SERVER ERROR
 */

-(void) POST:(NSURL *) url HTTPBody:(NSData *) body headerParameters:(NSDictionary* ) headers success:(void (^)(NSURLSessionDataTask *  task, id   responseObject)) successHandler errorHandler:(void (^)(NSURLSessionDataTask *  task, NSError *  error)) errorHandler;

/*!
 * This method will get data from server and will return server response into blocks handler
 * @params
 * url
 * path
 * headers
 * successHandler
 * errorHandler
 * Server response code:
 * 200 - SUCCESS
 * 401 - UNAUTHORIZE
 * 400 - BAD REQUEST
 * 404 - NOT FOUND
 * 500 - INTERNL SERVER ERROR
 */

-(void) GET:(NSString *) url path:(NSString *) path headerParameters:(NSDictionary* ) headers success:(void (^)(NSURLSessionDataTask *  task, id   responseObject)) successHandler errorHandler:(void (^)(NSURLSessionDataTask *  task, NSError *  error)) errorHandler;


@end
