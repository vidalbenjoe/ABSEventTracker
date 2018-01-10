
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
NSNumber *duration;
NSString *userID;

/*!
 * Method for requesting security hash. This method will return a security hash via block(handler)
 */
+(void) requestSecurityHash: (void (^)(NSString *sechash))handler{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSDictionary *header = @{@"x-mobile-header" : [Constant generateNewMobileHeader]};
        [networking GET:eventAppsBaseURL path:eventMobileResourceURL headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
            NSString *sechash = responseObject[@"seccode"];
            handler(sechash);
            [AuthManager storeSecurityHashTouserDefault:sechash];
            NSDate *receivedTimestamp = [NSDate date];
            [AuthManager storeSechashReceivedTimestamp:receivedTimestamp];
        } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(SECHASH_ERROR_REQUEST);
            [AuthManager removeSechHash];
        }];
    });
}
/*!
 * Method for requesting server token. This method will return the server token via block(handler)
 */
+(void) requestToken: (void (^)(NSString *token))handler{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSDate *timeNow = [NSDate date];
        ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [[networking requestBody] setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        // REQUEST TOKEN
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", eventAppsBaseURL,tokenURL]];
        
        if ([AuthManager retrieveSecurityHashFromUserDefault] != nil) {
            /*
             * Checking the current time if not exceed the server sechash expiration date.
             * Note: The sechash will last for 60 minutes.
             * The system should request a new sechash after 60 minutes when there are no user activities or session detected.
             */
            if ([timeNow timeIntervalSinceDate:[AuthManager retrieveSecHashReceivedTimestamp] ] > 0) {
                /*
                 * Request a new Sechash if the current time exceed the Sechash expiration timestamp
                 */
                [self requestSecurityHash:^(NSString *sechash) {
                    NSString *post = [NSString stringWithFormat:@"targetcode=%@&grant_type=password", sechash];
                    [networking POST:url URLparameters:post success:^(NSURLSessionDataTask *task, id responseObject) {
                        // store the token somewhere
                        NSString *token = responseObject[@"access_token"];
                        [AuthManager storeTokenToUserDefault:token];
                        handler(token);
                        NSDate *receivedTimestamp = [NSDate date];
                        [AuthManager storeTokenReceivedTimestamp:receivedTimestamp];
                    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
//                        [[ABSLogger init] setMessage:[NSString stringWithFormat:@"@ BIG-DATA:  Can't retrieve token from server - %@", error]];
                        [AuthManager removeSechHash];
                    }];
                }];
            }else{
                NSString *post = [NSString stringWithFormat:@"targetcode=%@&grant_type=password", [AuthManager retrieveSecurityHashFromUserDefault]];
                [networking POST:url URLparameters:post success:^(NSURLSessionDataTask *task, id responseObject) {
                    // store the token somewhere
                    NSString *token = responseObject[@"access_token"];
                    [AuthManager storeTokenToUserDefault:token];
                    handler(token);
                    NSDate *receivedTimestamp = [NSDate date];
                    [AuthManager storeTokenReceivedTimestamp:receivedTimestamp];
                } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
//                     [[ABSLogger init] setMessage:[NSString stringWithFormat:@"@ BIG-DATA:  Can't retrieve token from server - %@", error]];
                    [AuthManager removeSechHash];
                }];
            }
        }else{
            [self requestSecurityHash:^(NSString *sechash) {
                NSString *post = [NSString stringWithFormat:@"targetcode=%@&grant_type=password", sechash];
                [networking POST:url URLparameters:post success:^(NSURLSessionDataTask *task, id responseObject) {
                    // store the token somewhere
                    NSString *token = responseObject[@"access_token"];
                    [AuthManager storeTokenToUserDefault:token];
                    handler(token);
                    NSDate *receivedTimestamp = [NSDate date];
                    [AuthManager storeTokenReceivedTimestamp:receivedTimestamp];
                } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                     [[ABSLogger init] setMessage:[NSString stringWithFormat:@"@ BIG-DATA:  Can't retrieve token from server - %@", error]];
                    [AuthManager removeSechHash];
                }];
            }];
        }
    });
}
/* Request token for Recommedation
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
//                [[ABSLogger init] setMessage:[NSString stringWithFormat:@"@ BIG-DATA: Error getting token - %@", error]];
               
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
                /*Capture the current view inside the mobile app
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
    NSData *writerAttributes = [self writerAttribute:attributes]; // Get the value of attributes from the AttributesManager
        /*
         * Initializing NSURL - @eventAppsBaseURL @eventWriteURL
         */
    
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",eventAppsBaseURL,eventWriteURL]];
        ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        /*
         * Retrieving server token to be used in request header.
         */
        NSDictionary *header = @{@"Authorization":[NSString stringWithFormat:@"Bearer %@", [AuthManager retrieveServerTokenFromUserDefault]]};
    
    [networking POST:url HTTPBody:writerAttributes headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
            /*
             * Success: Sending server response to ABSLogger.
             */
//            [[ABSLogger initialize] setMessage:[NSString stringWithFormat:@"-WRITING: %@", responseObject]];
        } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
            /*
             * Failed to send attributes: Converting writerAttributes(NSData) to Dictionary to store in CacheManager.
             */
            NSMutableDictionary* data = [NSJSONSerialization JSONObjectWithData:writerAttributes options:kNilOptions error:&error];
        
            /*
             * Storing attributes dictionary into CacheManager.
             */
            [CacheManager storeFailedAttributesToCacheManager:data];
