//
//  DeviceInfo.h
//  EventProcessing
//
//  Created by Benjoe Vidal on 16/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enumerations.h"
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

//
////Sensors
//+(BOOL) isAccelometerAvailable;
//+(BOOL) isGyroAvailable;
//+(BOOL) isMagnetometerAvailable;
//+(BOOL) isDeviceMotionAvailable;
//
////Disk
//+(NSString*) availableSpace;
//+(NSString*) totalSpace;
//+(NSString*) usedSpace;
//
////Carrier
//+(BOOL) isAllowVOIP;
//+(NSInteger*)mobileCountryCode;
//+(NSInteger*)carrierName;
//+(NSInteger*)networkCountryCode;
//
////identifier
//+(NSString*) deviceIdentifierIDFA;

+(id) sharedInstance;


@end
