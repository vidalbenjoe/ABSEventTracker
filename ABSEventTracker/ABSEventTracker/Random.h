//
//  Random.h
//  ABSEventTracker
//
//  Created by Benjoe Vidal on 6/26/20.
//  Copyright © 2020 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Random : NSObject
@property (nonatomic, assign) NSInteger minValue;
@property (nonatomic, assign) NSInteger maxValue;
@property (nonatomic, assign) NSInteger targetValue;
@end

NS_ASSUME_NONNULL_END
