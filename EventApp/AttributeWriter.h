//
//  AttributeWriter.h
//  EventApp
//
//  Created by Flydubai on 09/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AttributeManager.h"
@interface AttributeWriter : NSObject
@property(nonatomic) AttributeManager *manager;
+(void) writer:(AttributeManager *) manager;
@end
