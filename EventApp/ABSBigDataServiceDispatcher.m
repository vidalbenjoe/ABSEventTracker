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
#import "CacheManager.h"
#import "DeviceFingerprinting.h"

@implementation ABSBigDataServiceDispatcher

+(void) requestSecurityHashViaHttp: (void (^)(NSString *sechash))handler{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSDictionary *header = @{@"x-mobile-header" : [Constants generateNewMobileHeader]};
        [networking GET:eventAppsBaseURL path:eventMobileResourceURL headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
            NSString *sechash = responseObject[@"seccode"];
            handler(sechash);
        } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(SECHASH_ERROR_REQUEST);
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
            [AuthManager storeTokenToUserDefault:token];
        } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                [self requestSecurityHashViaHttp:^(NSString *sechash) {
                    [AuthManager storeSecurityHashTouserDefault:sechash];
                }];
        }];
    });
}

+(void) dispatchAttribute:(AttributeManager *) attributes{
    NSMutableDictionary *attributesDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            ObjectOrNull([DeviceFingerprinting generateDeviceFingerprint]) , @"fingerprintID",
            ObjectOrNull(attributes.propertyinvariant.applicationName) , @"SiteDomain",
            ObjectOrNull(attributes.deviceinvariant.deviceOS) , @"DeviceOS",
            [NSString stringWithFormat:@"%fx%f", attributes.deviceinvariant.deviceScreenWidth, attributes.deviceinvariant.deviceScreenHeight]  , @"ScreenSize",
            ObjectOrNull(attributes.deviceinvariant.deviceType) , @"DeviceType",
            ObjectOrNull(attributes.propertyinvariant.bundleIdentifier) , @"PageURL",
            ObjectOrNull(attributes.arbitaryinvariant.applicationLaunchTimeStamp) , @"PageAccessTimeStamp",
            ObjectOrNull(attributes.arbitaryinvariant.applicationAbandonTimeStamp) , @"AbandonTimeStamp",
            ObjectOrNull(attributes.arbitaryinvariant.postCommentTimeStamp) , @"WritingEventTimestamp",
            ObjectOrNull(attributes.arbitaryinvariant.logoutTimeStamp) , @"LogoutTimeStamp",
            ObjectOrNull(attributes.arbitaryinvariant.searchTimeStamp) , @"SearchTimeStamp",
            @"domain" , @"BigDataSessionID",
            ObjectOrNull(attributes.session.sessionStart) , @"SessionStartTimestamp",
            ObjectOrNull(attributes.session.sessionEnd) , @"SessionEndTimestamp",
            ObjectOrNull(attributes.userattributes.firstName) , @"FirstName",
            ObjectOrNull(attributes.userattributes.middleName) , @"MiddleName",
            ObjectOrNull(attributes.userattributes.lastName) , @"LastName",
            ObjectOrNull(attributes.userattributes.gigyaID) , @"GigyaID",
            ObjectOrNull(attributes.eventattributes.clickedContent) , @"ClickedContent",
            ObjectOrNull([NSString stringWithFormat:@"%@", [NSNumber numberWithFloat:attributes.eventattributes.longitude]]), @"Longitude",
            ObjectOrNull([NSString stringWithFormat:@"%@", [NSNumber numberWithFloat:attributes.eventattributes.latitute]]) , @"Latitude",
            ObjectOrNull(attributes.eventattributes.searchQuery) , @"QueryString",
             ObjectOrNull([NSNumber numberWithInt:attributes.eventattributes.actionTaken]) , @"ActionTaken",
            ObjectOrNull(attributes.eventattributes.readArticles) , @"ReadArticle",
            ObjectOrNull([NSNumber numberWithInt:attributes.eventattributes.duration]) , @"ReadingDuration",
            ObjectOrNull(attributes.eventattributes.articleAuthor) , @"ArticleAuthor",
            ObjectOrNull(attributes.eventattributes.articlePostDate) , @"ArticlePostDate",
            ObjectOrNull(attributes.eventattributes.commentContent) , @"CommentContent",
                                                 ObjectOrNull([NSNumber numberWithInt:attributes.eventattributes.articleCharacterCount]), @"ArticleContentAmount",
            ObjectOrNull(attributes.eventattributes.loginTimeStamp) , @"LoginTimeStamp",
            ObjectOrNull(attributes.eventattributes.likedContent) , @"LikedContent",
            ObjectOrNull(attributes.eventattributes.shareRetweetContent) , @"ShareRetweetContent",
            ObjectOrNull(attributes.eventattributes.followEntity) , @"FollowedEntity",
             ObjectOrNull([NSNumber numberWithInt:attributes.eventattributes.rating]) , @"Rating",
            ObjectOrNull(attributes.eventattributes.metaTags) , @"PageMetaTags",
            ObjectOrNull(attributes.eventattributes.previousScreen) , @"PreviousWebpage",
            ObjectOrNull(attributes.eventattributes.screenDestination) , @"LinkDestination", nil];
    

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", eventAppsBaseURL,eventWriteURL]];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    dispatch_async(queue, ^{
        NSMutableString *resultString = [NSMutableString string];
        for (NSString* key in [attributesDictionary allKeys]){
            if ([resultString length]>0)
                [resultString appendString:@"&"];
                [resultString appendFormat:@"%@=%@", key, [attributesDictionary objectForKey:key]];
        }
        NSDictionary *header = @{@"authorization" : [NSString stringWithFormat:@"bearer %@", [AuthManager retrieveServerTokenFromUserDefault]]};
        [networking POST:url URLparameters:resultString headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"postrespodwnseObject: %@", responseObject);
        } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
            [CacheManager storeFailedAttributesToCacheManager:attributesDictionary];
            NSLog(@"failedRequestAttributes: %@", attributesDictionary);
        }];
    });
}

static id ObjectOrNull(id object){
    return object ?: @"";
}

-(void) onSuccess{
    
}

-(void) onFailure{
    
}

-(void) onTokenRefresh{
    
}

-(void) onSecurityCodeRefresh{
    
}


@end
