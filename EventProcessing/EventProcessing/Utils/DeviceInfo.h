//
//  DeviceInfo.h
//  EventProcessing
//
//  Created by Benjoe Vidal on 16/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>


// MARK: Enums

/// The size scale to decide how you want to obtain size information
///
/// - bytes:     In bytes
/// - kilobytes: In kilobytes
/// - megabytes: In megabytes
/// - gigabytes: In gigabytes

typedef NS_ENUM (NSInteger, deviceSizeScale) {
    BYTES,
    KILOBYTES,
    MEGABYTES,
    GIGABYTES
} scaleSize;

/// The battery state
///
/// - unknown:   State unknown
/// - unplugged: Battery is not plugged in
/// - charging:  Battery is charging
/// - full:      Battery is full charged

typedef enum{
    UNKNOWN,
    UNPLUGGED,
    CHARGING,
    FULL
}batteryState;


typedef NS_ENUM(NSInteger, DeviceVersion){
    UnknownDevice     = 0,
    Simulator         = 1,
    
    iPhone4           = 3,
    iPhone4S          = 4,
    iPhone5           = 5,
    iPhone5C          = 6,
    iPhone5S          = 7,
    iPhone6           = 8,
    iPhone6Plus       = 9,
    iPhone6S          = 10,
    iPhone6SPlus      = 11,
    iPhone7           = 12,
    iPhone7Plus       = 13,
    iPhoneSE          = 14,
    
    iPad1             = 15,
    iPad2             = 16,
    iPadMini          = 17,
    iPad3             = 18,
    iPad4             = 19,
    iPadAir           = 20,
    iPadMini2         = 21,
    iPadAir2          = 22,
    iPadMini3         = 23,
    iPadMini4         = 24,
    iPadPro12Dot9Inch = 25,
    iPadPro9Dot7Inch  = 26,
    iPad5             = 27,
    
    iPodTouch1Gen     = 28,
    iPodTouch2Gen     = 29,
    iPodTouch3Gen     = 30,
    iPodTouch4Gen     = 31,
    iPodTouch5Gen     = 32,
    iPodTouch6Gen     = 33
};

/// Enumeration representing the different stage of the development
///
/// - team:        The team configuration is used only by the dev team and is not shared neither with the project managers or accounts
/// - development: The development configuration, usually used during the dev phase
/// - stage:       The stage configuration, usually used during the first deliver to the client
/// - production:  The production configuration, usually used when the product has to be finally delivered to the client

typedef enum{
    TEAM,
    DEVELOPMENT,
    STAGING,
    PRODUCTION
}AppConfiguration;


@interface DeviceInfo : NSObject

+ (DeviceVersion) deviceVersion;
+ (NSString*) deviceNameForVersion: (DeviceVersion) deviceVersion;
-(NSString*) publicMethod;

-(id) init;

+(id) sharedInstance;

@end
