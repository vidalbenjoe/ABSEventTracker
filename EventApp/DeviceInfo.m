//
//  DeviceInfo.m
//  EventProcessing
//
//  Created by Benjoe Vidal on 16/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "DeviceInfo.h"
#import "Reachability.h"
#import <sys/utsname.h>
#import <UIKit/UIKit.h>
#import <AdSupport/ASIdentifierManager.h>
@implementation DeviceInfo

+(id)sharedInstance{
    static DeviceInfo *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[super alloc] init];
    });
    return shared;
}

+ (NSDictionary*) deviceNameByCode{
    static NSDictionary *deviceNameByCode = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#pragma clang diagnositc push
#pragma clang dignostic ignored - "-Wdeprecated-declaration"
        deviceNameByCode = @{
                             //iPhones
                             @"iPhone3,1" : @(iPhone4),
                             @"iPhone3,2" : @(iPhone4),
                             @"iPhone3,3" : @(iPhone4),
                             @"iPhone4,1" : @(iPhone4S),
                             @"iPhone4,2" : @(iPhone4S),
                             @"iPhone4,3" : @(iPhone4S),
                             @"iPhone5,1" : @(iPhone5),
                             @"iPhone5,2" : @(iPhone5),
                             @"iPhone5,3" : @(iPhone5C),
                             @"iPhone5,4" : @(iPhone5C),
                             @"iPhone6,1" : @(iPhone5S),
                             @"iPhone6,2" : @(iPhone5S),
                             @"iPhone7,2" : @(iPhone6),
                             @"iPhone7,1" : @(iPhone6Plus),
                             @"iPhone8,1" : @(iPhone6S),
                             @"iPhone8,2" : @(iPhone6SPlus),
                             @"iPhone8,4" : @(iPhoneSE),
                             @"iPhone9,1" : @(iPhone7),
                             @"iPhone9,3" : @(iPhone7),
                             @"iPhone9,2" : @(iPhone7Plus),
                             @"iPhone9,4" : @(iPhone7Plus),
                             @"i386"      : @(Simulator),
                             @"x86_64"    : @(Simulator),
                             
                             //iPads
                             @"iPad1,1" : @(iPad1),
                             @"iPad2,1" : @(iPad2),
                             @"iPad2,2" : @(iPad2),
                             @"iPad2,3" : @(iPad2),
                             @"iPad2,4" : @(iPad2),
                             @"iPad2,5" : @(iPadMini),
                             @"iPad2,6" : @(iPadMini),
                             @"iPad2,7" : @(iPadMini),
                             @"iPad3,1" : @(iPad3),
                             @"iPad3,2" : @(iPad3),
                             @"iPad3,3" : @(iPad3),
                             @"iPad3,4" : @(iPad4),
                             @"iPad3,5" : @(iPad4),
                             @"iPad3,6" : @(iPad4),
                             @"iPad4,1" : @(iPadAir),
                             @"iPad4,2" : @(iPadAir),
                             @"iPad4,3" : @(iPadAir),
                             @"iPad4,4" : @(iPadMini2),
                             @"iPad4,5" : @(iPadMini2),
                             @"iPad4,6" : @(iPadMini2),
                             @"iPad4,7" : @(iPadMini3),
                             @"iPad4,8" : @(iPadMini3),
                             @"iPad4,9" : @(iPadMini3),
                             @"iPad5,1" : @(iPadMini4),
                             @"iPad5,2" : @(iPadMini4),
                             @"iPad5,3" : @(iPadAir2),
                             @"iPad5,4" : @(iPadAir2),
                             @"iPad6,3" : @(iPadPro9Dot7Inch),
                             @"iPad6,4" : @(iPadPro9Dot7Inch),
                             @"iPad6,7" : @(iPadPro12Dot9Inch),
                             @"iPad6,8" : @(iPadPro12Dot9Inch),
                             @"iPad6,11": @(iPad5),
                             @"iPad6,12": @(iPad5),
                             
                             //iPods
                             @"iPod1,1" : @(iPodTouch1Gen),
                             @"iPod2,1" : @(iPodTouch2Gen),
                             @"iPod3,1" : @(iPodTouch3Gen),
                             @"iPod4,1" : @(iPodTouch4Gen),
                             @"iPod5,1" : @(iPodTouch5Gen),
                             @"iPod7,1" : @(iPodTouch6Gen)};
#pragma clang diagnostic pop
        
    });
    return deviceNameByCode;
}

+ (DeviceVersion) deviceVersion{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *code = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    DeviceVersion version = (DeviceVersion) [[self.deviceNameByCode objectForKey:code] integerValue];
    return version;
    
}

+ (NSString *)deviceNameString
{
    return [DeviceInfo deviceNameForVersion:[DeviceInfo deviceVersion]];
}

