//
//  RecommendationAttributes.h
//  ABSEventTracker
//
//  Created by Indra on 19/10/2018.
//  Copyright © 2018 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@class RecommendationBuilder;
@interface RecommendationAttributes : NSObject
@property(nonatomic, copy, readonly) NSString *userId;
@property(nonatomic, copy, readonly) NSString *categoryId;
@property(nonatomic, copy, readonly) NSString *digitalPropertyId;

+(instancetype) makeWithBuilder:(void (^) (RecommendationBuilder *)) updateBlock;
-(instancetype) initWithBuilder:(RecommendationBuilder *) builder;
-(instancetype) update:(void(^)(RecommendationBuilder *)) updateBlock;
+(instancetype) sharedInstance;
-(instancetype) build;

@end

@interface RecommendationBuilder : NSObject
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *categoryId;
@property(nonatomic, copy) NSString *digitalPropertyId;
@end

NS_ASSUME_NONNULL_END
