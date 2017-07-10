//
//  ABSBigDataServiceDispatcher.m
//  EventApp
//
//  Created by Benjoe Vidal on 07/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//  Act as a bridge to API Call ABSNetworking

#import "ABSBigDataServiceDispatcher.h"
#import "Constant.h"
#import "HTTPCallBack.h"
#import "ABSNetworking.h"
#import "AuthManager.h"
#import "CacheManager.h"
#import "DeviceFingerprinting.h"
#import "FormatUtils.h"
#import "ABSCustomOperation.h"
#import "Popular.h"
@implementation ABSBigDataServiceDispatcher

+(void) requestSecurityHashViaHttp: (void (^)(NSString *sechash))handler{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSDictionary *header = @{@"x-mobile-header" : [Constant generateNewMobileHeader]};
        [networking GET:eventAppsBaseURL path:eventMobileResourceURL headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
            NSString *sechash = responseObject[@"seccode"];
            handler(sechash);
        } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(SECHASH_ERROR_REQUEST);
        }];
    });
}

+(void) requestToken: (void (^)(NSString *token))handler{
    [self requestSecurityHashViaHttp:^(NSString *sechash) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        dispatch_async(queue, ^{
            [[networking requestBody] setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            // REQUEST TOKEN
            NSString *post = [NSString stringWithFormat:@"targetcode=%@&grant_type=password",sechash];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", eventAppsBaseURL,eventTokenURL]];
            [networking POST:url URLparameters:post success:^(NSURLSessionDataTask *task, id responseObject) {
                // Store response token into AuthManager NSUserDefault
                NSString *token = responseObject[@"access_token"];
                [AuthManager storeTokenToUserDefault:token];
                handler(token);
                NSLog(@"authSuccs: %@ ", token);
            } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                [self requestSecurityHashViaHttp:^(NSString *sechash) {
                    [AuthManager storeSecurityHashTouserDefault:sechash];
                    NSLog(@"SECHASH: %@ ", sechash);
                }];
            }];
        });
    }];
    
}

+(void) dispatchAttribute:(AttributeManager *) attributes{
    NSMutableDictionary *writerAttributes = [self writerAttribute:attributes];
    [[NSNotificationCenter defaultCenter] postNotificationName:
     @"TestNotification" object:nil userInfo:writerAttributes];
    NSLog(@"mytokne: %@", [AuthManager retrieveServerTokenFromUserDefault]);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", eventAppsBaseURL,eventWriteURL]];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    dispatch_async(queue, ^{
        NSMutableString *resultString = [NSMutableString string];
        for (NSString* key in [writerAttributes allKeys]){
            if ([resultString length]>0)
                [resultString appendString:@"&"];
            [resultString appendFormat:@"%@=%@", key, [writerAttributes objectForKey:key]];
        }
        NSDictionary *header = @{@"authorization" : [NSString stringWithFormat:@"bearer %@", [AuthManager retrieveServerTokenFromUserDefault]]};
        
        [networking POST:url URLparameters:resultString headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"request response: %@", [responseObject description]);
        } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
            [CacheManager storeFailedAttributesToCacheManager:writerAttributes];
            NSLog(@"failedRequestAttributes: %@", writerAttributes);
        }];
    });
}

+(void) performQueueForCachedAttributes{
    if ([[CacheManager retrieveAllCacheArray] count] > 0) {
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        // Loop cached array and add to queue
        for (int i = 0; i < [CacheManager retrieveAllCacheArray].count ; i++) {
            // Add cached Array to attributes dictionary
            [attributes setObject:[[CacheManager retrieveAllCacheArray] objectAtIndex:i] forKey:@"attributes"];
            NSOperationQueue *operationQueue = [NSOperationQueue new];
            [operationQueue setMaxConcurrentOperationCount:5];
            ABSCustomOperation *customOperation = [[ABSCustomOperation alloc] initWithData:attributes];
            //You can pass any object in the initWithData method. Here we are passing a NSDictionary Object
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", eventAppsBaseURL,eventWriteURL]];
            ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            NSMutableString *resultString = [NSMutableString string];
            for (NSString* key in [attributes allKeys]){
                if ([resultString length]>0)
                    [resultString appendString:@"&"];
                [resultString appendFormat:@"%@=%@", key, [attributes objectForKey:key]];
            }
            NSDictionary *header = @{@"authorization" : [NSString stringWithFormat:@"bearer %@", [AuthManager retrieveServerTokenFromUserDefault]]};
            [networking POST:url URLparameters:resultString headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
                [CacheManager removeCachedAttributeByFirstIndex];
                NSLog(@"request response: %@", responseObject);
            } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                [CacheManager storeFailedAttributesToCacheManager:attributes];
            }];
            NSBlockOperation *blockCompletionOperation = [NSBlockOperation blockOperationWithBlock:^{
                //This is the completion block that will get called when the custom operation work is completed.
                // Work completed
            }];
            customOperation.completionBlock =^{
                NSLog(@"Completed");
                NSLog(@"CacheByIndex-complet: %lu",(unsigned long)[[CacheManager retrieveAllCacheArray] count]);
                NSLog(@"Operation Completion Block. Do something here. Probably alert the user that the work is complete");
                //This is another way of catching the Custom Operation completition.
                //In case you donot want to catch the completion using a block operation as state above. you can catch it here and remove the block operation and the dependency introduced in the next line of code
            };
            
            [blockCompletionOperation addDependency:customOperation];
            [operationQueue addOperation:customOperation];
//            [customOperation start];
            //Uncommenting this line of code will run the custom operation twice one using the NSOperationQueue and the other using the custom operations start method
        }
    }
}

