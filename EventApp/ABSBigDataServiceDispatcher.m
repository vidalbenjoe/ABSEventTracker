//
//  ABSBigDataServiceDispatcher.m
//  EventApp
//
//  Created by Flydubai on 07/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//  Act as a bridge to API Call ABSNetworking

#import "ABSBigDataServiceDispatcher.h"
#import "Constants.h"
#import "ABSNetworking.h"
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

+(void) requestSecurityhash: (void (^)(NSString *sechash))handler{
    
    
    ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSDictionary *header = @{@"x-mobile-header" : [self generateNewMobileHeader]};
    [networking GET:eventAppsBaseURL path:eventMobileResourceURL headerParameters:header success:^(NSURLSessionDataTask *task, id responseObject) {
       NSLog(@"GET-RESPONSE: %@", [responseObject description]);
        NSString *sechash = responseObject[@"seccode"];
            handler(sechash);
    } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

+(void) requestToken{
    [self requestSecurityhash:^(NSString *sechash) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
        ABSNetworking *networking = [ABSNetworking initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [[networking requestBody] setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        // REQUEST TOKEN
        NSString *post = [NSString stringWithFormat:@"targetcode=%@&grant_type=password",sechash];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", eventAppsBaseURL,eventTokenURL]];
        [networking POST:url URLparameters:post success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"POST-RESPONSE: %@", [responseObject description]);
            // store the token somewhere
            NSString *token = responseObject[@"access_token"];
            NSLog(@"Tukudwen: %@",token );
        } errorHandler:^(NSURLSessionDataTask *task, NSError *error) {
            
            }];
        });
    }];
    
}
@end
