//
//  DeviceInvariant.h
//  EventApp
//
//  Created by Benjoe Vidal on 24/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInvariant : NSObject

@property(nonatomic, assign) NSString *deviceFingerprint;
@property(nonatomic, assign) NSString *deviceOS;
@property(nonatomic, assign) NSString *deviceType;
@property(nonatomic) float deviceScreenWidth;
@property(nonatomic) float deviceScreenHeight;

@end
