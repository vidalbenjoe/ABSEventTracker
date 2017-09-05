//
//  ABSNetworking+HTTPErrorHandler.h
//  EventApp
//
//  Created by Benjoe Vidal on 15/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "ABSNetworking.h"
#import "HTTPCallBack.h"
#import "ABSBigDataServiceDispatcher.h"
@interface ABSNetworking (HTTPErrorHandler)<HTTPCallBack>
+(void) HTTPerrorLogger: (NSHTTPURLResponse *) http service:(NSString *) request;
@end
