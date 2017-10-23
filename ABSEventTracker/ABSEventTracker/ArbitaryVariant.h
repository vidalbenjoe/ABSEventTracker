//
//  TimeVariant.h
/**********************************************************************
 **                                                                  **
 **                                                                  **
 **                        ABSEventTracker                           **
 **                   Created by Benjoe Vidal                        **
 **          Copyright © 2017 ABS-CBN. All rights reserved.          **
 **                                                                  **
 **                                                                  **
 **                                                                  **
 **********************************************************************
 */
#import <Foundation/Foundation.h>

@class ArbitaryBuilder;
@interface ArbitaryVariant : NSObject

@property(nonatomic, weak) NSString *applicationAbandonTimeStamp;
@property(nonatomic, weak) NSString *applicationLaunchTimeStamp;
@property(nonatomic, weak) NSString *postCommentTimeStamp;
@property(nonatomic, weak) NSString *loginTimeStamp;
@property(nonatomic, weak) NSString *logoutTimeStamp;
@property(nonatomic, weak) NSString *searchTimeStamp;
@property(nonatomic, weak) NSDate *viewAccessTimeStamp;
@property(nonatomic, weak) NSDate *viewAbandonTimeStamp;
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
@property(nonatomic, strong) NSString *loginTimeStamp;
@property(nonatomic, strong) NSString *logoutTimeStamp;
@property(nonatomic, strong) NSString *searchTimeStamp;
@property(nonatomic, strong) NSDate *viewAccessTimeStamp;
@property(nonatomic, strong) NSDate *viewAbandonTimeStamp;
-(instancetype) init;

@end
