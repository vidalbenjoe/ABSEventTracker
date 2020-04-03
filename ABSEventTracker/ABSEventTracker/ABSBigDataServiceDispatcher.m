
//  ABSBigDataServiceDispatcher.m
//  EventApp
//
//  Created by Benjoe Vidal on 07/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.

#import "ABSBigDataServiceDispatcher.h"
#import "Constant.h"
#import "HTTPCallBack.h"
#import "ABSNetworking.h"
#import "EventAuthManager.h"
#import "CacheManager.h"
#import "DeviceFingerprinting.h"
#import "FormatUtils.h"
#import "ABSCustomOperation.h"
#import "ABSLogger.h"
#import "DeviceInfo.h"
#import "ABSLogger.h"
#import "RecoAuthManager.h"

@implementation ABSBigDataServiceDispatcher
double durations;
NSString *userID;

/*!
 * Method for requesting security hash. This method will return a security hash via block(handler)
 */
+(void) requestSecurityHash: (void (^)(NSString *sechash)) handler{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
  
        ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] enableHTTPLog: [[ABSLogger initialize] displayHTTPLogs]];
        
        NSDictionary *header = @{@"x-mobile-header" : [Constant generateNewMobileHeader]};
        [networking GET:[[[AttributeManager init] propertyinvariant] url] path:eventMobileResourceURL headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
            NSString *sechash = responseObject[@"seccode"];
      
            handler(sechash);
            [EventAuthManager storeSecurityHashTouserDefault:sechash];
            NSDate *receivedTimestamp = [NSDate date];
            [EventAuthManager storeSechashReceivedTimestamp:receivedTimestamp];
        } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(SECHASH_ERROR_REQUEST  "%@", error.description);
            [[ABSLogger initialize] setMessage:error.description];
            [EventAuthManager removeSechHash];
        }];
    });
}

/*!
 * Method for requesting server token. This method will return the server token via block(handler)
 * Only applicable for ASP Connection
 */

+(void) requestToken: (void (^)(NSString *token))handler{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSDate *timeNow = [NSDate date];
         ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] enableHTTPLog: [[ABSLogger initialize] displayHTTPLogs]];
        // REQUEST TOKEN
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [[[AttributeManager init] propertyinvariant] url] ,eventTokenURL]];
           
        if ([EventAuthManager retrieveSecurityHashFromUserDefault] != nil) {
            /*
             * Checking the current time if it's not exceeding the server sechash expiration date.
             * Note: The sechash will last for 60 minutes.
             * The system should request a new sechash after 60 minutes when there are no user activities or session detected.
             */
         
            if ([timeNow timeIntervalSinceDate:[EventAuthManager retrieveSecHashReceivedTimestamp] ] > 0) {
                /*
                 * Request a new Sechash if the current time exceed the Sechash expiration timestamp
                 */
                [self requestSecurityHash:^(NSString *sechash) {
                    NSString *post = [NSString stringWithFormat:@"targetcode=%@&grant_type=password", sechash];
                    [networking POST:url URLparameters:post success:^(NSURLSessionDataTask *task, id responseObject) {
                        // store the token somewhere
                        NSString *token = responseObject[@"access_token"];
                      
                        [EventAuthManager storeTokenToUserDefault:token];
                        handler(token);
                        NSDate *receivedTimestamp = [NSDate date];
                        [EventAuthManager storeTokenReceivedTimestamp:receivedTimestamp];
                    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                        [[ABSLogger initialize] setMessage:error.description];
                        [EventAuthManager removeSechHash];
                    }];
                }];
                
            }else{
                // Retrieving sechash via NSUserdefault
                NSString *post = [NSString stringWithFormat:@"targetcode=%@&grant_type=password", [EventAuthManager retrieveSecurityHashFromUserDefault]];
                [networking POST:url URLparameters:post success:^(NSURLSessionDataTask *task, id responseObject) {
                    // store the token somewhere
                    NSString *token = responseObject[@"access_token"];
                    
                    [EventAuthManager storeTokenToUserDefault:token];
                    handler(token);
                    NSDate *receivedTimestamp = [NSDate date];
                    [EventAuthManager storeTokenReceivedTimestamp:receivedTimestamp];
                } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                    [[ABSLogger initialize] setMessage:error.description];
                    [EventAuthManager removeSechHash];
                }];
            }
        }else{
             
            // Requesting fresh token
            [self requestSecurityHash:^(NSString *sechash) {
                
                NSString *post = [NSString stringWithFormat:@"targetcode=%@&grant_type=password", sechash];
                [networking POST:url URLparameters:post success:^(NSURLSessionDataTask *task, id responseObject) {
                    NSString *token = responseObject[@"access_token"];
                    [EventAuthManager storeTokenToUserDefault:token];
                    handler(token);
                    
                    NSDate *receivedTimestamp = [NSDate date];
                    [EventAuthManager storeTokenReceivedTimestamp:receivedTimestamp];
                } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                    [[ABSLogger initialize] setMessage:error.description];
                    [EventAuthManager removeSechHash];
                }];
            }];
        }
    });
}


