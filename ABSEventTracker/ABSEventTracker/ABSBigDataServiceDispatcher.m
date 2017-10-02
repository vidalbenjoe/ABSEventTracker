
//  ABSBigDataServiceDispatcher.m
//  EventApp
//
//  Created by Benjoe Vidal on 07/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.

#import "ABSBigDataServiceDispatcher.h"
#import "Constant.h"
#import "HTTPCallBack.h"
#import "ABSNetworking.h"
#import "AuthManager.h"
#import "CacheManager.h"
#import "DeviceFingerprinting.h"
#import "FormatUtils.h"
#import "ABSCustomOperation.h"
#import "ABSLogger.h"
#import "DeviceInfo.h"

@implementation ABSBigDataServiceDispatcher

+(void) requestSecurityHash: (void (^)(NSString *sechash))handler{
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
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [self requestSecurityHash:^(NSString *sechash) {
            ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            [[networking requestBody] setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            // REQUEST TOKEN
            NSString *post = [NSString stringWithFormat:@"targetcode=%@&grant_type=password",sechash];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", eventAppsBaseURL,tokenURL]];
            [networking POST:url URLparameters:post success:^(NSURLSessionDataTask *task, id responseObject) {
                // store the token somewhere
                NSString *token = responseObject[@"access_token"];
                [AuthManager storeTokenToUserDefault:token];
                handler(token);
                NSLog(@"MYCURTOKEN: %@", token);
                NSDate *receivedTimestamp = [NSDate date];
                [AuthManager storeTokenReceivedTimestamp:receivedTimestamp];
            } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"TOKEN_ERROR");
            }];
        }];
    });
}

/* Request token for Recommedation
 *
 */
+(void) recoTokenRequest: (void (^)(NSString *token)) handler{
    ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    /*
     * Getting Digital property host url to be used in request header - @host
     */
    NSDictionary *header = @{@"SiteDomain":@"http://ottdevapi.portal.azure-api.net"};
    
            [networking GET:eventAppsBaseURL path:eventTokenURL headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
                /*
                 * Getting server token from the response
                 */
                NSString *token = responseObject[@"token"];
                handler(token);
                NSLog(@"myToken: %@",token);
                /*
                 * Store server token into NSUserDefault
                 */
                [AuthManager storeTokenToUserDefault:token];
                /*
                 * Store token expiration time into NSUserDefault
                 */
                [AuthManager storeTokenReceivedTimestamp:[NSDate date]];
            } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                /*
                 * Request token failed
                 */
                NSLog(@"error getting token");
                [[ABSLogger initialize] setMessage:[NSString stringWithFormat:@"TOKEN: %@", error
                ]];
            }];
}

+(void) dispatchAttribute:(AttributeManager *) attributes{
    /*
     * Check if server token is stored in NSUserDefault and not null
     */
    if ([AuthManager retrieveServerTokenFromUserDefault] != nil) {
        NSDate *timeNow = [NSDate date];
        /*
         * Checking the current time if not exceed the server token expiration date.
         * Note: The server token will last for only 9 minutes.
         */
        if ([timeNow timeIntervalSinceDate:[AuthManager retrieveTokenExpirationTimestamp] ] > 0){
            /*
             * Request a new server token if the current time exceeded the server token expiration timestamp
             */
            [self requestToken:^(NSString *token) {
                /*
                 * Storing server token in NSUserDefault
                 */
                [AuthManager storeTokenToUserDefault:token];
                [self dispatcher:attributes];
            }];
        }else{
            /*
             * If current time is less than the 9 minutes expiration time allowance, dispatch attributes into the data lake
             */
            [self dispatcher:attributes];
        }
    }else{
        /*
         * If server token is null in NSUserdefault, request a new token
         */
        [self requestToken:^(NSString *token) {
            /*
             * Storing server token in NSUserDefault
             */
            [AuthManager storeTokenToUserDefault:token];
        }];
    }
}

