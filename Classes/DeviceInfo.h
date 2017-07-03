//
//  DeviceInfo.h
//  EventProcessing
//
//  Created by Benjoe Vidal on 16/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DeviceIdiom){
    UNSPECIFIED         = 0,
    PHONE               = 1,
    PAD                 = 2,
    TV                  = 3,
    CARPLAY             = 4
};


typedef NS_ENUM(NSInteger, DeviceVersion){
    UnknownDevice     = 0,
    Simulator         = 1,
    
    iPhone4           = 3,
    iPhone4S          = 4,
    iPhone5           = 5,
    iPhone5C          = 6,
    iPhone5S
    = 7,
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

@interface DeviceInfo : NSObject

+ (DeviceVersion) deviceVersion;
+ (NSString*) deviceNameForVersion: (DeviceVersion) deviceVersion;

//Hardware
+(NSString*) deviceName;
+(NSString*) systemName;
+(NSString*) systemVersion;
+(NSString*) localizeModel;
+(NSString*) deviceType;
+(NSString*) userInterfaceIdiom: (DeviceIdiom) idiom;
+(NSString*) identifierForVendor;

+(NSString*) getUserInterfaceIdiom;
+(NSInteger) screenWidth;
+(NSInteger) screenHeight;

//+(NSInteger*) displayDensity;

+(NSInteger) physicalMemory;
+(NSInteger) processorNumber;

+(NSString *) deviceUUID;
+(NSString *) deviceIDFA;

////Disk
+(NSString*) totalSpace;
+ (NSString *)ICCID;
////Carrier
//+(BOOL) isAllowVOIP;
//+(NSInteger*)mobileCountryCode;
//+(NSInteger*)carrierName;
//+(NSInteger*)networkCountryCode;
//

//Network
+(NSString *) deviceConnectivity;

////identifier
//+(NSString*) deviceIdentifierIDFA;

+(id) sharedInstance;


@end