//            [[ABSLogger initialize] setMessage:[NSString stringWithFormat:@"-WRITING: %@", error]];
        }];
}

+(void) dispatchCachedAttributes{
    /*
     * Retriving all failed array of attributes from the CacheManager.
     */
    if ([[CacheManager retrieveAllCacheArray] count] > 0) {
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        // Loop cached array and add to queue
        for (int i = 0; i < [CacheManager retrieveAllCacheArray].count; i++) {
            // Add cached Array to attributes dictionary
            [attributes setObject:[[CacheManager retrieveAllCacheArray] objectAtIndex:i] forKey:@"attributes"];
            NSOperationQueue *operationQueue = [NSOperationQueue new];
            [operationQueue setMaxConcurrentOperationCount:5];
            ABSCustomOperation *customOperation = [[ABSCustomOperation alloc] initWithData:attributes];
            //You can pass any object in the initWithData method. Here we are passing a NSDictionary Object

            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",eventAppsBaseURL,eventWriteURL]];
            ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            NSDictionary *header = @{@"Authorization":[NSString stringWithFormat:@"Bearer %@", [AuthManager retrieveServerTokenFromUserDefault]]};
//            /*
//             * Converting Dictionary attributes to NSData and send to server through HTTPBody
//             */
            if ([NSJSONSerialization isValidJSONObject:customOperation]) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:customOperation options:NSJSONWritingPrettyPrinted error:0];

            [networking POST:url HTTPBody:data headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
                // Remove the first index in the array of attributes from CacheManager if successfull
                [CacheManager removeCachedAttributeByFirstIndex];
            } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                /*
                 * Storing attributes dictionary again into CacheManager.
                 */
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
            [customOperation start];
            //Uncommenting this line of code will run the custom operation twice one using the NSOperationQueue and the other using the custom operations start method
            }
        }
    }
}
/**
 * This method returns a consolidated attributes that will be used for sending event data into the datalake.
 * Attributes is composed of UserAttributes, PropertyEventSource, DeviceAttributes, ArbitaryAttributes, SessionManager, VideoAttributes and EventAttributes. All of the attributes is managed by AttributeManager.
 */
