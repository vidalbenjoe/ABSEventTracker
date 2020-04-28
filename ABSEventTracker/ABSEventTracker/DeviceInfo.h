//
//  DeviceInfo.h
/**********************************************************************
 **                                                                  **
 **                                                                  **
 **                        ABSEventTracker                           **
 **            Created by Benjoe Vidal on 16/05/2017.                **
 **          Copyright © 2017 ABS-CBN. All rights reserved.          **
 **                                                                  **
 **                                                                  **
 **                                                                  **
 **********************************************************************/

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DeviceIdiom){
    UNSPECIFIED         = 0,
    PHONE               = 1,
    PAD                 = 2,
    TV                  = 3,
    CARPLAY             = 4
};

@interface DeviceInfo : NSObject


//Hardware
+(NSString*) deviceStringName;

+(NSString*) deviceName;
+(NSString*) systemName;
+(NSString*) systemVersion;
+(NSString*) localizeModel;
+(NSString*) userInterfaceIdiom: (DeviceIdiom) idiom;
+(NSString*) identifierForVendor;

+(NSString*) getUserInterfaceIdiom;
+(NSInteger) screenWidth;
+(NSInteger) screenHeight;

//+(NSInteger*) displayDensity;

+(NSInteger) physicalMemory;
+(NSInteger) processorNumber;

+(NSString *) deviceUUID;

////Disk
+(NSString*) totalSpace;
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


+(NSString *) deviceAdvertiserIdentifier;
+(id) sharedInstance;


@end
