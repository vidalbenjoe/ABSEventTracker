//
//  Enumerations.h
//  EventApp
//
//  Created by Benjoe Vidal on 26/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef Enumarations_h
#define Enumarations_h

// MARK: Enums
/// The size scale to decide how you want to obtain size information
///
/// - bytes:     In bytes
/// - kilobytes: In kilobytes
/// - megabytes: In megabytes
/// - gigabytes: In gigabytes

extern NS_ENUM (NSInteger, deviceSizeScale) {
    BYTES,
    KILOBYTES,
    MEGABYTES,
    GIGABYTES
} scaleSize;

/// The battery state
///
/// - unknown:   State unknown
/// - unplugged: Battery is not plugged in
/// - charging:  Battery is charging
/// - full:      Battery is full charged

typedef enum{
    UNKNOWN,
    UNPLUGGED,
    CHARGING,
    FULL
}batteryState;

typedef NS_ENUM(NSInteger, DeviceIdiom){
    UNSPECIFIED         = 0,
    PHONE               = 1,
    PAD                 = 2,
    TV                  = 3,
    CARPLAY             = 4
};

typedef NS_ENUM(NSInteger, DeviceVersion){
    UnknownDevice     = 0,
    Simulator         = 1,
    
    iPhone4           = 3,
    iPhone4S          = 4,
    iPhone5           = 5,
    iPhone5C          = 6,
    iPhone5S
    = 7,
    iPhone6           = 8,
    iPhone6Plus       = 9,
    iPhone6S          = 10,
    iPhone6SPlus      = 11,
    iPhone7           = 12,
    iPhone7Plus       = 13,
    iPhoneSE          = 14,
    
    iPad1             = 15,
    iPad2             = 16,
    iPadMini          = 17,
    iPad3             = 18,
    iPad4             = 19,
    iPadAir           = 20,
    iPadMini2         = 21,
    iPadAir2          = 22,
    iPadMini3         = 23,
    iPadMini4         = 24,
    iPadPro12Dot9Inch = 25,
    iPadPro9Dot7Inch  = 26,
    iPad5             = 27,
    
    iPodTouch1Gen     = 28,
    iPodTouch2Gen     = 29,
    iPodTouch3Gen     = 30,
    iPodTouch4Gen     = 31,
    iPodTouch5Gen     = 32,
    iPodTouch6Gen     = 33
};




typedef NS_ENUM(NSInteger, ActionTaken){
    FACEBOOK_LIKE       =   0,
    FACEBOOK_SHARE      =   1,
    FACEBOOK_FOLLOW     =   2,
    TWITTER_SHARE       =   3,
    TWITTER_FOLLOW      =   4,
    INSTAGRAM_SHARE     =   5,
    INSTAGRAM_FOLLOW    =   6,
    POST_COMMENT        =   7,
    SEARCH              =   8,
    CLICK_HYPERLINK     =   9,
    SOCIAL_SHARE        =   10,
    SOCIAL_FOLLOW       =   11,
    SOCIAL_LIKE         =   12,
    RATE                =   13,
    CLICK_IMAGE         =   14,
    SLIDER              =   15,
    LOGIN               =   16,
    LOGOUT              =   17,
    READ_ARTICLES       =   18,
    ABANDON             =   19,
    LOAD                =   20,
    OTHERS              =   21
};

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


typedef NS_ENUM(NSUInteger, HTTPStatus){
    SUCCESS                =   200,
    UNAUTHORIZE             =   401,
    BAD_REQUEST             =   400,
    NOT_FOUND               =   404,
    INTERNAL_SERVER_ERROR   =   500
   
};

#endif /* Enumarations_h */

@interface Enumerations : NSObject

@property(nonatomic, assign) DigitalProperty property;

@end

