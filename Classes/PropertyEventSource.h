//
//  PropertyEventSource.h
//  EventApp
//
//  Created by Benjoe Vidal on 24/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//



#import <Foundation/Foundation.h>
/// The Digital Properties
///
/// - SKY ON DEMAND:   SkyOnDemand
/// - NEW          :   News
/// - NOINK        :   NOINK

typedef NS_ENUM(NSUInteger, DigitalProperty){
    SKY_ON_DEMAND       =   0,
    NEWS                =   1,
    I_WANT_TV           =   2,
    NO_INK              =   3,
    INVALID             =   4,
    TEST                =   5
};

@interface PropertyEventSource : NSObject

@property(nonatomic, assign) DigitalProperty property;
@property(nonatomic, assign) NSString *applicationName;
@property(nonatomic, assign) NSString *bundleIdentifier;

+(instancetype) init;

+(NSString *) getAppName;
+(NSString *) getBundleIdentifier;

-(void) setDigitalProperty:(DigitalProperty) digitalProperty;
-(DigitalProperty) getProperty;
@end
