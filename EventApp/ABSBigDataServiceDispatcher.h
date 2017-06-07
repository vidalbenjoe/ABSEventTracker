//
//  ABSBigDataServiceDispatcher.h
//  EventApp
//
//  Created by Flydubai on 07/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABSBigDataServiceDispatcher : NSObject
+(NSString *) generateNewMobileHeader;
+(void) requestToken;
@end