+(void) dispatcher:(AttributeManager *) attributes{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSMutableDictionary *writerAttributes = [self writerAttribute:attributes]; // Get the value of attributes from the AttributesManager
    /*
     * Initializing NSURL - @eventAppsBaseURL @eventWriteURL
     */
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",eventAppsBaseURL,eventWriteURL]];
    ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    /*
     * Retrieving server token to be used in request header.
     */
    NSDictionary *header = @{@"Authorization":[NSString stringWithFormat:@"Bearer %@", [AuthManager retrieveServerTokenFromUserDefault]]};
    
    NSMutableString *resultString = [NSMutableString string];
    for (NSString* key in [writerAttributes allKeys]){
        if ([resultString length]>0)
            [resultString appendString:@"&"];
        [resultString appendFormat:@"%@=%@", key, [writerAttributes objectForKey:key]];
    }
    dispatch_async(queue, ^{
        [networking POST:url URLparameters:resultString headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
            /*
             * Events successfully sent to server
             */
            [[ABSLogger initialize] setMessage:[NSString stringWithFormat:@"-WRITING: %@", responseObject]];
        } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
            [CacheManager storeFailedAttributesToCacheManager:writerAttributes];
            [[ABSLogger initialize] setMessage:[NSString stringWithFormat:@"-WRITING: %@", error]];
        }];
    });
}

