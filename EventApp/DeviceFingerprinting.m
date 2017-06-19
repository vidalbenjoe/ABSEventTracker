//
//  DeviceFingerprinting.m
//  EventApp
//
//  Created by Benjoe Vidal on 22/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "DeviceFingerprinting.h"
#import "DeviceInfo.h"
#import <CommonCrypto/CommonKeyDerivation.h>
#import <CommonCrypto/CommonDigest.h>

@implementation DeviceFingerprinting
+(NSString*) buildRawEntropy{
    NSMutableArray *rawComponents = [NSMutableArray array];
    //Getting data from the device info
    [rawComponents addObject:[DeviceInfo deviceName]];
    [rawComponents addObject:[DeviceInfo localizeModel]];
    [rawComponents addObject:[NSNumber numberWithInteger:[DeviceInfo physicalMemory]]];
    [rawComponents addObject:[NSNumber numberWithInteger:[DeviceInfo processorNumber]]];
    
    return [rawComponents componentsJoinedByString:@","];
}

//Generate device finger print based on the device info.
+(NSString*) generateDeviceFingerprint{
    NSString * rawString = [self buildRawEntropy];
//    const char *cStr = [rawString UTF8String];
//    unsigned char digest[16];
//    CC_MD5(cStr, (CC_LONG)cStr, digest);
//    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
//    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
//        [output appendFormat:@"%02x", digest[i]];
    return  rawString;
}
@end
