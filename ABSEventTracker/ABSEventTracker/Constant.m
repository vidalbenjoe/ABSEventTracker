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

//production -  https://eventsapi.bigdata.abs-cbn.com
//staging - https://bigdataeventsapipreprod.southeastasia.cloudapp.azure.com

NSString *const urlStaging                      = @"http://indraeventsapi.azurewebsites.net";
NSString *const urlProd                         = @"https://pre-prodeventsapi.azurewebsites.net";
NSString *const urlPreProd                      = @"";

NSString* const eventMobileResourceURL          = @"/api/event/mobiledatasource";
NSString* const eventTokenURL                   = @"/token";
NSString* const eventWriteURL                   = @"/api/event/send";


NSString* const recoURL                         = @"https://recoengineapidev.azurewebsites.net";

NSString* const recoMobileResourceURL          = @"/api/recommendation/datasource";
NSString* const recoTokenURL                    = @"/token";
NSString* const UserToItemURL                   = @"/api/recommendation/usertoitem"; //POST
NSString* const ItemToItemURL                   = @"/api/recommendation/itemtoitem"; //POST
NSString* const recommendationCommunityToItem   = @"/api/recommendation/communitytoitem"; //POST

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
    return base64Encoded;
}
@end
