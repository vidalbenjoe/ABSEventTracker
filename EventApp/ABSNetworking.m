//
//  ABSNetworking.m
//  EventApp
//
//  Created by Benjoe Vidal on 01/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "ABSNetworking.h"
#import "AttributeManager.h"
#import "Constants.h"
@implementation ABSNetworking

-(NSString *) requestNewToken{
    //GET MOBILEDATA SOURCE FIRST
    // GET TOKEN
    //WRITE [NSUserDefault]
    
    
    NSString *token = @"";
    //save to NSUSERDeFAult
    
    
    return token;
}

-(void) requestSecurityHash{
    
}
+(NSString *) generateMobileHeader{
    NSString *bundleIdentifier = [NSString stringWithFormat:@"{\"packageNdame\" : \"%@\"}", I_WANT_TV_ID];
    NSData* data=[bundleIdentifier dataUsingEncoding:NSUTF8StringEncoding];
    // Get NSString from NSData object in Base64
    NSString *base64Encoded = [data base64EncodedStringWithOptions:0];
    // Print the Base64 encoded string
    NSLog(@"Encoded: %@", base64Encoded);
    [self requestHeader:base64Encoded];
    return base64Encoded;
}

+(void) requestHeader: (NSString *) base{
    //bfdelossantos@skycable.com

    [self getJsonResponse:eventAppsBaseURL success:^(NSDictionary *responseDict) {
        NSLog(@"%@",responseDict);
    } failure:^(NSError *error) {
        // error handling here ...
    }];
    
    NSURL *url = [NSURL URLWithString:eventAppsBaseURL];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    // Parse requires HTTP headers for authentication. Set them before creating NSURLSession
    [config setHTTPAdditionalHeaders:@{@"x-mobile-header": base}];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = GET;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        
        NSLog(@"SUC: %ld",(long)[httpResponse statusCode]);
        if ([response respondsToSelector:@selector(statusCode)]) {
            switch ([(NSHTTPURLResponse *) response statusCode]) {
                case SUCCESS:
                    //SAVE TO NSUSERDEFAULT
                    NSLog(@"Status: success");
                    break;
                    
                case UNAUTHORIZE:
                    NSLog(@"Status: anauthorize");
                    // Remind the user to update the TOKEN Key
                    break;
                    
                case BAD_REQUEST:
                    NSLog(@"Status: badrequest");
                    break;
                    
                case INTERNAL_SERVER_ERROR:
                    NSLog(@"Status: internalerror");
                    break;
                    
                case NOT_FOUND:
                    NSLog(@"Status: not found");
                    break;
                    
                default:
                    break;
            }
        }
        
        
    }];
    
    
    [dataTask resume];

    
}

-(instancetype) eventDispatcher:(AttributeManager *) attributes{
    NSURL *url = [NSURL URLWithString:eventWriteURL];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    // Parse requires HTTP headers for authentication. Set them before creating your NSURLSession
    [config setHTTPAdditionalHeaders:@{@"x-mobile-header":@"",
                                       @"authorization":@"",
                                       @"Content-Type": @"application/json"}];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    // 2
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    
//    NSDictionary *dictionary = @{@"story": [[attributes eventattributes] clickedContent],
//                                 @"story": [[attributes eventattributes] clickedContent]};
    
    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                         @"story", [[attributes eventattributes] clickedContent],
                         nil];

    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary
                                                   options:kNilOptions error:&error];
    if (!error) {
        // 4
        NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
           fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
               // Check to make sure the server didn't respond with a "Not Authorized"
               if ([response respondsToSelector:@selector(statusCode)]) {
                   if ([(NSHTTPURLResponse *) response statusCode] == 401) {
                       dispatch_async(dispatch_get_main_queue(), ^{
                           // Remind the user to update the API Key
                           //
                           [self requestNewToken];
                           return;
                       });
                   }else if ([(NSHTTPURLResponse *) response statusCode] == 500) {
                       dispatch_async(dispatch_get_main_queue(), ^{
                           // Remind the user to update the API Key
                           
                           return;
                       });
                   }
               }
               if (!error) {
                   // Data was created, we leave it to you to display all of those tall tales!
                   dispatch_async(dispatch_get_main_queue(), ^{
                       
                   });
                   
               } else {
                   NSLog(@"DOH");
               }
           }];
        // 5
        [uploadTask resume];
        
    }
    return self;
}


+(void)getJsonResponse:(NSString *)urlStr success:(void (^)(NSDictionary *responseDict))success failure:(void(^)(NSError* error))failure
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // Asynchronously API is hit here
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                NSLog(@"%@",data);
                                                if (error)
                                                    failure(error);
                                                else {
                                                    NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                    NSLog(@"%@",json);
                                                    success(json);
                                                }
                                            }];
    [dataTask resume];    // Executed First
}


@end
