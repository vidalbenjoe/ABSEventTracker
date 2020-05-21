//
//  DeviceInfo.m
//  EventProcessing
//
//  Created by Benjoe Vidal on 16/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <sys/utsname.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "DeviceInfo.h"
#import "Reachability.h"
#import <AdSupport/ASIdentifierManager.h>
#import <sys/utsname.h> // import it in your header or implementation file.

@implementation DeviceInfo
// Mobile Gestalt EquipmentInfo
//extern CFTypeRef MGCopyAnswer(CFStringRef);

+(id)sharedInstance{
    static DeviceInfo *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[super alloc] init];
    });
    return shared;
}

+(NSString*) deviceStringName{
   struct utsname systemInfo;

    uname(&systemInfo);

    NSString* code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];

    
    static NSDictionary* deviceNamesByCode = nil;

    if (!deviceNamesByCode) {

        deviceNamesByCode = @{@"i386"      : @"Simulator",
                              @"x86_64"    : @"Simulator",
                              @"iPod1,1"   : @"iPod Touch",        // (Original)
                              @"iPod2,1"   : @"iPod Touch",        // (Second Generation)
                              @"iPod3,1"   : @"iPod Touch",        // (Third Generation)
                              @"iPod4,1"   : @"iPod Touch",        // (Fourth Generation)
                              @"iPod7,1"   : @"iPod Touch",        // (6th Generation)
                              @"iPhone1,1" : @"iPhone",            // (Original)
                              @"iPhone1,2" : @"iPhone",            // (3G)
                              @"iPhone2,1" : @"iPhone",            // (3GS)
                              @"iPad1,1"   : @"iPad",              // (Original)
                              @"iPad2,1"   : @"iPad 2",            //
                              @"iPad3,1"   : @"iPad",              // (3rd Generation)
                              @"iPhone3,1" : @"iPhone 4",          // (GSM)
                              @"iPhone3,3" : @"iPhone 4",          // (CDMA/Verizon/Sprint)
                              @"iPhone4,1" : @"iPhone 4S",         //
                              @"iPhone5,1" : @"iPhone 5",          // (model A1428, AT&T/Canada)
                              @"iPhone5,2" : @"iPhone 5",          // (model A1429, everything else)
                              @"iPad3,4"   : @"iPad",              // (4th Generation)
                              @"iPad2,5"   : @"iPad Mini",         // (Original)
                              @"iPhone5,3" : @"iPhone 5c",         // (model A1456, A1532 | GSM)
                              @"iPhone5,4" : @"iPhone 5c",         // (model A1507, A1516, A1526 (China), A1529 | Global)
                              @"iPhone6,1" : @"iPhone 5s",         // (model A1433, A1533 | GSM)
                              @"iPhone6,2" : @"iPhone 5s",         // (model A1457, A1518, A1528 (China), A1530 | Global)
                              @"iPhone7,1" : @"iPhone 6 Plus",     //
                              @"iPhone7,2" : @"iPhone 6",          //
                              @"iPhone8,1" : @"iPhone 6S",         //
                              @"iPhone8,2" : @"iPhone 6S Plus",    //
                              @"iPhone8,4" : @"iPhone SE",         //
                              @"iPhone9,1" : @"iPhone 7",          //
                              @"iPhone9,3" : @"iPhone 7",          //
                              @"iPhone9,2" : @"iPhone 7 Plus",     //
                              @"iPhone9,4" : @"iPhone 7 Plus",     //
                              @"iPhone10,1": @"iPhone 8",          // CDMA
                              @"iPhone10,4": @"iPhone 8",          // GSM
                              @"iPhone10,2": @"iPhone 8 Plus",     // CDMA
                              @"iPhone10,5": @"iPhone 8 Plus",     // GSM
                              @"iPhone10,3": @"iPhone X",          // CDMA
                              @"iPhone10,6": @"iPhone X",          // GSM
                              @"iPhone11,2": @"iPhone XS",         //
                              @"iPhone11,4": @"iPhone XS Max",     //
                              @"iPhone11,6": @"iPhone XS Max",     // China
                              @"iPhone11,8": @"iPhone XR",         //
                              @"iPhone12,1": @"iPhone 11",         //
                              @"iPhone12,3": @"iPhone 11 Pro",     //
                              @"iPhone12,5": @"iPhone 11 Pro Max", //

                              @"iPad4,1"   : @"iPad Air",          // 5th Generation iPad (iPad Air) - Wifi
                              @"iPad4,2"   : @"iPad Air",          // 5th Generation iPad (iPad Air) - Cellular
                              @"iPad4,4"   : @"iPad Mini",         // (2nd Generation iPad Mini - Wifi)
                              @"iPad4,5"   : @"iPad Mini",         // (2nd Generation iPad Mini - Cellular)
                              @"iPad4,7"   : @"iPad Mini",         // (3rd Generation iPad Mini - Wifi (model A1599))
                              @"iPad6,7"   : @"iPad Pro (12.9\")", // iPad Pro 12.9 inches - (model A1584)
                              @"iPad6,8"   : @"iPad Pro (12.9\")", // iPad Pro 12.9 inches - (model A1652)
                              @"iPad6,3"   : @"iPad Pro (9.7\")",  // iPad Pro 9.7 inches - (model A1673)
                              @"iPad6,4"   : @"iPad Pro (9.7\")"   // iPad Pro 9.7 inches - (models A1674 and A1675)
                              };
    }
    
    
 
    NSString* deviceName = [deviceNamesByCode objectForKey:code];

    if (!deviceName) {
        // Not found on database. At least guess main device type from string contents:

        if ([code rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
        }
        else if([code rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        }
        else if([code rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        }
        else {
            deviceName = code;
        }
    }

    return deviceName;
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
// Localize model of device
//Ex: iPhone
+(NSString*) localizeModel{
    return [[UIDevice currentDevice] localizedModel];
}

//Current user interface of device:
// Ex: Phone, Tablet, TV, CarPlay
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
             @(PHONE)               : @"iPhone",
             @(PAD)                 : @"iPad",
             @(TV)                  : @"TV",
             @(CARPLAY)             : @"CarPlay",
             @(UNSPECIFIED)         : @"Unknown Device"
             }[@(idiom)];
}

/**
 * Return an alphanumeric string that uniquely identifies a device to the app’s vendor.
 * Ex: 4375A586-0C0F-41CA-B60D-B497CCR0143F
 */
+(NSString*) identifierForVendor{
    return [[UIDevice currentDevice] identifierForVendor].UUIDString;
}
/*
 * Return device width
 */
+ (NSInteger)screenWidth {
    // Get the screen width
    @try {
        // Screen bounds
        CGRect Rect = [[UIScreen mainScreen] bounds];
        // Find the width (X)
        NSInteger Width = (NSInteger) roundf(Rect.size.width);
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
/*
 * Return device height
 */
+(NSInteger) screenHeight{
    // Get the screen height
    @try {
        // Screen bounds
        CGRect Rect = [[UIScreen mainScreen] bounds];
        // Find the width (X)
        NSInteger Height = (NSInteger) roundf(Rect.size.height);
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
/*
 * Return device physical memory
 */
+(NSInteger) physicalMemory{
    return [[NSProcessInfo processInfo] physicalMemory] / 1073741824.;      //gibi
}
/*
 * Return device processor count
 */
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
/*
 * Return device UUID
 */

+(NSString *) deviceUUID{
    NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return uniqueIdentifier;
}
/*
 * Return device total Space
 */
+(NSNumber*) totalSpace{
    uint64_t totalSpace = 0;
    uint64_t totalFreeSpace = 0;
    
    __autoreleasing NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
        NSLog(@"Memory Capacity of %llu MiB with %llu MiB Free memory available.", ((totalSpace/1024ll)/1024ll), ((totalFreeSpace/1024ll)/1024ll));
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    return [NSNumber numberWithUnsignedLongLong:((totalSpace/1024ll)/1024ll)];
}
/*
 * Detect device connectivity
 * Ex: Wifi, 2G, 3G, 4G
 */
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
        CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
        NSString * carrierType = netinfo.currentRadioAccessTechnology;
        if ([carrierType isEqualToString:CTRadioAccessTechnologyGPRS]) {
            connectivity = @"2G";
        } else if ([carrierType isEqualToString:CTRadioAccessTechnologyEdge]) {
            connectivity = @"2G";
        } else if ([carrierType isEqualToString:CTRadioAccessTechnologyWCDMA]) {
            connectivity = @"3G";
        } else if ([carrierType isEqualToString:CTRadioAccessTechnologyHSDPA]) {
            connectivity = @"3G";
        } else if ([carrierType isEqualToString:CTRadioAccessTechnologyHSUPA]) {
            connectivity = @"3G";
        } else if ([carrierType isEqualToString:CTRadioAccessTechnologyCDMA1x]) {
            connectivity = @"3G";
        } else if ([carrierType isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0]) {
            connectivity = @"3G";
        } else if ([carrierType isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA]) {
            connectivity = @"3G";
        } else if ([carrierType isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB]) {
            connectivity = @"3G";
        } else if ([carrierType isEqualToString:CTRadioAccessTechnologyeHRPD]) {
            connectivity = @"3G";
        } else if ([carrierType isEqualToString:CTRadioAccessTechnologyLTE]) {
            connectivity = @"4G";
        }
        
    }
    
    return connectivity;
}

+(NSString *) deviceAdvertiserIdentifier{
    NSString *idfaString = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return idfaString;
}

@end
