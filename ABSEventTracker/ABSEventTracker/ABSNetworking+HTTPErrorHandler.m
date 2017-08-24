//
//  ABSNetworking+HTTPErrorHandler.m
//  EventApp
//
//  Created by Benjoe Vidal on 15/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "ABSNetworking+HTTPErrorHandler.h"
#import "AuthManager.h"
#import "ABSLogger.h"
#pragma mark - HTTPerrorLogger
@implementation ABSNetworking (HTTPErrorHandler)
+(void) HTTPerrorLogger: (NSHTTPURLResponse *) respHttp service:(NSString *) request{
    
    NSLog(@"HTTP-STATUS : %ld - SERVICE: %@", (long)respHttp.statusCode, request);
    if (respHttp.statusCode == UNAUTHORIZE) {
        [[ABSLogger initialize] setMessage:@"UNAUTHORIZE"];
        [self onTokenRefresh];
    }else if (respHttp.statusCode== BAD_REQUEST) {
        [[ABSLogger initialize] setMessage:@"BAD REQUEST"];
    }else if (respHttp.statusCode == INTERNAL_SERVER_ERROR) {
         [[ABSLogger initialize] setMessage:@"INTERNAL SERVER ERROR"];
    }else if (respHttp.statusCode == NOT_FOUND) {
        [[ABSLogger initialize] setMessage:@"SERVER NOT FOUND"];
    }else if(respHttp.statusCode == PERMISSION_DENIED){
        [self onTokenRefresh];
    }
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
@end
