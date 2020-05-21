//
//  DeviceInvariant.m
//  EventApp
//
//  Created by Benjoe Vidal on 24/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "DeviceInvariant.h"
@implementation DeviceInvariant
-(instancetype) initWithBuilder:(DeviceInvariantBuilder *)builder{
    if (self = [super init]) {
        _deviceFingerprint          = builder.deviceFingerprint;
        _deviceOS                   = builder.deviceOS;
        _deviceType                 = builder.deviceType;
        _deviceScreenWidth          = builder.deviceScreenWidth;
        _deviceScreenHeight         = builder.deviceScreenHeight;
        _appversionBuildRelease     = builder.appversionBuildRelease;
    }
    return self;
}

-(DeviceInvariantBuilder *) makeBuilder{
    DeviceInvariantBuilder *builder = [DeviceInvariantBuilder new];
    builder.deviceFingerprint       = _deviceFingerprint;
    builder.deviceOS                = _deviceOS;
    builder.deviceType              = _deviceType;
    builder.deviceScreenWidth       = _deviceScreenWidth;
    builder.deviceScreenHeight      = _deviceScreenHeight;
    builder.appversionBuildRelease  = _appversionBuildRelease;
    return builder;
}

+(instancetype) makeWithBuilder:(void (^)(DeviceInvariantBuilder *))updateBlock{
    DeviceInvariantBuilder *builder = [DeviceInvariantBuilder new];
    updateBlock(builder);
    return [[DeviceInvariant alloc] initWithBuilder: builder];
}

-(instancetype) update:(void (^)(DeviceInvariantBuilder *))updateBlock{
    DeviceInvariantBuilder *builder = [self makeBuilder];
    updateBlock(builder);
    return [[DeviceInvariant alloc] initWithBuilder:builder];
}
-(instancetype) build{
    DeviceInvariantBuilder *builder = [DeviceInvariantBuilder new];
    return [self initWithBuilder:builder];
}
@end
// DeviceInvariantBuilder
@implementation DeviceInvariantBuilder
-(instancetype) init{
    if (self = [super init]) {
        _deviceFingerprint          = nil;
        _deviceOS                   = nil;
        _deviceType                 = nil;
        _deviceScreenWidth          =   0;
        _deviceScreenHeight         =   0;
        _appversionBuildRelease     = nil;
    }
    return self;
}

@end