+(void) dispatchAttribute:(AttributeManager *) attributes{
     [self dispatcher:attributes];
}

+(void) dispatcher:(AttributeManager *) attributes{
      
    NSData *writerAttributes = [self writerAttribute:attributes]; // Get the value of attributes from the AttributesManager
//    NSString *JSONDataString = [[NSString alloc] initWithData:writerAttributes encoding:NSASCIIStringEncoding];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [[[AttributeManager init] propertyinvariant] url], [[[AttributeManager init] propertyinvariant] path]]];
    ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] enableHTTPLog: [[ABSLogger initialize] displayHTTPLogs]];
        /*
         * Initializing NSURL - @eventAppsBaseURL @eventWriteURL
         */
//    NSString *jsonString = [[NSString alloc] initWithData:writerAttributes encoding:NSASCIIStringEncoding];
//    NSLog(@"jsonStringss %@", jsonString);
    if (writerAttributes != nil) {
        /*
         * Check if server token is stored in NSUserDefault and not null
         */
        if ([EventAuthManager retrieveServerTokenFromUserDefault] != nil) {
            NSDate *timeNow = [NSDate date];
            /*
             * Checking the current time if not exceed the server token expiration date.
             * Note: The server token will last for only 9 minutes.
             */
            if ([timeNow timeIntervalSinceDate:[EventAuthManager retrieveTokenExpirationTimestamp] ] > 0){
                /*
                 * Request a new server token if the current time exceeded the server token expiration timestamp
                 */
                [self requestToken:^(NSString *token) {
                    /*Capture the current view inside the mobile app
                     * Storing server token in NSUserDefault
                     */
                    [EventAuthManager storeTokenToUserDefault:token];
                    [self dispatcher:attributes];
                }];
            }else{
                /*
                 * If current time is less than the 9 minutes expiration time allowance, dispatch attributes into the data lake
                 */
                 
                NSDictionary *header = @{@"Authorization":[NSString stringWithFormat:@"Bearer %@", [EventAuthManager retrieveServerTokenFromUserDefault]]};
                
//                [networking POST:url JSONString:JSONDataString headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
//
//                } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
//
//                }];
//
                [networking POST:url HTTPBody:writerAttributes headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
                    /*
                     * Success: Sending server response to ABSLogger.
                     */
                    [[ABSLogger initialize] setMessage:[NSString stringWithFormat:@"-WRITING: %@", responseObject]];
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
        }else{
            
            /*
             * If server token is null in NSUserdefault, request a new token
             */
            [self requestToken:^(NSString *token) {
                NSDictionary *header = @{@"Authorization":[NSString stringWithFormat:@"Bearer %@", token != nil ? token : [EventAuthManager retrieveServerTokenFromUserDefault]]};
//                [networking POST:url JSONString:JSONDataString headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
//                    [[ABSLogger initialize] setMessage:[NSString stringWithFormat:@"-WRIsTING: %@", responseObject]];
//                } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
//
//                }];
                
                
                [networking POST:url HTTPBody:writerAttributes headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
                   
                    /*
                     * Success: Sending server response to ABSLogger.
                     */
                     [[ABSLogger initialize] setMessage:[NSString stringWithFormat:@"-WRIsTING: %@", responseObject]];
                } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                    
                    /*
                     * Failed to send attributes: Converting writerAttributes(NSData) to Dictionary to store in CacheManager.
                     */
                    NSMutableDictionary* data = [NSJSONSerialization JSONObjectWithData:writerAttributes options:kNilOptions error:&error];
                    /*
                     * Storing attributes dictionary into CacheManager.
                     */
                    [CacheManager storeFailedAttributesToCacheManager:data];
                }];
            }];
        }
      
    }
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
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[[AttributeManager init] propertyinvariant] url], [[[AttributeManager init] propertyinvariant] path]]];
        
           ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] enableHTTPLog: [[ABSLogger initialize] displayHTTPLogs]];
            
            [self requestToken:^(NSString *token) {
                NSDictionary *header = @{@"Authorization":[NSString stringWithFormat:@"Bearer %@", token]};
                /*
                  Converting Dictionary attributes to NSData and send to server through HTTPBody
                 */
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
                  
                    customOperation.completionBlock =^{
                        //This is another way of catching the Custom Operation completition.
                        //In case you donot want to catch the completion using a block operation as state above. you can catch it here and remove the block operation and the dependency introduced in the next line of code
                    };
//                    [blockCompletionOperation addDependency:customOperation];
                    [operationQueue addOperation:customOperation];
                    [customOperation start];
                    //Uncommenting this line of code will run the custom operation twice one using the NSOperationQueue and the other using the custom operations start method
                }
            }];
        }
    }
}
/**
 * This method returns a consolidated attributes that will be used for sending event data into the datalake.
 * Attributes is composed of UserAttributes, PropertyEventSource, DeviceAttributes, ArbitaryAttributes, SessionManager, VideoAttributes and EventAttributes. All of the attributes is managed by AttributeManager.
 */

