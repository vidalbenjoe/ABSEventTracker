
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
#import "ABSLogger.h"

@implementation ABSBigDataServiceDispatcher
NSNumber *duration;
NSString *userID;

/*!
 * Method for requesting security hash. This method will return a security hash via block(handler)
 */
+(void) requestSecurityHash: (void (^)(NSString *sechash)) handler{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
//        ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] ];
        
        ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] enableHTTPLog: [[ABSLogger initialize] displayHTTPLogs]];
        
        NSLog(@"OCnstathXMobi %@", [Constant generateNewMobileHeader]);
        NSDictionary *header = @{@"x-mobile-header" : [Constant generateNewMobileHeader]};
        [networking GET:[[[AttributeManager init] propertyinvariant] url] path:eventMobileResourceURL headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
            NSString *sechash = responseObject[@"seccode"];
            handler(sechash);
            [AuthManager storeSecurityHashTouserDefault:sechash];
            NSDate *receivedTimestamp = [NSDate date];
            [AuthManager storeSechashReceivedTimestamp:receivedTimestamp];
        } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
            
            
            
            NSLog(SECHASH_ERROR_REQUEST  "%@", error.description);
//            [[ABSLogger initialize] setMessage:error.description];
            [AuthManager removeSechHash];
          
        }];
    });
}
/*
 NodeJS Token request
 */
+(void) requestNewToken: (void (^)(NSString *token))handler{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
      ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] enableHTTPLog: [[ABSLogger initialize] displayHTTPLogs]];
        // REQUEST TOKEN
        [networking GET:urlStaging path:eventTokenURL headerParameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSString *token = responseObject[@"token"];
            [AuthManager storeTokenToUserDefault:token];
            handler(token);
        } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
