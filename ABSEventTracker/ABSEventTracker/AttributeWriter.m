//
//  AttributeWriter.m
//  EventApp
//
//  Created by Benjoe Vidal on 09/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "AttributeWriter.h"
#import "ABSBigDataServiceDispatcher.h"
#import "EventAuthManager.h"
@implementation AttributeWriter

+(void) writer:(AttributeManager *) manager{
    // Do not update session when video state is playing
    if (manager.videoattributes.videostate != PLAYING) {
        [[SessionManager init] update];
    }
    // This will controll the logging transaction since it will depends on the sampled user (Ex: 499)
    if ([EventAuthManager retrieveSendFlag] == NO){
        if (manager.videoattributes.actionTaken == VIDEO_PLAYED || manager.eventattributes.actionTaken == LOAD || manager.eventattributes.actionTaken == VIDEO_ERROR) {
            // Dispatch the consolidated attributes into server
            [ABSBigDataServiceDispatcher dispatchAttribute:manager];
        }
    }else{
        // Dispatch the consolidated attributes into server
        [ABSBigDataServiceDispatcher dispatchAttribute:manager];
    }
    
}


@end
