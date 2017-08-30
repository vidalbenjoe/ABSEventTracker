//
//  ItemToItem.h
//  ABSEventTracker
//
//  Created by Benjoe Vidal on 29/08/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemToItem : NSObject
@property(nonatomic, strong) NSString *categoryID;
@property(nonatomic, strong) NSString *contentID;
@property(nonatomic) double distance;

-(instancetype) initWithDictionary:(NSDictionary *) item;
@end
