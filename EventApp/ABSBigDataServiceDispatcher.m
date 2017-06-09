//
//  ABSBigDataServiceDispatcher.m
//  EventApp
//
//  Created by Benjoe Vidal on 07/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//  Act as a bridge to API Call ABSNetworking

#import "ABSBigDataServiceDispatcher.h"
#import "Constants.h"
#import "ABSNetworking.h"
#import "AuthManager.h"

@implementation ABSBigDataServiceDispatcher

+(NSString *) generateNewMobileHeader{
    // GET bundleIdentifier
    NSString *bundleIdentifier = [NSString stringWithFormat:@"{\"packageName\" : \"%@\"}", I_WANT_TV_ID];
    NSData* data = [bundleIdentifier dataUsingEncoding:NSUTF8StringEncoding];
    // Get NSString from NSData object in Base64
    NSString *base64Encoded = [data base64EncodedStringWithOptions:0];
    NSLog(@"mobileHeader: %@", base64Encoded);
    return base64Encoded;
}

+(void) requestSecurityHashViaHttp: (void (^)(NSString *sechash))handler{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSDictionary *header = @{@"x-mobile-header" : [self generateNewMobileHeader]};
        [networking GET:eventAppsBaseURL path:eventMobileResourceURL headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
            NSString *sechash = responseObject[@"seccode"];
            handler(sechash);
        } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    });
}

+(void) requestToken: (void (^)(NSString *token))handler{
    NSString *localSecHash = [AuthManager retrieveSecurityHashFromUserDefault];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    dispatch_async(queue, ^{
        [[networking requestBody] setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        // REQUEST TOKEN
        NSString *post = [NSString stringWithFormat:@"targetcode=%@&grant_type=password",localSecHash];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", eventAppsBaseURL,eventTokenURL]];
        [networking POST:url URLparameters:post success:^(NSURLSessionDataTask *task, id responseObject) {
            // store the token somewhere
            NSString *token = responseObject[@"access_token"];
            NSLog(@"tuken: %@", token);
            NSLog(@"responseObject: %@", responseObject);
            [AuthManager storeTokenToUserDefault:token];
        } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                [self requestSecurityHashViaHttp:^(NSString *sechash) {
                    [AuthManager storeSecurityHashTouserDefault:sechash];
                }];
        }];
    });
}

+(void) dispatchAttribute:(AttributeManager *) attributes{
//    NSString *post = [NSString stringWithFormat:@"fingerprintID=%@&SiteDomain=%@",attributes.eventattributes.clickedContent,attributes.eventattributes.articleAuthor];
    
    NSDictionary *attributesw = @{@"fingerprintID"          : attributes.eventattributes.clickedContent,
                                 @"SiteDomain"              : attributes.deviceinvariant.deviceOS,
                                 @"DeviceOS"                : attributes.deviceinvariant.deviceOS,
                                 @"ScreenSize"              : @"",
                                 @"DeviceType"              : @"",
                                 @"PageURL"                 : @"",
                                 @"PageAccessTimeStamp"     : @"",
                                 @"AbandonTimeStamp"        : @"",
                                 @"WritingEventTimestamp"   : @"",
                                 @"LogoutTimeStamp"         : @"",
                                 @"BigDataSessionID"        : @"",
                                 @"SessionStartTimestamp"   : @"",
                                 @"SessionEndTimestamp"     : @"",
                                 @"SearchTimeStamp"         : @"",
                                 @"FirstName"               : @"",
                                 @"MiddleName"              : @"",
                                 @"LastName"                : @"",
                                 @"GigyaID"                 : @"",
                                 @"ClickedContent"          : @"",
                                 @"Longitude"               : @"",
                                 @"Latitude"                : @"",
                                 @"QueryString"             : @"",
                                 @"ActionTaken"             : @"",
                                 @"ReadArticle"             : @"",
                                 @"ReadingDuration"         : @"",
                                 @"ArticleAuthor"           : @"",
                                 @"ArticlePostDate"         : @"",
                                 @"CommentContent"          : @"",
                                 @"ArticleContentAmount"    : @"",
                                 @"LoginTimeStamp"          : @"",
                                 @"LikedContent"            : @"",
                                 @"ShareRetweetContent"     : @"",
                                 @"FollowedEntity"          : @"",
                                 @"Rating"                  : @"",
                                 @"PageMetaTags"            : @"",
                                 @"PreviousWebpage"         : @"",
                                 @"LinkDestination"         : @"",};
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", eventAppsBaseURL,eventWriteURL]];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
       ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    dispatch_async(queue, ^{
      
        NSMutableString *resultString = [NSMutableString string];
        for (NSString* key in [attributesw allKeys]){
            if ([resultString length]>0)
                [resultString appendString:@"&"];
            [resultString appendFormat:@"%@=%@", key, [attributesw objectForKey:key]];
        }
        
        NSDictionary *header = @{@"authorization" : [NSString stringWithFormat:@"bearer %@", [AuthManager retrieveServerTokenFromUserDefault]]};
        [networking POST:url URLparameters:resultString headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"postrespodwnseObject: %@", responseObject);
        } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
            [self requestToken:^(NSString *token) {
                
            }];
        }];
    
    });
}


@end
