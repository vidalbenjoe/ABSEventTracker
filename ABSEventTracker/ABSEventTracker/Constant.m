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

NSString* const eventAppsBaseURL        = @"http://10.180.10.52:8085"; // Event
NSString* const recoURL        = @"http://10.180.10.52:8088";
NSString* const eventTokenURL           = @"/oauth";
NSString* const eventWriteURL           = @"/event";

NSString* const recommendationPopular           = @"/api/recommendation/popular";    //GET
NSString* const recommendationUserToItem        = @"/api/recommendation/usertoitemtest"; //POST
NSString* const recommendationItemToItem        = @"/api/recommendation/itemtoitemtest"; //POST
NSString* const recommendationCommunityToItem   = @"/api/recommendation/communitytoitemtest"; //POST
NSString* const host                            = @"http://www.iwantv.com.ph"; //POST


//{"host":"indraeventsapi.azurewebsites.net"},
//{"host":"www.skyondemand.com.ph"},
//{"host":"www.onemusic.ph"},
//{"host":"www.iwantv.com.ph"},
//{"host":"noink.abs-cbn.com"},
//{"host":"starcinema.abs-cbn.com"},
//{"host":"news.abs-cbn.com"},
//{"host":"testportal.skyondemand.com.ph"},
//{"host":"test-sinehub.abs-cbn.com"},
//{"host":"gwt.tfc.tv"},
//{"host":"uatgnsok.tfc.tv"},
//{"host":"test-starcinema.abs-cbn.com"},
//{"host":"staging.entertainment.abs-cbn.com"},
//{"host":"bigdata.iwantv.com.ph"},
//{"host":"test-starcinema.abs-cbn.com"},
//{"host":"stagingnews.abs-cbn.com"},
//{"host":"bigdata.onemusic.ph"},
//{"host":"staging-dev2.abs-cbn.com"}

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
