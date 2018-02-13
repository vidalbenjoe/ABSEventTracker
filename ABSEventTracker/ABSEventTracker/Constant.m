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

NSString* const eventAppsBaseURL                    = @"https://eventsapi.bigdata.abs-cbn.com";
NSString* const eventTokenURL                       = @"/token";
NSString* const eventWriteURL                       = @"/write";

//NSString* const eventAppsBaseURL                = @"https://indraeventsapi.azurewebsites.net"; // Event Prod
NSString *const eventPreProd                    = @"http://stgeventswebapi.azurewebsites.net";
//NSString* const tokenURL                        = @"/token";
//NSString* const eventTokenURL                   = @"/oauth";
//NSString* const eventWriteURL                   = @"/api/event/write";
NSString* const eventMobileResourceURL          = @"/api/event/mobiledatasource";
NSString* const UserToItemURL                   = @"http://recoengapi.bigdata.abs-cbn.com/usertoitem"; //POST
NSString* const ItemToItemURL                   = @"http://recoengapi.bigdata.abs-cbn.com/itemtoitem"; //POST
NSString* const recommendationCommunityToItem   = @"/api/recommendation/communitytoitemtest"; //POST
NSString* const host                            = @"http://www.iwantv.com.ph"; //POST
// Staging host URL
NSString* const TFCHostStagingURL               = @"uatgnsok.tfc.tv";
NSString* const NEWSHostStagingURL              = @"stagingnews.abs-cbn.com";
NSString* const IWANTVHostStagingURL            = @"http://bigdata.iwantv.com.ph";
NSString* const SODHostStagingURL               = @"ppportal.skyondemand.com.ph";
NSString* const ONEOTTHostStagingURL            = @"bigdata.oneott.com.ph";

// Production host URL
NSString* const TFCHostProdURL                  = @"tfc.tv";
NSString* const NEWSHostProdURL                 = @"news.abs-cbn.com";
NSString* const IWANTVHostProdURL               = @"iwantv.com.ph";
NSString* const SODHostProdURL                  = @"skyondemand.com.ph";
NSString* const ONEOTTHostProdURL               = @"oneott.com.ph";

+(NSString *) generateNewMobileHeader
{
    // GET bundleIdentifier
//    NSString *bundleIdentifier = [NSString stringWithFormat:@"{\"packageName\":\"%@\"}", TESTER_ID];
    NSString *bundleIdentifier = [NSString stringWithFormat:@"{\"packageName\":\"%@\"}", [PropertyEventSource getBundleIdentifier]];
    
    NSData* data = [bundleIdentifier dataUsingEncoding:NSUTF8StringEncoding];
    // Get NSString from NSData object in Base64
    NSString *base64Encoded = [data base64EncodedStringWithOptions:0];
    return base64Encoded;
}
@end