+(NSData *) writerAttribute:(AttributeManager *) attributes {
    NSError *error;
    NSString *viewpageDuration;
    durations = 0;
    
    /*Getting action taken from GenericEventController*/
    NSString *action = [GenericEventController convertActionTaken:attributes.genericattributes.actionTaken];
    /*Check if gigyaID is null*/
    if (attributes.userattributes.gigyaID == nil) {
        userID = attributes.userattributes.ssoID == nil ? [UserAttributes retrieveUserID] : attributes.userattributes.ssoID;
    }else{
        userID = attributes.userattributes.gigyaID != nil ? attributes.userattributes.gigyaID : [UserAttributes retrieveUserID];
    }
    

    
    NSString *isvideoEnded = attributes.videoattributes.isVideoEnded ? @"True" : @"False";
    NSString *isvideoPaused = attributes.videoattributes.isVideoPaused ? @"True" : @"False";
    NSString *isvideoFullScreen = attributes.videoattributes.isVideoFullScreen ? @"True" : @"False";
    
    NSString *isAudioEnded = attributes.audioattributes.isAudioEnded ? @"True" : @"False";
    NSString *isAudioPaused = attributes.audioattributes.isAudioPaused ? @"True" : @"False";
    
    NSString *isVideoAdPlay = attributes.videoattributes.videoAdPlay ? @"True" : @"False";
    NSString *isVideoAdSkipped = attributes.videoattributes.videoAdSkipped ? @"True" : @"False";
    NSString *isVideoAdClick = attributes.videoattributes.videoAdClick ? @"True" : @"False";
    NSString *isVideoAdError = attributes.videoattributes.videoAdError ? @"True" : @"False";
    NSString *isVideoAdComplete = attributes.videoattributes.videoAdComplete ? @"True" : @"False";
    
    NSString *videoState = [VideoAttributes convertVideoStateToString:attributes.videoattributes.videostate];
    NSString *audioState = [AudioAttributes convertAudioStateToString:attributes.audioattributes.audioPlayerState];
        NSString *videoSize = [NSString stringWithFormat:@"%dx%d", attributes.videoattributes.videoHeight, attributes.videoattributes.videoWidth];
    NSString *screenSize = [NSString stringWithFormat:@"%lix%li", (long)attributes.deviceinvariant.deviceScreenWidth, (long)attributes.deviceinvariant.deviceScreenHeight];
    
    NSDate *abandonViewTimeStamp = [[FormatUtils dateFormatter] dateFromString:attributes.arbitaryinvariant.viewAbandonTimeStamp];
    NSDate *accessViewTimeStamp = [[FormatUtils dateFormatter] dateFromString:attributes.arbitaryinvariant.viewAccessTimeStamp];
    
    NSString *escapedVideoURL = [attributes.videoattributes.videoURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *escapedAudioURL = [attributes.audioattributes.audioURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *escapedAudioType = [attributes.audioattributes.audioType stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    if (attributes.eventattributes.actionTaken == ABANDON_VIEW || attributes.eventattributes.actionTaken == ACCESS_VIEW) {
    if (abandonViewTimeStamp != nil ) {
        NSComparisonResult result;
        //has three possible values: NSOrderedSame,NSOrderedDescending, NSOrderedAscending
        result = [accessViewTimeStamp compare:abandonViewTimeStamp]; // comparing two dates
        if(result==NSOrderedAscending){
        viewpageDuration = [NSString stringWithFormat:@"%@",[NSNumber numberWithLong: [FormatUtils timeDifferenceInSeconds:accessViewTimeStamp endTime:abandonViewTimeStamp]]];
        }else if(result==NSOrderedDescending){
        viewpageDuration = [NSString stringWithFormat:@"%@",[NSNumber numberWithLong: [FormatUtils timeDifferenceInSeconds:abandonViewTimeStamp endTime:accessViewTimeStamp]]];
        }
    }
    }
    /*Consolidating all attributes into Mutable Dictionary to be sent to data lake*/
    NSMutableDictionary *attributesDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
        isNullObject(userID) , @"GigyaId",
        isNullObject(userID) , @"SSOId",
        isNullObject(attributes.eventattributes.kapamilyaName) , @"KapamilyaName",
        isNullObject(attributes.eventattributes.emailAddress) , @"EmailAddress",
        isNullObject(attributes.eventattributes.mobileNumber) , @"MobileNumber",
        isNullObject(attributes.deviceinvariant.deviceFingerprint) , @"FingerPrintId",
        isNullObject([[EventAuthManager retrievedFingerPrintID] isEqualToString:attributes.deviceinvariant.deviceFingerprint] ? attributes.deviceinvariant.deviceFingerprint : [EventAuthManager retrievedFingerPrintID]) , @"PreviousFingerPrintId",
        isNullObject(action), @"ActionTaken",
        isNullObject(attributes.propertyinvariant.siteDomain) , @"SiteDomain",
        isNullObject(attributes.propertyinvariant.applicationName) , @"ApplicationName",
        isNullObject(attributes.propertyinvariant.bundleIdentifier) , @"ApplicationUniqueId",
        isNullObject(attributes.deviceinvariant.deviceOS), @"DeviceOs",
        isNullObject([DeviceInfo deviceAdvertiserIdentifier]) , @"DeviceAdvertisingId",
        isNullObject(attributes.deviceinvariant.deviceType) , @"MobileDevice",
        isNullObject(screenSize)  , @"ScreenSize",
        isNullObject(attributes.deviceinvariant.deviceType) , @"DeviceType",
        isNullObject(attributes.deviceinvariant.appversionBuildRelease) , @"BuildVersionRelease",
        isNullObject([DeviceInfo deviceConnectivity]) , @"ConnectivityType",
        isNullObject(attributes.arbitaryinvariant.applicationLaunchTimeStamp == nil ? [CacheManager retrieveApplicationLoadTimestamp] : attributes.arbitaryinvariant.applicationLaunchTimeStamp), @"ApplicationLoadTimeStamp",
        isNullObject(attributes.arbitaryinvariant.applicationAbandonTimeStamp), @"ApplicationAbandonTimeStamp",
        isNullObject(attributes.arbitaryinvariant.postCommentTimeStamp), @"WritingEventTimeStamp",
        isNullObject(attributes.arbitaryinvariant.logoutTimeStamp), @"LogoutTimeStamp",
        isNullObject(attributes.arbitaryinvariant.searchTimeStamp), @"SearchTimeStamp",
        isNullObject([NSString stringWithFormat:@"%@",attributes.session.sessionID]), @"BigdataSessionId",
        isNullObject([FormatUtils getCurrentTimeAndDate:attributes.session.sessionStart]), @"SessionStartTimeStamp",
        isNullObject([FormatUtils getCurrentTimeAndDate:attributes.session.sessionEnd]), @"SessionEndTimeStamp",
        isNullObject(attributes.eventattributes.clickedContent) , @"ClickedContent",
        isNullObject(attributes.eventattributes.errorMessage) , @"ErrorMessage",
        isNullObject(attributes.eventattributes.inputField) , @"InputField",
        isNullObject([NSString stringWithFormat:@"%@", [NSNumber numberWithFloat:attributes.eventattributes.longitude]]), @"Longitude",
        isNullObject([NSString stringWithFormat:@"%@", [NSNumber numberWithFloat:attributes.eventattributes.latitude]]) , @"Latitude",
        isNullObject(attributes.eventattributes.searchQuery) , @"QueryString",
        isNullObject(attributes.eventattributes.readArticle) , @"ReadArticle",
        isNullObject([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:durations]]), @"ReadingDuration",
        isNullObject(attributes.eventattributes.articleAuthor) , @"ArticleAuthor",
        isNullObject(attributes.eventattributes.articlePostDate) , @"ArticlePostDate",
        isNullObject(attributes.eventattributes.commentContent) , @"CommentContent",
        isNullObject(attributes.videoattributes.videoConsolidatedBufferTime) , @"VideoConsolidatedBufferTime",
        isNullObject([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.videoattributes.videoBufferCount]]) , @"VideoBuffer",
        isNullObject([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.videoattributes.videoTotalBufferTime]]) , @"VideoTotalBufferTime",
        isNullObject([NSString stringWithFormat:@"%@",[NSNumber numberWithInt:attributes.eventattributes.articleCharacterCount]]), @"ArticleContentAmount",
        isNullObject(attributes.arbitaryinvariant.loginTimeStamp) , @"LoginTimeStamp",
        isNullObject(attributes.eventattributes.likedContent) , @"LikedContent",
        isNullObject(attributes.eventattributes.shareRetweetContent) , @"ShareRetweetContent",
        isNullObject(attributes.eventattributes.followedEntity) , @"FollowedEntity",
        isNullObject([NSString stringWithFormat:@"%@",[NSNumber numberWithInt:attributes.eventattributes.rating]]) , @"Rating",
        isNullObject(attributes.eventattributes.metaTags) , @"MobileApplicationMetaTags",
        isNullObject(attributes.eventattributes.previousView) , @"PreviousView",
        isNullObject(attributes.eventattributes.currentView) , @"CurrentView",
        isNullObject(attributes.eventattributes.destinationView) , @"DestinationView",
        isNullObject(viewpageDuration), @"ViewPageDuration",
        isNullObject(attributes.eventattributes.readArticle) , @"CommentedArticle",
        isNullObject(attributes.arbitaryinvariant.viewAccessTimeStamp), @"ViewAccessTimeStamp",
        isNullObject([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.videoattributes.videoPlayPosition]]), @"VideoPlay",
        isNullObject([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.videoattributes.videoPausePosition]]), @"VideoPause",
        isNullObject([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.videoattributes.videoSeekStart]]) , @"VideoSeekStart",
        isNullObject([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.videoattributes.videoSeekEnd]]) , @"VideoSeekEnd",
        isNullObject([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.videoattributes.videoResumePosition]]) , @"VideoResume",
        isNullObject([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.videoattributes.videoStopPosition]]) , @"VideoStop",
        isNullObject(isVideoAdClick) , @"VideoAdClick",
        isNullObject(isVideoAdComplete) , @"VideoAdComplete",
        isNullObject(isVideoAdSkipped) , @"VideoAdSkipped",
        isNullObject(isVideoAdPlay) , @"VideoAdPlay",
        isNullObject(isVideoAdError) , @"VideoAdError",
        isNullObject([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.videoattributes.videoAdTime]]) , @"VideoAdTime",
        isNullObject(attributes.videoattributes.videoTimeStamp) , @"VideoTimeStamp",
        isNullObject(attributes.videoattributes.videoType) , @"VideoType",
        isNullObject(attributes.videoattributes.videoQuality) , @"VideoQuality",
        isNullObject(attributes.videoattributes.videoCategoryID) , @"VideoCategoryId",
        isNullObject(attributes.videoattributes.videoContentID) , @"VideoContentId",
        isNullObject([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.videoattributes.videoDuration]]) , @"VideoDuration",
        isNullObject(isvideoPaused), @"VideoIsPaused",
        isNullObject(isvideoEnded), @"VideoIsEnded",
        isNullObject(videoState), @"VideoPlayerState",
        isNullObject(attributes.videoattributes.videoTitle) , @"VideoTitle",
        isNullObject(escapedVideoURL) , @"VideoURL",
        isNullObject(isvideoFullScreen), @"VideoFullScreen",
        isNullObject([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.videoattributes.videoVolume]]) , @"VideoVolume",
        isNullObject(videoSize) , @"VideoSize",
        isNullObject(attributes.audioattributes.audioCategoryID) , @"AudioCategoryId",
        isNullObject(attributes.audioattributes.audioContentID) , @"AudioContentId",
        isNullObject(attributes.audioattributes.audioConsolidatedBufferTime) , @"AudioConsolidatedBufferTime",
        isNullObject([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.audioattributes.audioBufferCount]]) ,@"AudioBuffer",
        isNullObject([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.audioattributes.audioTotalBufferTime]]) , @"AudioTotalBufferTime",
        isNullObject(attributes.audioattributes.audioTimeStamp) ,@"AudioTimeStamp",
        isNullObject(escapedAudioType) ,@"AudioType",
        isNullObject(attributes.audioattributes.audioFormat),@"AudioFormat",
        isNullObject(attributes.audioattributes.audioCodec),@"AudioCodec",
        isNullObject(audioState) , @"AudioPlayerState",
        isNullObject(isAudioEnded) , @"AudioIsEnded",
        isNullObject(isAudioPaused) ,@"AudioIsPaused",
        isNullObject([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.audioattributes.audioDuration]]) ,@"AudioDuration",
        isNullObject(attributes.audioattributes.audioTitle) ,@"AudioTitle",
        isNullObject(escapedAudioURL) ,@"AudioURL",
        isNullObject(attributes.audioattributes.artist) ,@"AudioArtist",
        isNullObject([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.audioattributes.audioVolume]]) ,@"AudioVolume",
        isNullObject([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.audioattributes.audioPlayPosition]]) ,@"AudioPlay",
        isNullObject([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.audioattributes.audioPausePosition]]) ,@"AudioPause",
        isNullObject([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.audioattributes.audioResumePosition]]) ,@"AudioResume",
        isNullObject([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.audioattributes.audioStopPosition]]) ,@"AudioStop",
        isNullObject(attributes.recommendationattributes.recoCategoryId) , @"RecoCategoryId",
        isNullObject([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.recommendationattributes.recoItemCount]]), @"RecoItemCount",
        isNullObject(attributes.recommendationattributes.recoPropertyId) , @"RecoPropertyId",
        isNullObject(attributes.recommendationattributes.recoType) , @"RecoType",
                                                 nil];
    
         NSData *attributesData = [NSJSONSerialization dataWithJSONObject:attributesDictionary options:NSJSONWritingPrettyPrinted error:&error]; // convert dictionary to data
