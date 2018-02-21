//
//  PropertyEventSource.h
//  ABSEventTracker
/**********************************************************************
 **                                                                  **
 **                                                                  **
 **                        ABSEventTracker                           **
 **            Created by Benjoe Vidal on 24/05/2017.                **
 **          Copyright © 2017 ABS-CBN. All rights reserved.          **
 **                                                                  **
 **                                                                  **
 **                                                                  **
 **********************************************************************/

#import <Foundation/Foundation.h>
/// The Digital Properties
typedef NS_ENUM(NSUInteger, DigitalProperty){
    GIGYA               =   1,
    I_WANT_TV           =   2,
    TFC                 =   3,
    SKY_ON_DEMAND       =   4,
    ONE_MUSIC           =   5,
    NO_INK              =   6,
    SINEHUB             =   7,
    NEWS                =   8,
    INVALID             =   9,
    TEST                =   10
};

@interface PropertyEventSource : NSObject

@property(nonatomic, assign) DigitalProperty property;
@property(nonatomic, assign) NSString *applicationName;
@property(nonatomic, assign) NSString *bundleIdentifier;
@property(nonatomic, assign) NSString *origin;
@property(nonatomic, strong) NSString *siteDomain;

+(instancetype) sharedInstance;

+(NSString *) getAppName;
+(NSString *) getBundleIdentifier;
-(void) setDigitalProperty:(DigitalProperty) digitalProperty;
+(NSString *) convertPropertyTaken: (DigitalProperty) property;
@end