//            [[ABSLogger initialize] setMessage:error.description];
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
//        [[networking requestBody] setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        // REQUEST TOKEN
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [[[AttributeManager init] propertyinvariant] url] ,eventTokenURL]];
    
        if ([AuthManager retrieveSecurityHashFromUserDefault] != nil) {
            /*
             * Checking the current time if it's not exceeding the server sechash expiration date.
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
//                        [[ABSLogger initialize] setMessage:error.description];
                        [AuthManager removeSechHash];
                    }];
                }];
                
            }else{
                // Retrieving sechash via NSUserdefault
                NSString *post = [NSString stringWithFormat:@"targetcode=%@&grant_type=password", [AuthManager retrieveSecurityHashFromUserDefault]];
                [networking POST:url URLparameters:post success:^(NSURLSessionDataTask *task, id responseObject) {
                    // store the token somewhere
                    NSString *token = responseObject[@"access_token"];
                    [AuthManager storeTokenToUserDefault:token];
                    handler(token);
                    NSDate *receivedTimestamp = [NSDate date];
                    [AuthManager storeTokenReceivedTimestamp:receivedTimestamp];
                } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
//                    [[ABSLogger initialize] setMessage:error.description];
                    [AuthManager removeSechHash];
                }];
            }
        }else{
            [self requestSecurityHash:^(NSString *sechash) {
                NSString *post = [NSString stringWithFormat:@"targetcode=%@&grant_type=password", sechash];
                [networking POST:url URLparameters:post success:^(NSURLSessionDataTask *task, id responseObject) {
                    NSString *token = responseObject[@"access_token"];
                    [AuthManager storeTokenToUserDefault:token];
                    handler(token);
                    NSDate *receivedTimestamp = [NSDate date];
                    [AuthManager storeTokenReceivedTimestamp:receivedTimestamp];
                } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
//                    [[ABSLogger initialize] setMessage:error.description];
                    [AuthManager removeSechHash];
                }];
            }];
        }
    });
}

+(void) recoSecurityHash: (void (^)(NSString *sechash))handler{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] enableHTTPLog: [[ABSLogger initialize] displayHTTPLogs]];
        // REQUEST TOKEN
        [networking GET:recoURL path:recoMobileResourceURL headerParameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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
    ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] enableHTTPLog: [[ABSLogger initialize] displayHTTPLogs]];
//     [[networking requestBody] setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", recoURL ,recoTokenURL]];
   
    [self recoSecurityHash:^(NSString *sechash) {
        NSString *post = [NSString stringWithFormat:@"targetcode=%@&grant_type=password", sechash];
        [networking POST:url URLparameters:post success:^(NSURLSessionDataTask *task, id responseObject) {
            NSString *token = responseObject[@"access_token"];
            handler(token);
        } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
//            [[ABSLogger initialize] setMessage:error.description];
        }];
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

        [self requestNewToken:^(NSString *token) {
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
    if (writerAttributes != nil) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[[AttributeManager init] propertyinvariant] url],eventWriteURL]];
      ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] enableHTTPLog: [[ABSLogger initialize] displayHTTPLogs]];
        /*
         * Retrieving server token to be used in request header.
         */
        
        if ([AuthManager retrieveServerTokenFromUserDefault] != nil) {
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
        }else{
            [self requestToken:^(NSString *token) {
                NSDictionary *header = @{@"Authorization":[NSString stringWithFormat:@"Bearer %@", token != nil ? token : [AuthManager retrieveServerTokenFromUserDefault]]};
                [networking POST:url HTTPBody:writerAttributes headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
                    /*
                     * Success: Sending server response to ABSLogger.
                     */
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
        
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[[AttributeManager init] propertyinvariant] url],eventWriteURL]];
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
    duration = 0;
    
    NSString *action =  [GenericEventController convertActionTaken:attributes.genericattributes.actionTaken];
   
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
    
    NSString *videoState = [VideoAttributes convertVideoStateToString:attributes.videoattributes.videostate];
    
    NSString *audioState = [AudioAttributes convertAudioStateToString:attributes.audioattributes.audioPlayerState];
        NSString *videoSize = [NSString stringWithFormat:@"%dx%d", attributes.videoattributes.videoHeight, attributes.videoattributes.videoWidth];
    NSString *screenSize = [NSString stringWithFormat:@"%lix%li", (long)attributes.deviceinvariant.deviceScreenWidth, (long)attributes.deviceinvariant.deviceScreenHeight];
    
    NSDate *accessViewTimeStamp = [[FormatUtils dateFormatter] dateFromString:attributes.arbitaryinvariant.viewAccessTimeStamp];
    NSDate *abandonViewTimeStamp = [[FormatUtils dateFormatter] dateFromString:attributes.arbitaryinvariant.viewAbandonTimeStamp];
    
    NSMutableDictionary *attributesDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
        ObjectOrNull(userID) , @"GigyaId",
        ObjectOrNull(attributes.userattributes.ssoID) , @"SSOId",
        ObjectOrNull(attributes.deviceinvariant.deviceFingerprint) , @"FingerPrintId",
        ObjectOrNull([[AuthManager retrievedFingerPrintID] isEqualToString:attributes.deviceinvariant.deviceFingerprint] ? attributes.deviceinvariant.deviceFingerprint : [AuthManager retrievedFingerPrintID]) , @"PreviousFingerPrintId",
        ObjectOrNull(action), @"ActionTaken",
        ObjectOrNull(attributes.propertyinvariant.siteDomain) , @"SiteDomain",
        ObjectOrNull(attributes.propertyinvariant.applicationName) , @"ApplicationName",
        ObjectOrNull(attributes.propertyinvariant.bundleIdentifier) , @"ApplicationUniqueId",
        ObjectOrNull(attributes.deviceinvariant.deviceOS), @"DeviceOs",
        ObjectOrNull(attributes.deviceinvariant.deviceType) , @"MobileDevice",
        ObjectOrNull(screenSize)  , @"ScreenSize",
        ObjectOrNull(attributes.deviceinvariant.deviceType) , @"DeviceType",
        ObjectOrNull(attributes.propertyinvariant.bundleIdentifier) , @"PageURL",
        ObjectOrNull([DeviceInfo deviceConnectivity]) , @"ConnectivityType",
        ObjectOrNull(attributes.arbitaryinvariant.applicationLaunchTimeStamp == nil ? [CacheManager retrieveApplicationLoadTimestamp] : attributes.arbitaryinvariant.applicationLaunchTimeStamp), @"ApplicationLoadTimeStamp",
        ObjectOrNull(attributes.arbitaryinvariant.applicationAbandonTimeStamp), @"ApplicationAbandonTimeStamp",
        ObjectOrNull(attributes.arbitaryinvariant.postCommentTimeStamp), @"WritingEventTimeStamp",
        ObjectOrNull(attributes.arbitaryinvariant.logoutTimeStamp), @"LogoutTimeStamp",
        ObjectOrNull(attributes.arbitaryinvariant.searchTimeStamp), @"SearchTimeStamp",
        ObjectOrNull([NSString stringWithFormat:@"%@",attributes.session.sessionID]), @"BigdataSessionId",
        ObjectOrNull([FormatUtils getCurrentTimeAndDate:attributes.session.sessionStart]), @"SessionStartTimeStamp",
        ObjectOrNull([FormatUtils getCurrentTimeAndDate:attributes.session.sessionEnd]), @"SessionEndTimeStamp",
        ObjectOrNull(attributes.userattributes.firstName != nil ? attributes.userattributes.firstName : [UserAttributes retrieveFirstName] ) , @"FirstName",
        ObjectOrNull(attributes.userattributes.middleName == nil ? attributes.userattributes.middleName  : [UserAttributes retrieveMiddleName])  , @"MiddleName",
        ObjectOrNull(attributes.userattributes.lastName != nil ? attributes.userattributes.lastName : [UserAttributes retrieveLastName] ) , @"LastName",
        ObjectOrNull(attributes.eventattributes.clickedContent) , @"ClickedContent",
        ObjectOrNull([NSString stringWithFormat:@"%@", [NSNumber numberWithFloat:attributes.eventattributes.longitude]]), @"Longitude",
        ObjectOrNull([NSString stringWithFormat:@"%@", [NSNumber numberWithFloat:attributes.eventattributes.latitute]]) , @"Latitude",
        ObjectOrNull(attributes.eventattributes.searchQuery) , @"QueryString",
        ObjectOrNull(attributes.eventattributes.readArticle) , @"ReadArticle",
        ObjectOrNull([NSString stringWithFormat:@"%@", duration]), @"ReadingDuration",
        ObjectOrNull(attributes.eventattributes.articleAuthor) , @"ArticleAuthor",
        ObjectOrNull(attributes.eventattributes.articlePostDate) , @"ArticlePostDate",
        ObjectOrNull(attributes.eventattributes.commentContent) , @"CommentContent",
        ObjectOrNull(attributes.videoattributes.videoConsolidatedBufferTime) , @"VideoConsolidatedBufferTime",
        ObjectOrNull([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.videoattributes.videoBufferCount]]) , @"VideoBuffer",
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
        ObjectOrNull(abandonViewTimeStamp != nil && accessViewTimeStamp !=nil ? accessViewTimeStamp < abandonViewTimeStamp ? [NSString stringWithFormat:@"%@",[NSNumber numberWithLong: [FormatUtils timeDifferenceInSeconds:accessViewTimeStamp endTime:abandonViewTimeStamp]]] : nil : nil), @"ViewPageDuration",
        ObjectOrNull(attributes.eventattributes.readArticle) , @"CommentedArticle",
        ObjectOrNull(attributes.arbitaryinvariant.viewAccessTimeStamp), @"ViewAccessTimestamp",
        ObjectOrNull([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.videoattributes.videoPlayPosition]]), @"VideoPlay",
        ObjectOrNull([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.videoattributes.videoPausePosition]]), @"VideoPause",
        ObjectOrNull([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.videoattributes.videoSeekStart]]) , @"VideoSeekStart",
        ObjectOrNull([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.videoattributes.videoSeekEnd]]) , @"VideoSeekEnd",
        ObjectOrNull([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.videoattributes.videoResumePosition]]) , @"VideoResume",
        ObjectOrNull([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.videoattributes.videoStopPosition]]) , @"VideoStop",
        ObjectOrNull(attributes.videoattributes.videoAdClick) , @"VideoAdClick",
        ObjectOrNull(attributes.videoattributes.videoAdComplete) , @"VideoAdComplete",
        ObjectOrNull(attributes.videoattributes.videoAdSkipped) , @"VideoAdSkipped",
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
        ObjectOrNull(attributes.audioattributes.audioCategoryID) , @"AudioCategoryId",
        ObjectOrNull(attributes.audioattributes.audioContentID) , @"AudioContentId",
        ObjectOrNull(attributes.audioattributes.audioConsolidatedBufferTime) , @"AudioConsolidatedBufferTime",
        ObjectOrNull([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.audioattributes.audioBufferCount]]) ,@"AudioConsolidatedBufferTime",
        ObjectOrNull(attributes.audioattributes.audioTimeStamp) ,@"AudioTimesTamp",
        ObjectOrNull(attributes.audioattributes.audioType) ,@"AudioType",
        ObjectOrNull(attributes.audioattributes.audioFormat) ,@"AudioFormat",
        ObjectOrNull(attributes.audioattributes.audioCodec) ,@"AudioCodec",
        ObjectOrNull(audioState) ,@"AudioPlayerState",
        ObjectOrNull(isAudioEnded) ,@"AudioIsEnded",
        ObjectOrNull(isAudioPaused) ,@"AudioIsPaused",
        ObjectOrNull([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.audioattributes.audioDuration]]) ,@"AudioDuration",
        ObjectOrNull(attributes.audioattributes.audioTitle) ,@"AudioTitle",
        ObjectOrNull(attributes.audioattributes.audioURL) ,@"AudioURL",
        ObjectOrNull(attributes.audioattributes.artist) ,@"AudioArtist",
        ObjectOrNull([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.audioattributes.audioVolume]]) ,@"AudioVolume",
        ObjectOrNull([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.audioattributes.audioPlayPosition]]) ,@"AudioPlay",
        ObjectOrNull([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.audioattributes.audioPausePosition]]) ,@"AudioPause",
        ObjectOrNull([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.audioattributes.audioResumePosition]]) ,@"AudioResume",
        ObjectOrNull([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.audioattributes.audioStopPosition]]) ,@"AudioStop",
        ObjectOrNull([NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:attributes.audioattributes.audioStopPosition]]) ,@"AudioBufferPosition",
                                                 nil];
    
         NSData *attributesData = [NSJSONSerialization dataWithJSONObject:attributesDictionary options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"Error occured when dispatching logs to the datalake");
    } else{
        return attributesData;
    }

    return nil;
}

// This method will return empty string if the attributes is nil or empty
static id ObjectOrNull(id object){
    return object ?: @"null";
}

@end
