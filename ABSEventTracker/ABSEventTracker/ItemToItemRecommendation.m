//
//  ItemToItemRecommendation.m
//  ABSEventTracker
//
//  Created by Indra on 15/06/2018.
//  Copyright © 2018 ABS-CBN. All rights reserved.
//

#import "ItemToItemRecommendation.h"

@implementation ItemToItemRecommendation
-(instancetype) initWithDictionary:(NSDictionary *) item{
    if (self = [super init]) {
        self.categoryID = [item valueForKey:@"categoryID"];
        self.contentID = [item valueForKey:@"contentID"];
    }
    return self;
}

@end
