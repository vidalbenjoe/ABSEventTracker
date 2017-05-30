//
//  ViewController.m
//  EventApp
//
//  Created by Benjoe Vidal on 19/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "ViewController.h"
#import "DeviceInfo.h"
#import "DeviceFingerprinting.h"

#import "EventAttributes.h"
#import "EventController.h"
#import "DeviceInvariant.h"
#import "AttributeManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      [EventController init];
        NSString *sti = @"Ang Probinsyano Ep 2";
        EventAttributes *attrib = [EventAttributes makeWithBuilder:^(EventBuilder *builder) {
        [builder setClickedContent:@"Button"];
        [builder setMetaTags:eventWriteURL];
        [builder setArticleAuthor:@"Bob Ong"];
        [builder setSearchQuery:sti];
        [builder setActionTaken:FACEBOOK_LIKE];
        [builder setPreviousScreen:@"asda"];
        
    }];
    [EventController writeEvent:attrib];
    
    DeviceInvariant *deviceInvariant = [DeviceInvariant makeWithBuilder:^(DeviceInvariantBuilder *builder) {
        [builder setDeviceFingerprint:[DeviceFingerprinting generateDeviceFingerprint]];
        [builder setDeviceOS:[DeviceInfo systemVersion]];
        [builder setDeviceScreenWidth:[DeviceInfo screenWidth]];
        [builder setDeviceScreenHeight:[DeviceInfo screenHeight]];
        [builder setDeviceType:[DeviceInfo platformType]];
    }];

    [EventController writeDevice:deviceInvariant];
    
    
    
//    Invariant *inva = [[Invariant alloc] init];
//    [inva initInvariant:deviceInvariant propertyInvariant:property];
    

    NSLog(@"devIn: %@",  [[[AttributeManager init] deviceinvariant] deviceType]);
    NSLog(@"dwsInis: %@",  deviceInvariant.deviceType);
    
    NSLog(@"getDeWrite: %@",  [[[AttributeManager init] eventattributes] clickedContent]);
   
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
