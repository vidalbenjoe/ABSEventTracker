//
//  Popular.m
//  ABSEventTracker
//
//  Created by Benjoe Vidal on 06/07/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "Popular.h"
@implementation Popular
-(instancetype) initWithDictionary:(NSDictionary *) item{
    if (self = [super init]) {
        self.contentSubID           = [item valueForKey:@"contentSubID"];
        self.ratings                = [[item valueForKey:@"rating"] doubleValue];
        self.contentName            = [item valueForKey:@"contentName"];
        self.contentCategorySubID   = [item valueForKey:@"contentCategorySubID"];
        self.contentCategoryName    = [item valueForKey:@"contentCategoryName"];
    }
    return self;
}
@end
