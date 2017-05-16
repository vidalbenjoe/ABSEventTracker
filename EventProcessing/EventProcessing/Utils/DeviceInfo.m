//
//  DeviceInfo.m
//  EventProcessing
//
//  Created by Benjoe Vidal on 16/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "DeviceInfo.h"
#import <sys/utsname.h>

@implementation DeviceInfo

+(id)sharedInstance{
    static DeviceInfo *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    
    return shared;
}

-(id) init{
    self = [super init];
    if (self) {
        self = [[DeviceInfo alloc] init];
    }
    return self;
}

+ (NSDictionary*) deviceNameByCode{
    static NSDictionary *deviceNameByCode = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    #pragma clang diagnositc push
    #pragma clang dignostic ignored - "-Wdeprecated-declaration"
        deviceNameByCode = @{ @"iPhone3, 1" : @(iPhone4),
                              @"iPhone3, 2" : @(iPhone4),
                              @"iPhone3, 3" : @(iPhone4),
                              @"iPhone4, 1" : @(iPhone4S),
                              @"iPhone5, 1" : @(iPhone5),
                              @"iPhone5, 2" : @(iPhone5),
                              @"iPhone5, 3" : @(iPhone5C),
                              @"iPhone5, 3" : @(iPhone5C),
                              @"iPhone5, 4" : @(iPhone5C),
                              @"iPhone6, 1" : @(iPhone5S),
                              @"iPhone6, 2" : @(iPhone5S),
                              @"iPhone7, 2" : @(iPhone6),
                              
                              
                              };
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

+ (NSString*) deviceNameForVersion: (DeviceVersion) deviceVersion{
    
    return @"";
}

-(NSString*) publicMethod{
   
    
    return @"ds";
}

@end
