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

@property(nonatomic, strong) NSString *applicationAbandonTimeStamp;
@property(nonatomic, retain) NSString *applicationLaunchTimeStamp;
@property(nonatomic, retain) NSString *postCommentTimeStamp;
@property(nonatomic, retain) NSString *loginTimeStamp;
@property(nonatomic, retain) NSString *logoutTimeStamp;
@property(nonatomic, retain) NSString *searchTimeStamp;
@property(nonatomic, retain) NSString *viewAccessTimeStamp;
@property(nonatomic, retain) NSString *viewAbandonTimeStamp;
@property(nonatomic, retain) NSString *videoBufferTime;
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
@property(nonatomic, strong) NSString *viewAccessTimeStamp;
@property(nonatomic, strong) NSString *viewAbandonTimeStamp;
@property(nonatomic, strong) NSString *videoBufferTime;
-(instancetype) init;

@end
