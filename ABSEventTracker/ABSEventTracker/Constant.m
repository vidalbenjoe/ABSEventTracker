//
//  Constants.m
//  EventApp
//
//  Created by Benjoe Vidal on 01/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "Constant.h"
#import "PropertyEventSource.h"
@implementation Constant

NSString* const eventAppsBaseURL        = @"https://eventsapi.bigdata.abs-cbn.com";
NSString* const eventTokenURL           = @"/oauth";
NSString* const eventWriteURL           = @"/event";

NSString* const recommendationPopular           = @"/api/recommendation/popular";    //GET
NSString* const recommendationUserToItem        = @"/api/recommendation/usertoitemtest"; //POST
NSString* const recommendationItemToItem        = @"/api/recommendation/itemtoitemtest"; //POST
NSString* const recommendationCommunityToItem   = @"/api/recommendation/communitytoitemtest"; //POST
NSString* const host   = @"http://indraeventsapi.azurewebsites.net"; //POST

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
