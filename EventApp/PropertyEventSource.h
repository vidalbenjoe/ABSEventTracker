//
//  PropertyEventSource.h
//  EventApp
//
//  Created by Benjoe Vidal on 24/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#define IWANTTVDEF @"com.ph.abscbn.ios.EventAppd"
#define TFCDEF @"com.ph.abscbn.ios.EventAspp"

#import <Foundation/Foundation.h>
#import "Enumarations.h"

@interface PropertyEventSource : NSObject

@property(nonatomic, assign) DigitalProperty property;

+(NSDictionary *) propertyDisplayName;
-(NSString *) propertyName;
+(NSString *) getAppName;
+(NSString *) getBundleIdentifier;
-(void) setDigitalProperty:(DigitalProperty) digitalProperty;
-(DigitalProperty) getProperty;
@end