+(void) dispatchCachedAttributes{
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
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://eventsapi.bigdata.abs-cbn.com/%@",eventWriteURL]];
            ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            
            NSDictionary *header = @{@"Authorization" : [NSString stringWithFormat:@"Bearer %@", [AuthManager retrieveServerTokenFromUserDefault]],
                                     @"SiteDomain":@"http://ottdevapi.portal.azure-api.net"};
            
            NSData *data = [NSJSONSerialization dataWithJSONObject:attributes options:0 error:0];
            
            [networking POST:url HTTPBody:data headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
                [CacheManager removeCachedAttributeByFirstIndex];
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

/*!
 * This method returns a consolidated attributes that will be used for sending event data into the datalake.
 * Attributes is composed of UserAttributes, PropertyEventSource, DeviceAttributes, ArbitaryAttributes, SessionManager, VideoAttributes and EventAttributes. All of the attributes is managed by AttributeManager.
 */
+(NSMutableDictionary *) writerAttribute:(AttributeManager *) attributes {
//    NSError *error;
    NSString *action = [EventAttributes convertActionTaken:attributes.eventattributes.actionTaken];
    NSString *userID = ObjectOrNull(attributes.userattributes.gigyaID) ? ObjectOrNull(attributes.userattributes.ssoID) : attributes.userattributes.gigyaID;
    NSString *videoState = [VideoAttributes convertVideoStateToString:attributes.videoattributes.videostate];
    
    NSString *videoSize = [NSString stringWithFormat:@"%dx%d", attributes.videoattributes.videoHeight, attributes.videoattributes.videoWidth];
    NSMutableDictionary *attributesDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            userID , @"GigyaID",
        ObjectOrNull([DeviceFingerprinting generateDeviceFingerprint]) , @"fingerprintID",
        ObjectOrNull(attributes.propertyinvariant.siteDomain) , @"SiteDomain",
        ObjectOrNull(attributes.propertyinvariant.applicationName) , @"ApplicationUniqueId",
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
        ObjectOrNull(attributes.eventattributes.readArticle) , @"ReadArticle",
        ObjectOrNull([NSNumber numberWithInt:attributes.eventattributes.readingDuration]) , @"ReadingDuration",
        ObjectOrNull(attributes.eventattributes.articleAuthor) , @"ArticleAuthor",
        ObjectOrNull(attributes.eventattributes.articlePostDate) , @"ArticlePostDate",
        ObjectOrNull(attributes.eventattributes.commentContent) , @"CommentContent",
        ObjectOrNull([NSNumber numberWithInt:attributes.eventattributes.articleCharacterCount]), @"ArticleContentAmount",
        ObjectOrNull(attributes.arbitaryinvariant.loginTimeStamp) , @"LoginTimeStamp",
        ObjectOrNull(attributes.eventattributes.likedContent) , @"LikedContent",
        ObjectOrNull(attributes.eventattributes.shareRetweetContent) , @"ShareRetweetContent",
        ObjectOrNull(attributes.eventattributes.followedEntity) , @"FollowedEntity",
        ObjectOrNull([NSNumber numberWithInt:attributes.eventattributes.rating]) , @"Rating",
        ObjectOrNull(attributes.eventattributes.metaTags) , @"MobileApplicationMetaTags",
        ObjectOrNull(attributes.eventattributes.previousScreen) , @"PreviousAppUniqueId",
        ObjectOrNull(attributes.eventattributes.screenDestination) , @"DestinationAppUniqueId",
        ObjectOrNull(attributes.eventattributes.commentContent) , @"CommenteddArticle",
        ObjectOrNull(attributes.eventattributes.clickedContent) , @"CookiesEnabled",
        ObjectOrNull(attributes.eventattributes.clickedContent) , @"CurrentWebPage",
        ObjectOrNull([NSNumber numberWithInt:attributes.eventattributes.readingDuration]) , @"ViewPageDuration",
        ObjectOrNull([NSNumber numberWithDouble:attributes.videoattributes.videoPlayPosition]), @"VideoPlay",
        ObjectOrNull([NSNumber numberWithDouble:attributes.videoattributes.videoPausePosition]), @"VideoPause",
        ObjectOrNull([NSNumber numberWithDouble:attributes.videoattributes.videoPlayPosition]) , @"VideoSeek",
        ObjectOrNull([NSNumber numberWithDouble:attributes.videoattributes.videoSeekStart]) , @"VideoSeekStart",
        ObjectOrNull([NSNumber numberWithDouble:attributes.videoattributes.videoSeekEnd]) , @"VideoSeekEnd",
        ObjectOrNull([NSNumber numberWithDouble:attributes.videoattributes.videoResumePosition]) , @"VideoResume",
        ObjectOrNull([NSNumber numberWithDouble:attributes.videoattributes.videoStopPosition]) , @"VideoStop",
        attributes.videoattributes.videoAdClick , @"VideoAdClick",
        attributes.videoattributes.videoAdComplete , @"VideoAdComplete",
        ObjectOrNull(attributes.videoattributes.videoAdSkipped) , @"VideoAdSkipped",
        ObjectOrNull(attributes.videoattributes.videoAdError) , @"VideoAdError",
        ObjectOrNull(attributes.videoattributes.videoAdPlay) , @"VideoAdPlay",
        ObjectOrNull([NSNumber numberWithDouble:attributes.videoattributes.videoAdTime]) , @"VideoAdTime",
        attributes.videoattributes.videoMeta , @"VideoMeta",
        attributes.videoattributes.videoBuffer  , @"VideoBuffer",
        attributes.videoattributes.videoTimeStamp , @"VideoTimeStamp",
        ObjectOrNull([NSNumber numberWithDouble:attributes.videoattributes.videoDuration]) , @"VideoDuration",
        ObjectOrNull([NSNumber numberWithBool:attributes.videoattributes.isVideoEnded]) , @"VideoIsEnded",
        ObjectOrNull([NSNumber numberWithBool:attributes.videoattributes.isVideoPaused ]), @"VideoIsPaused",
        ObjectOrNull([NSNumber numberWithBool:attributes.videoattributes.isVideoFullScreen]), @"VideoFullScreen",
        ObjectOrNull(videoState), @"VideoPlayerState",
        ObjectOrNull(attributes.videoattributes.videoTitle) , @"VideoTitle",
        ObjectOrNull(attributes.videoattributes.videoURL) , @"VideoURL",
        ObjectOrNull([NSNumber numberWithDouble:attributes.videoattributes.videoVolume]) , @"VideoVolume",
         ObjectOrNull(videoSize) , @"VideoSize", nil];

//    NSMutableArray *aray = [NSMutableArray arrayWithObject:attributesDictionary];
//    NSData *body = [NSJSONSerialization dataWithJSONObject:aray
//                                                   options:kNilOptions
//                                                     error:&error];
//    if(body == nil){
//        return 0;
//    }
    
    NSLog(@"asattributesDictionary %@", attributesDictionary);
    return attributesDictionary;
}

//
static id ObjectOrNull(id object){
    return object ?: @"";
}

@end
