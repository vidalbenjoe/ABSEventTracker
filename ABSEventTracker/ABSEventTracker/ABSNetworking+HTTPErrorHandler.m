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

#pragma mark - Token
+(void) onTokenRefresh{
    [ABSBigDataServiceDispatcher requestToken:^(NSString *token) {
        [AuthManager storeTokenToUserDefault:token];
    }];
}

#pragma mark - Security Hash
+(void) onSecurityCodeRefresh{
    [ABSBigDataServiceDispatcher requestSecurityHashViaHttp:^(NSString *sechash) {
        [AuthManager storeSecurityHashTouserDefault:sechash];
    }];
}

@end
