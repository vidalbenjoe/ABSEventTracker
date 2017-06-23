//
//  BackgroundLooper.h
//  EventApp
//
//  Created by Flydubai on 21/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface BackgroundLooper : UIResponder <UIApplicationDelegate>
@property(nonatomic) AppDelegate *appdelegate;
+(BackgroundLooper *) init;
@end