//        NSString *policyStr = [[NSString alloc] initWithData:attributesData encoding:NSUTF8StringEncoding];
//        policyStr = [policyStr stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
//        attributesData = [policyStr dataUsingEncoding:NSUTF8StringEncoding];
    
    if (error) {
        NSLog(@"Error occured when dispatching logs to the datalake");
    } else{
        return attributesData;
    }

    return nil;
}

+(void) recoSecurityHash: (void (^)(NSString *sechash))handler{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] enableHTTPLog: [[ABSLogger initialize] displayHTTPLogs]];
        // REQUEST TOKEN
        NSDictionary *header = @{@"x-mobile-header" : [Constant generateNewMobileHeader]};
        [networking GET:prodRecoURL path:recoMobileResourceURL headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
            NSString *seccode = responseObject[@"seccode"];
            handler(seccode);
        } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
            //            [[ABSLogger initialize] setMessage:error.description];
        }];
    });
}

/* Request token for  Recommedation
 */
+(void) recoTokenRequest: (void (^)(NSString *token)) handler{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSDate *timeNow = [NSDate date];
        ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] enableHTTPLog: [[ABSLogger initialize] displayHTTPLogs]];
        // REQUEST TOKEN
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", prodRecoURL ,eventTokenURL]];
        if ([RecoAuthManager retrieveRecoSecurityHashFromUserDefault] != nil) {
            /*
             * Checking the current time if it's not exceeding the server sechash expiration date.
             * Note: The sechash will last for 60 minutes.
             * The system should request a new sechash after 60 minutes when there are no user activities or session detected.
             */
            if ([timeNow timeIntervalSinceDate:[RecoAuthManager retrieveRecoSecHashReceivedTimestamp] ] > 0) {
                /*
                 * Request a new Sechash if the current time exceed the Sechash expiration timestamp
                 */
                [self recoSecurityHash:^(NSString *sechash) {
                    NSString *post = [NSString stringWithFormat:@"targetcode=%@&grant_type=password", sechash];
                    [networking POST:url URLparameters:post success:^(NSURLSessionDataTask *task, id responseObject) {
                        NSString *token = responseObject[@"access_token"];
                        [RecoAuthManager storeRecoTokenToUserDefault:token];
                        handler(token);
                        NSDate *receivedTimestamp = [NSDate date];
                        [RecoAuthManager storeRecoTokenReceivedTimestamp:receivedTimestamp];
                    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                        //            [[ABSLogger initialize] setMessage:error.description];
                        [RecoAuthManager removeRecoSechHash];
                    }];
                }];
            }else{
                
                // Retrieving sechash via NSUserdefault
                NSString *post = [NSString stringWithFormat:@"targetcode=%@&grant_type=password", [RecoAuthManager retrieveRecoSecurityHashFromUserDefault]];
                [networking POST:url URLparameters:post success:^(NSURLSessionDataTask *task, id responseObject) {
                    NSString *token = responseObject[@"access_token"];
                    [RecoAuthManager storeRecoTokenToUserDefault:token];
                    handler(token);
                    NSDate *receivedTimestamp = [NSDate date];
                    [RecoAuthManager storeRecoTokenReceivedTimestamp:receivedTimestamp];
                } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                    //            [[ABSLogger initialize] setMessage:error.description];
                    [RecoAuthManager removeRecoSechHash];
                }];
            }
        }else{
            // Requesting fresh token
            [self recoSecurityHash:^(NSString *sechash) {
                NSString *post = [NSString stringWithFormat:@"targetcode=%@&grant_type=password", sechash];
                [networking POST:url URLparameters:post success:^(NSURLSessionDataTask *task, id responseObject) {
                    NSString *token = responseObject[@"access_token"];
                    [RecoAuthManager storeRecoTokenToUserDefault:token];
                    handler(token);
                    NSDate *receivedTimestamp = [NSDate date];
                    [RecoAuthManager storeRecoTokenReceivedTimestamp:receivedTimestamp];
                } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                    //                    [[ABSLogger initialize] setMessage:error.description];
                    [RecoAuthManager removeRecoSechHash];
                }];
            }];
        }
    });
}
//

