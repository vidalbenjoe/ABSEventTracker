//
//  AttributeWriter.h
//  EventApp
//
//  Created by Benjoe Vidal on 09/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "AttributeManager.h"
@interface AttributeWriter : NSObject
@property(nonatomic) AttributeManager *manager;
@property(nonatomic) ActionTaken *action;
+(void) writer:(AttributeManager *) manager;
@end
