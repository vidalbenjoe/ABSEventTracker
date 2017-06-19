//
//  ArbitaryVariant.h
//  EventApp
//
//  Created by Flydubai on 25/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ArbitaryBuilder;
@interface ArbitaryVariant : NSObject

@property(nonatomic, weak) NSString *applicationAbandonTimeStamp;
@property(nonatomic, strong, retain) NSString *applicationLaunchTimeStamp;
@property(nonatomic, weak) NSString *postCommentTimeStamp;
@property(nonatomic, weak) NSString *logoutTimeStamp;
@property(nonatomic, weak) NSString *searchTimeStamp;

-(NSString*) getLaunchTime;
+(ArbitaryVariant*) init;
+(instancetype) makeWithBuilder:(void (^) (ArbitaryBuilder *)) updateBlock;
-(instancetype) initTimeStampWithBuilder:(ArbitaryBuilder *) builder;
-(instancetype) update:(void(^)(ArbitaryBuilder *)) updateBlock;
-(instancetype) build;

@end

@interface ArbitaryBuilder : NSObject
@property(nonatomic, assign) NSString *applicationAbandonTimeStamp;
@property(nonatomic, assign) NSString *applicationLaunchTimeStamp;
@property(nonatomic, strong) NSString *postCommentTimeStamp;
@property(nonatomic, strong) NSString *logoutTimeStamp;
@property(nonatomic, strong) NSString *searchTimeStamp;
-(instancetype) init;

@end
