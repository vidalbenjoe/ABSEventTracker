//
//  ABSNetworking.h
//  EventApp
//
//  Created by Flydubai on 01/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "AttributeManager.h"
@interface ABSNetworking : NSURLProtocol

-(instancetype) eventDispatcher:(AttributeManager *) attributes;

@end
