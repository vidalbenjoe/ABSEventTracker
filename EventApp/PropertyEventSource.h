//
//  PropertyEventSource.h
//  EventApp
//
//  Created by Benjoe Vidal on 24/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "Enumerations.h"

@interface PropertyEventSource : NSObject

@property(nonatomic, assign) DigitalProperty property;
@property(nonatomic, assign) NSString *applicationName;
@property(nonatomic, assign) NSString *bundleIdentifier;


+(instancetype) init;

+(NSDictionary *) propertyDisplayName;
-(NSString *) propertyName;





+(NSString *) getAppName;
+(NSString *) getBundleIdentifier;
-(void) setDigitalProperty:(DigitalProperty) digitalProperty;
-(DigitalProperty) getProperty;
@end
