//
//  ABSBigDataServiceDispatcher.h
//  EventApp
//
//  Created by Benjoe Vidal on 07/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AttributeManager.h"
@interface ABSBigDataServiceDispatcher : NSObject
+(void)requestToken: (void (^)(NSString *token))handler;
+(void) dispatchAttribute:(AttributeManager *) attributes;
@end
