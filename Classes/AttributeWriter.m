//
//  AttributeWriter.m
//  EventApp
//
//  Created by Benjoe Vidal on 09/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "AttributeWriter.h"
#import "ABSBigDataServiceDispatcher.h"
@implementation AttributeWriter
@synthesize manager;
+(void) writer:(AttributeManager *) manager{
    [[SessionManager init] update];
    [ABSBigDataServiceDispatcher dispatchAttribute:manager];
}

@end
