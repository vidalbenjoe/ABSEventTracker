//
//  AuthManager.h
//  EventApp
//
//  Created by Benjoe Vidal on 07/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthManager : NSObject
+(void) storeTokenToUserDefault: (NSString *) value;
+(void) storeSecurityHashTouserDefault: (NSString *) value;
+(NSString *) retrieveServerTokenFromUserDefault;
+(NSString *) retrieveSecurityHashFromUserDefault;
@end
