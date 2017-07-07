//
//  Popular.h
//  ABSEventTracker
//
//  Created by Benjoe Vidal on 06/07/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Popular : NSObject

@property (nonatomic, strong) NSString *contentSubID;
@property (nonatomic) double rating;
@property (nonatomic, strong) NSString *contentName;
@property (nonatomic, strong) NSString *contentCategorySubID;
@property (nonatomic, strong) NSString *contentCategoryName;

@end
