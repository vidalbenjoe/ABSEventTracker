//
//  ABSNetworking+HTTPErrorHandler.m
//  EventApp
//
//  Created by Benjoe Vidal on 15/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "ABSNetworking+HTTPErrorHandler.h"
#import "AuthManager.h"

#pragma mark - HTTPerrorLogger

@implementation ABSNetworking (HTTPErrorHandler)

+(void) HTTPerrorLogger: (NSHTTPURLResponse *) respHttp{
    if (respHttp.statusCode == UNAUTHORIZE) {
        [self onTokenRefresh];
    }else if (respHttp.statusCode== BAD_REQUEST) {
    }else if (respHttp.statusCode == INTERNAL_SERVER_ERROR) {
    }else if (respHttp.statusCode == INTERNAL_SERVER_ERROR ||
              respHttp.statusCode== BAD_REQUEST) {
        [self onSecurityCodeRefresh];
    }else if (respHttp.statusCode== NOT_FOUND) {}
}

/*************************HTTP CALLBACK*****************************/
#pragma mark - Token
/*! 
 *This method will refresh token once the server response received HTTP error code 401
 */
+(void) onTokenRefresh{
    [ABSBigDataServiceDispatcher requestToken:^(NSString *token) {
        [AuthManager storeTokenToUserDefault:token];
    }];
}
/*!
 *This method will refresh security hash once the server response 
 * received HTTP error code 400 or 500
 */
#pragma mark - Security Hash
+(void) onSecurityCodeRefresh{
    [ABSBigDataServiceDispatcher requestSecurityHashViaHttp:^(NSString *sechash) {
        [AuthManager storeSecurityHashTouserDefault:sechash];
    }];
}

@end
