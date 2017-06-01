//
//  Constants.m
//  EventApp
//
//  Created by Benjoe Vidal on 01/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "Constants.h"

@implementation Constants

NSString* const eventAppsBaseURL        = @"http://indraeventsapi.azurewebsites.net";
NSString* const eventTokenURL           = @"/token";
NSString* const eventWriteURL           = @"/api/event/write";
NSString* const eventMobileResourceURL  = @"/api/event/mobiledatasource";

NSInteger const UNAUTHORIZE = 401;
NSInteger const INTERNAL_SERVER_ERROR = 500;
NSInteger const BAD_REQUEST = 400;
NSInteger const NOT_FOUND = 404;


@end
