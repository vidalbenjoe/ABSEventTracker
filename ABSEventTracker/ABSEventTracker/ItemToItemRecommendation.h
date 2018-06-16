//
//  ItemToItemRecommendation.h
//  ABSEventTracker
//
//  Created by Indra on 15/06/2018.
//  Copyright © 2018 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemToItemRecommendation : NSObject
@property(nonatomic, strong) NSString *categoryID;
@property(nonatomic, strong) NSString *contentID;
-(instancetype) initWithDictionary:(NSDictionary *) item;

@end
