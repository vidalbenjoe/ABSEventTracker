//
//  ABSNetworking+HTTPErrorHandler.m
//  EventApp
//
//  Created by Benjoe Vidal on 15/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "ABSNetworking+HTTPErrorHandler.h"

@implementation ABSNetworking (HTTPErrorHandler)

+(void) HTTPerrorLogger: (NSHTTPURLResponse *) respHttp{
    
    if (respHttp.statusCode == UNAUTHORIZE) {
        NSLog(@"Event Library-HTTP_STATUS 401: UNAUTHORIZE");
    }else if (respHttp.statusCode== BAD_REQUEST) {
        NSLog(@"Event Library-HTTP_STATUS 400: BAD_REQUET");
    }else if (respHttp.statusCode == INTERNAL_SERVER_ERROR) {
        NSLog(@"Event Library-HTTP_STATUS 500: INTERNAL SERVER ERROR");
    }else if (respHttp.statusCode== NOT_FOUND) {
        NSLog(@"Event Library-HTTP_STATUS 404: NOT FOUND");
    }else{
        
    }
}


@end
