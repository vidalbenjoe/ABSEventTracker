//
//  RecommendationAttributes.h
//  ABSEventTracker
//
//  Created by Indra on 19/10/2018.
//  Copyright © 2018 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GenericEventController.h"
NS_ASSUME_NONNULL_BEGIN
@class RecommendationBuilder;
@interface RecommendationAttributes : NSObject
@property(nonatomic) ActionTaken actionTaken;
@property(nonatomic, copy, readonly) NSString *recoCategoryId;
@property(nonatomic) NSInteger recoItemCount;
@property(nonatomic, copy, readonly) NSString *recoPropertyId;
@property(nonatomic, copy, readonly) NSString *recoType;

+(instancetype) makeWithBuilder:(void (^) (RecommendationBuilder *)) updateBlock;
-(instancetype) initWithBuilder:(RecommendationBuilder *) builder;
-(instancetype) update:(void(^)(RecommendationBuilder *)) updateBlock;
+(instancetype) sharedInstance;
-(instancetype) build;

@end

@interface RecommendationBuilder : NSObject
@property(assign, nonatomic) ActionTaken actionTaken;
@property(nonatomic, copy) NSString *recoCategoryId;
@property(nonatomic) NSInteger recoItemCount;
@property(nonatomic, copy) NSString *recoPropertyId;
@property(nonatomic, copy) NSString *recoType;
@end

NS_ASSUME_NONNULL_END