+(void) recommendationDispatcher:(AttributeManager *) attributes{
    /*
     * Check if server token is stored in NSUserDefault and not null
     */
    if ([RecoAuthManager retrieveServerRecoTokenFromUserDefault] != nil) {
        NSDate *timeNow = [NSDate date];
        /*
         * Checking the current time if not exceed the server token expiration date.
         * Note: The server token will last for only 9 minutes.
         */
        if ([timeNow timeIntervalSinceDate:[RecoAuthManager retrieveRecoTokenExpirationTimestamp] ] > 0){
            /*
             * Request a new server token if the current time exceeded the server token expiration timestamp
             */
            [self recoTokenRequest:^(NSString *token) {
                /*
                 * Storing server token in NSUserDefault
                 */
                [RecoAuthManager storeRecoTokenToUserDefault:token];
                // update reco
                [self dispatchrecoupdate:attributes.recommendationattributes];
            }];
        }else{
            /*
             * If current time is less than the 9 minutes expiration time allowance, dispatch attributes into the data lake
             */
            [self dispatchrecoupdate:attributes.recommendationattributes];
        }
    }else{
        /*
         * If server token is null in NSUserdefault, request a new token
         */
        [self recoTokenRequest:^(NSString *token) {
            /*
             * Storing server token in NSUserDefault
             */
            [RecoAuthManager storeRecoTokenToUserDefault:token];
        }];
    }

}

