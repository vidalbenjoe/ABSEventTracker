//
//  UserToItem.m
//  ABSEventTracker
//
//  Created by Benjoe Vidal on 30/08/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "UserToItem.h"

@implementation UserToItem

-(instancetype) initWithDictionary:(NSDictionary *) item{
    if (self = [super init]) {
        self.categoryID = [item valueForKey:@"categoryID"];
        self.contentID = [item valueForKey:@"contentID"];
    }
    return self;
}

@end
