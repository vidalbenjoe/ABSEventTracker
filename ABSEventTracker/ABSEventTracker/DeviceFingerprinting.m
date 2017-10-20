//
//  DeviceFingerprinting.m
//  EventApp
//
//  Created by Benjoe Vidal on 22/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "DeviceFingerprinting.h"
#import <CommonCrypto/CommonKeyDerivation.h>
#import <CommonCrypto/CommonDigest.h>
#import "DeviceInfo.h"
@implementation DeviceFingerprinting
/*!
 * Consolidating device entropy for device fingerprinting
 */

+(NSString*) buildRawEntropy{
    NSMutableArray *rawComponents = [NSMutableArray array];
    //Getting data from the device info
    [rawComponents addObject:[DeviceInfo systemName]];
    [rawComponents addObject:[DeviceInfo systemVersion]];
    [rawComponents addObject:[DeviceInfo deviceType]];
    [rawComponents addObject:[DeviceInfo localizeModel]];
    [rawComponents addObject:[DeviceInfo getUserInterfaceIdiom]];
    [rawComponents addObject:[DeviceInfo totalSpace]];
    [rawComponents addObject:[NSNumber numberWithInteger:[DeviceInfo screenWidth]]];
    [rawComponents addObject:[NSNumber numberWithInteger:[DeviceInfo screenHeight]]];
    [rawComponents addObject:[NSNumber numberWithInteger:[DeviceInfo physicalMemory]]];
    [rawComponents addObject:[NSNumber numberWithInteger:[DeviceInfo processorNumber]]];
    [rawComponents addObject:[DeviceInfo deviceUUID]];
    [rawComponents addObject:[DeviceInfo deviceConnectivity]];
    return [rawComponents componentsJoinedByString:@","];
}
/*!
 * Generate MD5 format device fingerprint based on the device info.
 */
+(NSString*) generateDeviceFingerprint{
    NSString * rawString = [self buildRawEntropy];
    const char *cStr = [rawString UTF8String];
    unsigned char digest[16];
    CC_MD5(cStr, (unsigned int) strlen(cStr), digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return  output;
}

@end
