//
//  ABSBigDataServiceDispatcher.h
//  EventApp
//
//  Created by Benjoe Vidal on 07/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AttributeManager.h"
#import "EventCallBack.h"
#import "ArbitaryVariant.h"
@interface ABSBigDataServiceDispatcher : NSObject<EventCallBack>

+(void)requestToken: (void (^)(NSString *token))handler;
+(void) dispatchAttribute:(AttributeManager *) attributes;

@end