+(void) dispatchrecoupdate:(RecommendationAttributes *) attributes{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] enableHTTPLog: YES];
    NSString *paramURL = [NSString stringWithFormat:@"%@%@userId=%@&categoryId=%@&digitalPropertyId=%@", prodRecoURL, recommendationUpdateURL, isNullObject(attributes.recoUserId), isNullObject(attributes.recoCategoryId), isNullObject(attributes.recoPropertyId)];

    NSURL *url = [NSURL URLWithString:[paramURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    NSError *error;
    if ([RecoAuthManager retrieveServerRecoTokenFromUserDefault] != nil) {
        NSDictionary *header = @{@"Authorization" : [NSString stringWithFormat:@"Bearer %@", [RecoAuthManager retrieveServerRecoTokenFromUserDefault]]};
        if (!error) {
            dispatch_async(queue, ^{
                [networking POST:url queryParams:nil headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
                    NSLog(@"Success - Updating recommendation");
                } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                    [RecoAuthManager removeRecoSechHash];
                    [RecoAuthManager removeRecoToken];
                    NSLog(@"Unknown error from server - Recommendation: %@", error.description);
                }];
            });
        }
    }else{
        [self recoTokenRequest:^(NSString *token) {
            NSDictionary *header = @{@"Authorization":[NSString stringWithFormat:@"Bearer %@", token != nil ? token : [RecoAuthManager retrieveServerRecoTokenFromUserDefault]]};
            [networking POST:url queryParams:nil headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
                NSLog(@"Success - Updating recommendation: %@", responseObject);
            } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"Unknown error from server - Recommendation: %@", error.description);
            }];
        }];
    }
}

// This method will return null value string if the attributes is nil or empty
static id isNullObject(id object){
    return object ?: @""; // return string "null" if object is nil and empty
}

@end
