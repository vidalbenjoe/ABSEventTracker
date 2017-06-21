//
//  ABSNetworking+HTTPErrorHandler.h
//  EventApp
//
//  Created by Benjoe Vidal on 15/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "ABSNetworking.h"
#import "EventCallBack.h"
#import "ABSBigDataServiceDispatcher.h"
@interface ABSNetworking (HTTPErrorHandler)<EventCallBack>
+(void) HTTPerrorLogger: (NSHTTPURLResponse *) respHttp;

@end