+ (NSString *)deviceNameForVersion:(DeviceVersion)deviceVersion
{
    return @{
             @(iPhone4)           : @"iPhone 4",
             @(iPhone4S)          : @"iPhone 4S",
             @(iPhone5)           : @"iPhone 5",
             @(iPhone5C)          : @"iPhone 5C",
             @(iPhone5S)          : @"iPhone 5S",
             @(iPhone6)           : @"iPhone 6",
             @(iPhone6Plus)       : @"iPhone 6 Plus",
             @(iPhone6S)          : @"iPhone 6S",
             @(iPhone6SPlus)      : @"iPhone 6S Plus",
             @(iPhone7)           : @"iPhone 7",
             @(iPhone7Plus)       : @"iPhone 7 Plus",
             @(iPhoneSE)          : @"iPhone SE",
             
             @(iPad1)             : @"iPad 1",
             @(iPad2)             : @"iPad 2",
             @(iPadMini)          : @"iPad Mini",
             @(iPad3)             : @"iPad 3",
             @(iPad4)             : @"iPad 4",
             @(iPadAir)           : @"iPad Air",
             @(iPadMini2)         : @"iPad Mini 2",
             @(iPadAir2)          : @"iPad Air 2",
             @(iPadMini3)         : @"iPad Mini 3",
             @(iPadMini4)         : @"iPad Mini 4",
             @(iPadPro9Dot7Inch)  : @"iPad Pro",
             @(iPadPro12Dot9Inch) : @"iPad Pro",
             @(iPad5)             : @"iPad 5",
             
             @(iPodTouch1Gen)     : @"iPod Touch 1st Gen",
             @(iPodTouch2Gen)     : @"iPod Touch 2nd Gen",
             @(iPodTouch3Gen)     : @"iPod Touch 3rd Gen",
             @(iPodTouch4Gen)     : @"iPod Touch 4th Gen",
             @(iPodTouch5Gen)     : @"iPod Touch 5th Gen",
             @(iPodTouch6Gen)     : @"iPod Touch 6th Gen",
             
             @(Simulator)         : @"Simulator",
             @(UnknownDevice)     : @"Unknown Device"
             }[@(deviceVersion)];
}

//The end-user-visible name for the end product.
//Ex: "My iPhone"
+(NSString*) deviceName{
    return [[UIDevice currentDevice] name];
}
//The name of the operating system running on the device represented by the receiver.
//Ex: @"iOS"
+(NSString*) systemName{
    return [[UIDevice currentDevice] systemName];
}
//The current version of the operating system.
//Ex: 10.0
+(NSString*) systemVersion{
    return [[UIDevice currentDevice] systemVersion];
}

+(NSString*) localizeModel{
    return [[UIDevice currentDevice] localizedModel];
}
//The type of current device
//iPhone, iPad, iPad Air, Simulator
+(NSString*) deviceType{
    return [self deviceNameString];
}

+(NSString*) deviceIdiom{
    return [DeviceInfo userInterfaceIdiom:[DeviceInfo interfaceIdiom]];
}

+(NSString*) getUserInterfaceIdiom{
    return [self deviceIdiom];
}

+ (DeviceIdiom) interfaceIdiom{
    DeviceIdiom deviceidiom = (DeviceIdiom) 0;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        deviceidiom = PAD;
    }else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        deviceidiom = PHONE;
    }else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomTV){
        deviceidiom = TV;
    }else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomCarPlay){
        deviceidiom = CARPLAY;
    }else{
        deviceidiom = UNSPECIFIED;
    }
    return deviceidiom;
}

+(NSString*) userInterfaceIdiom: (DeviceIdiom) idiom{
    return @{
             @(PHONE)               : @"Phone",
             @(PAD)                 : @"Pad",
             @(TV)                  : @"TV",
             @(CARPLAY)             : @"CarPlay",
             @(UNSPECIFIED)         : @"Unknown Device"
             }[@(idiom)];
}

//An alphanumeric string that uniquely identifies a device to the app’s vendor.
//Ex: 4375A586-0C0F-41CA-B60D-B497CCR0143F
+(NSString*) identifierForVendor{
    return [[UIDevice currentDevice] identifierForVendor].UUIDString;
}

+ (NSInteger)screenWidth {
    // Get the screen width
    @try {
        // Screen bounds
        CGRect Rect = [[UIScreen mainScreen] bounds];
        // Find the width (X)
        NSInteger Width = Rect.size.width;
        // Verify validity
        if (Width <= 0) {
            // Invalid Width
            return -1;
        }
        
        // Successful
        return Width;
    }
    @catch (NSException *exception) {
        // Error
        return -1;
    }
}


+(NSInteger) screenHeight{
    // Get the screen height
    @try {
        // Screen bounds
        CGRect Rect = [[UIScreen mainScreen] bounds];
        // Find the width (X)
        NSInteger Height = Rect.size.height;
        // Verify validity
        if (Height <= 0) {
            // Invalid Height
            return -1;
        }
        // Successful
        return Height;
    }
    @catch (NSException *exception) {
        // Error
        return -1;
    }
}

+(NSInteger) physicalMemory{
    return [[NSProcessInfo processInfo] physicalMemory] / 1073741824.;      //gibi
}

+(NSInteger) processorNumber{
    if ([[NSProcessInfo processInfo] respondsToSelector:@selector(processorCount)]) {
        // Get the number of processors
        NSInteger processorCount = [[NSProcessInfo processInfo] processorCount];
        // Return the number of processors
        return processorCount;
    } else {
        // Return -1 (not found)
        return -1;
    }
}

+(NSString *) deviceUUID{
    NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return uniqueIdentifier;
}

+(NSString *) deviceIDFA{
    NSString *idfaString = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return idfaString;
}

+(NSString*) totalSpace{
    return @"";
}

+(NSString *) deviceConnectivity{
    NSString *connectivity;
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if(status == NotReachable)
    {
        //No internet
        connectivity = @"No Internet";
        
    }
    else if (status == ReachableViaWiFi)
    {
         //WiFi
        connectivity = @"Wifi";
       
    }
    else if (status == ReachableViaWWAN)
    {
        //3G
        connectivity = @"3G";
    }
    
    return connectivity;
}

@end
