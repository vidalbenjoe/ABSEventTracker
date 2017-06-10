//
//  DeviceFingerprinting.m
//  EventApp
//
//  Created by Benjoe Vidal on 22/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "DeviceFingerprinting.h"
#import "DeviceInfo.h"

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
    return rawString;
}
@end
