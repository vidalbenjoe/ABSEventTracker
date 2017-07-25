//
//  ABSBigDataServiceDispatcher.m
//  EventApp
//
//  Created by Benjoe Vidal on 07/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

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
#import "ABSLogger.h"
#import "DeviceInfo.h"

@implementation ABSBigDataServiceDispatcher
+(void) requestToken: (void (^)(NSString *token))handler{
        ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            NSDictionary *header = @{@"Origin":host};
            [networking GET:eventAppsBaseURL path:eventTokenURL headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
                NSString *token = responseObject[@"token"];
                handler(token);
                [AuthManager storeTokenToUserDefault:token];
                [AuthManager storeTokenReceivedTimestamp:[NSDate date]];
            } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                [[ABSLogger initialize] setMessage:[NSString stringWithFormat:@"TOKEN: %@", error
                                                    
                ]];
            }];
}

+(void) dispatchAttribute:(AttributeManager *) attributes{
    NSDate *timeNow = [NSDate date];
    // If less than 9 minutes, do something
    if ([[AuthManager retrieveTokenExpirationTimestamp] timeIntervalSinceDate:timeNow] > 0){
        NSLog(@"REQUEST A TOKEN: NEW - timenow is greater than expiration date");
        [self requestToken:^(NSString *token) {
            [AuthManager storeTokenToUserDefault:token];
        }];
    }else{
        NSLog(@"REQUEST A TOKEN: OLD - timenow is less than expiration date");
        NSData *writerAttributes = [self writerAttribute:attributes];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", eventAppsBaseURL,eventWriteURL]];
        ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSDictionary *header = @{@"Authorization":[NSString stringWithFormat:@"Bearer %@", [AuthManager retrieveServerTokenFromUserDefault]]};
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            [networking POST:url HTTPBody:writerAttributes headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
                NSLog(@"WRITINGSUCCESS");
                [[ABSLogger initialize] setMessage:[NSString stringWithFormat:@"-WRITING: %@", responseObject]];
            } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"WRITINGERROR");
                [[ABSLogger initialize] setMessage:[NSString stringWithFormat:@"-WRITING: %@", error]];
            }];
        });
    }
    
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
            NSDictionary *header = @{@"Authorization" : [NSString stringWithFormat:@"Bearer %@", [AuthManager retrieveServerTokenFromUserDefault]],
                                     @"Origin":host};
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
    NSDictionary *header = @{@"Authorization" : [NSString stringWithFormat:@"Bearer %@", [AuthManager retrieveServerTokenFromUserDefault]],
                             @"Origin":host};
    [networking POST:url URLparameters:resultString headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
        [CacheManager removeCachedAttributeByFirstIndex];
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        [CacheManager storeFailedAttributesToCacheManager:obj];
    }];
}

+(NSData *) writerAttribute:(AttributeManager *) attributes {
    NSError *error;
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
            ObjectOrNull([DeviceInfo deviceConnectivity]) , @"ConnectivityType",
            ObjectOrNull(attributes.arbitaryinvariant.applicationLaunchTimeStamp) , @"ApplicationLoadTimeStamp",
            ObjectOrNull(attributes.arbitaryinvariant.applicationAbandonTimeStamp) , @"ApplicationAbandonTimeStamp",
            ObjectOrNull(attributes.arbitaryinvariant.postCommentTimeStamp) , @"WritingEventTimestamp",
            ObjectOrNull(attributes.arbitaryinvariant.logoutTimeStamp) , @"LogoutTimeStamp",
            ObjectOrNull(attributes.arbitaryinvariant.searchTimeStamp) , @"SearchTimeStamp",
            ObjectOrNull([NSString stringWithFormat:@"%@",attributes.session.sessionID])  , @"BigDataSessionID",
            ObjectOrNull([FormatUtils getCurrentTimeAndDate:attributes.session.sessionStart]) , @"SessionStartTimestamp",
            ObjectOrNull([FormatUtils getCurrentTimeAndDate:attributes.session.sessionEnd]), @"SessionEndTimestamp",
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
            ObjectOrNull(attributes.eventattributes.screenDestination) , @"DestinationAppUniqueId",
            ObjectOrNull(attributes.eventattributes.commentContent) , @"CommenteddArticle",
            ObjectOrNull(attributes.eventattributes.followEntity) , @"CookiesEnabled",
            ObjectOrNull(attributes.eventattributes.followEntity) , @"CurrentWebPage",
            ObjectOrNull([NSNumber numberWithInt:attributes.eventattributes.duration]) , @"ViewPageDuration",
            @" " , @"VideoPlay",
            @" " , @"VideoPause",
            @" " , @"VideoSeek",
            @" " , @"VideoSeekStart"
                                                 @" " , @"VideoSeekEnd"
                                                 @" " , @"VideoResume"
                                                 @" " , @"VideoStop",
                                                 @" " , @"VideoAdClick",
                                                 @" " , @"VideoAdComplete",
                                                 @" " , @"VideoAdSkipped"
                                                 @" " , @"VideoAdError"
                                                 @" " , @"VideoAdPlay"
                                                 @" " , @"VideoAdTime"
                                                 @" " , @"VideoMeta"
                                                 @" "  , @"VideoBuffer"
                                                 @" " , @"VideoTimeStamp"
                                                 @" " , @"VideoDuration"
                                                 @" " , @"VideoIsEnded"
                                                 @" " , @"VideoIsPaused"
                                                 @" " , @"VideoFullScreen"
                                                 @" " , @"VideoPlayerState"
                                                 @" " , @"VideoTitle"
                                                 @" " , @"VideoURL"
                                                 @" " , @"VideoVolume"
                                                 @" " , @"VideoSize"
                                                 ,nil];
    
    NSMutableArray *aray = [NSMutableArray arrayWithObject:attributesDictionary];
    NSData *body = [NSJSONSerialization dataWithJSONObject:aray
                                                   options:kNilOptions
                                                     error:&error];
    if(body == nil){
        return 0;
    }
    return body;
}

//
static id ObjectOrNull(id object){
    return object ?: @"";
}

@end
