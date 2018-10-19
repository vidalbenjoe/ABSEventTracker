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

+(void) writer:(AttributeManager *) manager{
    // Do not update session when video state is playing
    if (manager.videoattributes.videostate != PLAYING) {
        [[SessionManager init] update];
    }
    // Dispatch the consolidated attributes into server
    [ABSBigDataServiceDispatcher dispatchAttribute:manager];
}

+(void) recommendationWriter:(AttributeManager *)manager{
    [ABSBigDataServiceDispatcher recommendationDispatcher: manager];
}


@end
