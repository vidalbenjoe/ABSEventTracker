//
//  ItemToItem.m
//  ABSEventTracker
//
//  Created by Benjoe Vidal on 29/08/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "ItemToItem.h"

@implementation ItemToItem

-(instancetype) initWithDictionary:(NSDictionary *) item{
    if (self = [super init]) {
        self.categoryID = [item valueForKey:@"categoryID"];
        self.contentID = [item valueForKey:@"contentID"];
//        self.distance = [[item valueForKeyPath:@"distance"] doubleValue];
    }
    return self;
}

@end
