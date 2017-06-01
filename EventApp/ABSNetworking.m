//
//  ABSNetworking.m
//  EventApp
//
//  Created by Flydubai on 01/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "ABSNetworking.h"
#import "AttributeManager.h"
@implementation ABSNetworking

-(NSString *) requestNewToken{
    NSString *token = @"";
    //save to NSUSERDeFAult
    

    return token;
}

-(NSString *) generateMobileHeader{
    NSData *nsdata = [[PropertyEventSource getBundleIdentifier]
                      dataUsingEncoding:NSUTF8StringEncoding];
    // Get NSString from NSData object in Base64
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    // Print the Base64 encoded string
    NSLog(@"Encoded: %@", base64Encoded);
    return base64Encoded;
}

-(instancetype) eventDispatcher:(AttributeManager *) attributes{
    NSURL *url = [NSURL URLWithString:eventWriteURL];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    // Parse requires HTTP headers for authentication. Set them before creating your NSURLSession
    [config setHTTPAdditionalHeaders:@{@"x-mobile-header":[self generateMobileHeader],
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


@end
