//
//  AttributeWriter.m
//  EventApp
//
//  Created by Flydubai on 09/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "AttributeWriter.h"
#import "ABSBigDataServiceDispatcher.h"
@implementation AttributeWriter
@synthesize manager;
+(void) writer:(AttributeManager *) manager{
    [ABSBigDataServiceDispatcher dispatchAttribute:manager];
}

@end