+(NSData *) writerAttribute:(AttributeManager *) attributes {
    NSError *error;
    duration = 0;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    
    
    NSString *action =  [GenericEventController convertActionTaken:attributes.genericattributes.actionTaken];
   
    if (attributes.userattributes.gigyaID == nil) {
        userID = attributes.userattributes.ssoID == nil ? [UserAttributes retrieveUserID] : attributes.userattributes.ssoID;
    }else{
        userID = attributes.userattributes.gigyaID == nil ? [UserAttributes retrieveUserID] : attributes.userattributes.gigyaID;
    }
    NSString *isvideoEnded = attributes.videoattributes.isVideoEnded ? @"True" : @"False";
    NSString *isvideoPaused = attributes.videoattributes.isVideoPaused ? @"True" : @"False";
    NSString *isvideoFullScreen = attributes.videoattributes.isVideoFullScreen ? @"True" : @"False";
    
    NSString *videoState = [VideoAttributes convertVideoStateToString:attributes.videoattributes.videostate];
        NSString *videoSize = [NSString stringWithFormat:@"%dx%d", attributes.videoattributes.videoHeight, attributes.videoattributes.videoWidth];
    
    NSString *screenSize = [NSString stringWithFormat:@"%lix%li", (long)attributes.deviceinvariant.deviceScreenWidth, (long)attributes.deviceinvariant.deviceScreenHeight];
    
    NSDate *accessViewTimeStamp = [dateFormatter dateFromString:attributes.arbitaryinvariant.viewAccessTimeStamp];
    NSDate *abandonViewTimeStamp = [dateFormatter dateFromString:attributes.arbitaryinvariant.viewAbandonTimeStamp];
    
    if (abandonViewTimeStamp != nil) {
        if (accessViewTimeStamp > abandonViewTimeStamp) {
            duration = [NSNumber numberWithLong: [FormatUtils timeDifferenceInSeconds:abandonViewTimeStamp endTime:accessViewTimeStamp]];
        }
    }
    
    if ([[AuthManager retrievedFingerPrintID] isEqualToString:attributes.deviceinvariant.deviceFingerprint]) {
    }
//   [dateFormatter stringFromDate:date]
//    accessViewTimeStamp
    NSMutableDictionary *attributesDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
        ObjectOrNull(userID) , @"GigyaID",
        ObjectOrNull(attributes.deviceinvariant.deviceFingerprint) , @"fingerprintID",
        ObjectOrNull([[AuthManager retrievedFingerPrintID] isEqualToString:attributes.deviceinvariant.deviceFingerprint] ? attributes.deviceinvariant.deviceFingerprint : [AuthManager retrievedFingerPrintID]) , @"PreviousFingerPrintId",
        ObjectOrNull(attributes.propertyinvariant.siteDomain) , @"SiteDomain",
        ObjectOrNull(attributes.propertyinvariant.applicationName) , @"ApplicationName",
        ObjectOrNull(attributes.propertyinvariant.bundleIdentifier) , @"ApplicationUniqueId",
        @"iOS" , @"DeviceOS",
        ObjectOrNull(attributes.deviceinvariant.deviceType) , @"MobileDevice",
        ObjectOrNull(screenSize)  , @"ScreenSize",
        ObjectOrNull([DeviceInfo getUserInterfaceIdiom]) , @"DeviceType",
        ObjectOrNull(attributes.propertyinvariant.bundleIdentifier) , @"PageURL",
        ObjectOrNull([DeviceInfo deviceConnectivity]) , @"ConnectivityType",
        ObjectOrNull(attributes.arbitaryinvariant.applicationLaunchTimeStamp == nil ? [CacheManager retrieveApplicationLoadTimestamp] : attributes.arbitaryinvariant.applicationLaunchTimeStamp), @"ApplicationLoadTimeStamp",
        ObjectOrNull(attributes.arbitaryinvariant.applicationAbandonTimeStamp), @"ApplicationAbandonTimeStamp",
        ObjectOrNull(@""), @"WritingEventTimestamp",
        ObjectOrNull(attributes.arbitaryinvariant.logoutTimeStamp), @"LogoutTimeStamp",
        ObjectOrNull(attributes.arbitaryinvariant.searchTimeStamp), @"SearchTimeStamp",
        ObjectOrNull([NSString stringWithFormat:@"%@",attributes.session.sessionID]), @"BigDataSessionID",
        ObjectOrNull([FormatUtils getCurrentTimeAndDate:attributes.session.sessionStart]), @"SessionStartTimestamp",
        ObjectOrNull([FormatUtils getCurrentTimeAndDate:attributes.session.sessionEnd]), @"SessionEndTimestamp",
        ObjectOrNull(attributes.userattributes.firstName == nil ? [UserAttributes retrieveFirstName] : attributes.userattributes.firstName) , @"FirstName",
        ObjectOrNull(attributes.userattributes.middleName == nil ? [UserAttributes retrieveMiddleName] : attributes.userattributes.middleName)  , @"MiddleName",
        ObjectOrNull(attributes.userattributes.lastName == nil ? [UserAttributes retrieveLastName] : attributes.userattributes.lastName), @"LastName",
        ObjectOrNull(attributes.eventattributes.clickedContent) , @"ClickedContent",
        ObjectOrNull([NSString stringWithFormat:@"%@", [NSNumber numberWithFloat:attributes.eventattributes.longitude]]), @"Longitude",
        ObjectOrNull([NSString stringWithFormat:@"%@", [NSNumber numberWithFloat:attributes.eventattributes.latitute]]) , @"Latitude",
        ObjectOrNull(attributes.eventattributes.searchQuery) , @"QueryString",
        ObjectOrNull(action), @"ActionTaken",
        ObjectOrNull(attributes.eventattributes.readArticle) , @"ReadArticle",
        ObjectOrNull([NSString stringWithFormat:@"%@", duration]), @"ReadingDuration",
        ObjectOrNull(attributes.eventattributes.articleAuthor) , @"ArticleAuthor",
        ObjectOrNull(attributes.eventattributes.articlePostDate) , @"ArticlePostDate",
        ObjectOrNull(attributes.eventattributes.commentContent) , @"CommentContent",
        ObjectOrNull(attributes.videoattributes.videoConsolidatedBufferTime) , @"VideoConsolidatedBufferTime",
        ObjectOrNull([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.videoattributes.videoTotalBufferTime]]) , @"VideoTotalBufferTime",
        ObjectOrNull([NSString stringWithFormat:@"%@",[NSNumber numberWithInt:attributes.eventattributes.articleCharacterCount]]), @"ArticleContentAmount",
        ObjectOrNull(attributes.arbitaryinvariant.loginTimeStamp) , @"LoginTimeStamp",
        ObjectOrNull(attributes.eventattributes.likedContent) , @"LikedContent",
        ObjectOrNull(attributes.eventattributes.shareRetweetContent) , @"ShareRetweetContent",
        ObjectOrNull(attributes.eventattributes.followedEntity) , @"FollowedEntity",
        ObjectOrNull([NSString stringWithFormat:@"%@",[NSNumber numberWithInt:attributes.eventattributes.rating]]) , @"Rating",
        ObjectOrNull(attributes.eventattributes.metaTags) , @"MobileApplicationMetaTags",
        ObjectOrNull(attributes.eventattributes.previousView) , @"PreviousView",
        ObjectOrNull(attributes.eventattributes.currentView) , @"CurrentView",
        ObjectOrNull(attributes.eventattributes.destinationView) , @"DestinationView",
        ObjectOrNull([NSString stringWithFormat:@" %@",duration]), @"ViewPageDuration",
        ObjectOrNull(attributes.eventattributes.readArticle) , @"CommentedArticle",
                                @"", @"ViewAccessTimestamp",
        ObjectOrNull([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.videoattributes.videoPlayPosition]]), @"VideoPlay",
        ObjectOrNull([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.videoattributes.videoPausePosition]]), @"VideoPause",
        ObjectOrNull([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.videoattributes.videoSeekStart]]) , @"VideoSeekStart",
        ObjectOrNull([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.videoattributes.videoSeekEnd]]) , @"VideoSeekEnd",
        ObjectOrNull([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.videoattributes.videoResumePosition]]) , @"VideoResume",
        ObjectOrNull([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.videoattributes.videoStopPosition]]) , @"VideoStop",
        ObjectOrNull(attributes.videoattributes.videoAdClick) , @"VideoAdClick",
        ObjectOrNull(attributes.videoattributes.videoAdComplete) , @"VideoAdComplete",
        ObjectOrNull(attributes.videoattributes.videoAdSkipped) , @"VideoAdSkipped",
        ObjectOrNull(attributes.videoattributes.videoAdError) , @"VideoAdError",
        ObjectOrNull(attributes.videoattributes.videoAdPlay) , @"VideoAdPlay",
        ObjectOrNull([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.videoattributes.videoAdTime]]) , @"VideoAdTime",
        ObjectOrNull(attributes.videoattributes.videoMeta) , @"VideoMeta",
        ObjectOrNull(attributes.videoattributes.videoTimeStamp) , @"VideoTimeStamp",
        ObjectOrNull([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.videoattributes.videoDuration]]) , @"VideoDuration",
        ObjectOrNull(isvideoPaused), @"VideoIsPaused",
        ObjectOrNull(isvideoEnded), @"VideoIsEnded",
        ObjectOrNull(videoState), @"VideoPlayerState",
        ObjectOrNull(attributes.videoattributes.videoTitle) , @"VideoTitle",
        ObjectOrNull(attributes.videoattributes.videoURL) , @"VideoURL",
        ObjectOrNull(isvideoFullScreen), @"VideoFullScreen",
        ObjectOrNull([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.videoattributes.videoVolume]]) , @"VideoVolume",
         ObjectOrNull(videoSize) , @"VideoSize",
                                                 nil];
         NSData *attributesData = [NSJSONSerialization dataWithJSONObject:attributesDictionary options:kNilOptions error:&error];
    return attributesData;
}

// This method will return empty string if the attributes is nil or empty
static id ObjectOrNull(id object){
    return object ?: @"null";
}

@end
