//
//  DeviceInvariant.h
//  EventApp
/**********************************************************************
 **                                                                  **
 **                                                                  **
 **                        ABSEventTracker                           **
 **            Created by Benjoe Vidal on 24/05/2017.                **
 **          Copyright © 2017 ABS-CBN. All rights reserved.          **
 **                                                                  **
 **                                                                  **
 **                                                                  **
 **********************************************************************/
#import <Foundation/Foundation.h>
@class DeviceInvariantBuilder;
@interface DeviceInvariant : NSObject

@property(nonatomic, copy, readonly) NSString *deviceFingerprint;
@property(nonatomic, copy, readonly) NSString *deviceOS;
@property(nonatomic, copy, readonly) NSString *deviceType;
@property(nonatomic, readonly) NSInteger deviceScreenWidth;
@property(nonatomic, readonly) NSInteger deviceScreenHeight;
@property(nonatomic, readonly) NSString *appversionBuildRelease;

+(instancetype) makeWithBuilder:(void (^) (DeviceInvariantBuilder *)) updateBlock;
-(instancetype) initWithBuilder:(DeviceInvariantBuilder *) builder;
-(instancetype) update:(void(^)(DeviceInvariantBuilder *)) updateBlock;
-(instancetype) build;

@end
@interface DeviceInvariantBuilder : NSObject
@property(nonatomic, assign) NSString *deviceFingerprint;
@property(nonatomic, assign) NSString *deviceOS;
@property(nonatomic, strong) NSString *deviceType;
@property(nonatomic) NSInteger deviceScreenWidth;
@property(nonatomic) NSInteger deviceScreenHeight;
@property(nonatomic) NSString *appversionBuildRelease;
-(instancetype) init;

@end