+(void)dispatchCachedAttributes:(id)obj{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", eventAppsBaseURL,eventWriteURL]];
    ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableString *resultString = [NSMutableString string];
    for (NSString* key in [obj allKeys]){
        if ([resultString length]>0)
            [resultString appendString:@"&"];
        [resultString appendFormat:@"%@=%@", key, [obj objectForKey:key]];
    }
    NSDictionary *header = @{@"authorization" : [NSString stringWithFormat:@"bearer %@", [AuthManager retrieveServerTokenFromUserDefault]]};
    [networking POST:url URLparameters:resultString headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
        [CacheManager removeCachedAttributeByFirstIndex];
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        [CacheManager storeFailedAttributesToCacheManager:obj];
    }];
}

+(NSMutableDictionary *) writerAttribute:(AttributeManager *) attributes{
    NSString *action = [EventAttributes convertActionTaken:attributes.eventattributes.actionTaken];
    
    NSString *userID = ObjectOrNull(attributes.userattributes.gigyaID) ? ObjectOrNull(attributes.userattributes.ssoID) : attributes.userattributes.gigyaID;
    
    NSMutableDictionary *attributesDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            userID , @"GigyaID",
            ObjectOrNull([DeviceFingerprinting generateDeviceFingerprint]) , @"fingerprintID",
            ObjectOrNull(attributes.propertyinvariant.applicationName) , @"SiteDomain",
            ObjectOrNull(attributes.deviceinvariant.deviceOS) , @"DeviceOS",
            [NSString stringWithFormat:@"%fx%f", attributes.deviceinvariant.deviceScreenWidth, attributes.deviceinvariant.deviceScreenHeight]  , @"ScreenSize",
            ObjectOrNull(attributes.deviceinvariant.deviceType) , @"DeviceType",
            ObjectOrNull(attributes.propertyinvariant.bundleIdentifier) , @"PageURL",
            ObjectOrNull(attributes.arbitaryinvariant.applicationLaunchTimeStamp) , @"ApplicationLoadTimeStamp",
            ObjectOrNull(attributes.arbitaryinvariant.applicationAbandonTimeStamp) , @"ApplicationAbandonTimeStamp",
            ObjectOrNull(attributes.arbitaryinvariant.postCommentTimeStamp) , @"WritingEventTimestamp",
            ObjectOrNull(attributes.arbitaryinvariant.logoutTimeStamp) , @"LogoutTimeStamp",
            ObjectOrNull(attributes.arbitaryinvariant.searchTimeStamp) , @"SearchTimeStamp",
            ObjectOrNull([NSString stringWithFormat:@"%@",attributes.session.sessionID])  , @"BigDataSessionID",
            ObjectOrNull(attributes.session.sessionStart) , @"SessionStartTimestamp",
            ObjectOrNull(attributes.session.sessionEnd), @"SessionEndTimestamp",
            ObjectOrNull(attributes.userattributes.firstName) , @"FirstName",
            ObjectOrNull(attributes.userattributes.middleName) , @"MiddleName",
            ObjectOrNull(attributes.userattributes.lastName) , @"LastName",
            ObjectOrNull(attributes.eventattributes.clickedContent) , @"ClickedContent",
            ObjectOrNull([NSString stringWithFormat:@"%@", [NSNumber numberWithFloat:attributes.eventattributes.longitude]]), @"Longitude",
            ObjectOrNull([NSString stringWithFormat:@"%@", [NSNumber numberWithFloat:attributes.eventattributes.latitute]]) , @"Latitude",
            ObjectOrNull(attributes.eventattributes.searchQuery) , @"QueryString",
            ObjectOrNull(action), @"ActionTaken",
            ObjectOrNull(attributes.eventattributes.readArticles) , @"ReadArticle",
            ObjectOrNull([NSNumber numberWithInt:attributes.eventattributes.duration]) , @"ReadingDuration",
            ObjectOrNull(attributes.eventattributes.articleAuthor) , @"ArticleAuthor",
            ObjectOrNull(attributes.eventattributes.articlePostDate) , @"ArticlePostDate",
            ObjectOrNull(attributes.eventattributes.commentContent) , @"CommentContent",
            ObjectOrNull([NSNumber numberWithInt:attributes.eventattributes.articleCharacterCount]), @"ArticleContentAmount",
            ObjectOrNull(attributes.arbitaryinvariant.loginTimeStamp) , @"LoginTimeStamp",
            ObjectOrNull(attributes.eventattributes.likedContent) , @"LikedContent",
            ObjectOrNull(attributes.eventattributes.shareRetweetContent) , @"ShareRetweetContent",
            ObjectOrNull(attributes.eventattributes.followEntity) , @"FollowedEntity",
            ObjectOrNull([NSNumber numberWithInt:attributes.eventattributes.rating]) , @"Rating",
            ObjectOrNull(attributes.eventattributes.metaTags) , @"MobileApplicationMetaTags",
            ObjectOrNull(attributes.eventattributes.previousScreen) , @"PreviousAppUniqueId",
            ObjectOrNull(attributes.eventattributes.screenDestination) , @"DestinationAppUniqueId", nil];
    
    return attributesDictionary;
}


static id ObjectOrNull(id object){
    return object ?: @"";
}

@end
