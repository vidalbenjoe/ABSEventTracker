//
//  DeviceFingerprinting.h
/**********************************************************************
 **                                                                  **
 **                                                                  **
 **                        ABSEventTracker                           **
 **            Created by Benjoe Vidal on 22/05/2017.                **
 **         Copyright © 2017 ABS-CBN. All rights reserved.           **
 **                                                                  **
 **                                                                  **
 **                                                                  **
 **********************************************************************/
#import <Foundation/Foundation.h>

@interface DeviceFingerprinting : NSObject
/*!
 * Generate MD5 format device fingerprint based on the provided device attributes
 */
+(NSString*) generateDeviceFingerprint;
@end
