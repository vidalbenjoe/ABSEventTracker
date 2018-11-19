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

NSString *const urlStaging                      = @"https://bigdataeventsapistaging.azurewebsites.net";
NSString *const urlProd                         = @"https://pre-prodeventsapi.azurewebsites.net";

NSString* const eventMobileResourceURL          = @"/api/event/mobiledatasource";
NSString* const eventTokenURL                   = @"/token";
NSString* const eventWriteURL                   = @"/api/event/send";

NSString* const devRecoURL                      = @"https://recoengineapidev.azurewebsites.net";

NSString* const prodRecoURL                     = @"https://recoengapi.bigdata.abs-cbn.com";

NSString* const recoMobileResourceURL           = @"/api/recommendation/mobiledatasource";
NSString* const recoTokenURL                    = @"/token";
NSString* const UserToItemURL                   = @"/api/recommendation/usertoitem"; //POST
NSString* const ItemToItemURL                   = @"/api/recommendation/itemtoitem"; //POST
NSString* const recommendationCommunityToItem   = @"/api/recommendation/communitytoitem"; //POST

NSString* const recommendationGetItemToItem   = @"/api/recommendation/update?";


// Staging host URL
NSString* const TFCHostStagingURL               = @"uatgnsok.tfc.tv";
NSString* const NEWSHostStagingURL              = @"stagingnews.abs-cbn.com";
NSString* const IWANTVHostStagingURL            = @"bigdata.iwantv.com.ph";
NSString* const SODHostStagingURL               = @"ppportal.skyondemand.com.ph";
NSString* const ONEOTTHostStagingURL            = @"bigdata.oneott.com.ph";

// Production host URL
NSString* const TFCHostProdURL                  = @"tfc.tv";
NSString* const NEWSHostProdURL                 = @"news.abs-cbn.com";
NSString* const IWANTVHostProdURL               = @"iwantv.com.ph";
NSString* const SODHostProdURL                  = @"skyondemand.com.ph";
NSString* const ONEOTTHostProdURL               = @"oneott.com.ph";

// Origin URL Production
NSString* const TFCOriginURL                = @"https://com.abscbni.tfctv";
NSString* const NEWSOriginURL               = @"https://";
NSString* const IWANTVOriginURL             = @"https://com.abs-cbn.iwanttv";
NSString* const SODOriginURL                = @"https://com.mysky.ondemand";
NSString* const ONEOTTOriginURL             = @"https://com.abscbn.iwantNow";

+(NSString *) generateNewMobileHeader
{
    // GET bundleIdentifier
//    NSString *bundleIdentifier = [NSString stringWithFormat:@"{\"packageName\":\"%@\"}", TESTER_ID];
    NSString *bundleIdentifier = [NSString stringWithFormat:@"{\"packageName\":\"%@\"}", [PropertyEventSource getBundleIdentifier]];
    NSData* data = [bundleIdentifier dataUsingEncoding:NSUTF8StringEncoding];
    // Get NSString from NSData object in Base64
    NSString *base64Encoded = [data base64EncodedStringWithOptions:0];
//    NSLog(@"baseLcoded: %@", base64Encoded);
    return base64Encoded;
}
@end
