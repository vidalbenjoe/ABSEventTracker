//
//  Constants.m
//  EventApp
//
//  Created by Benjoe Vidal on 01/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "Constant.h"

@implementation Constant

NSString* const eventAppsBaseURL        = @"http://indraeventsapi.azurewebsites.net";
NSString* const eventTokenURL           = @"/token";
NSString* const eventWriteURL           = @"/api/event/write";
NSString* const eventMobileResourceURL  = @"/api/event/mobiledatasource";

+(NSString *) generateNewMobileHeader{
    // GET bundleIdentifier
    NSString *bundleIdentifier = [NSString stringWithFormat:@"{\"packageName\" : \"%@\"}", I_WANT_TV_ID];
    NSData* data = [bundleIdentifier dataUsingEncoding:NSUTF8StringEncoding];
    // Get NSString from NSData object in Base64
    NSString *base64Encoded = [data base64EncodedStringWithOptions:0];
    NSLog(@"mobileHeader: %@", base64Encoded);
    return base64Encoded;
}
@end
