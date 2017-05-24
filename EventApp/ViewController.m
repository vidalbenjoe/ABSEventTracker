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
#import "PropertyEventSource.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
        EventAttributes *attrib = [EventAttributes makeWithBuilder:^(EventBuilder *builder) {
        [builder setClickedContent:@"Testt content"];
        [builder setMetaTags:@"meta"];
        [builder setArticleAuthor:@"benjoe"];
        [builder setSearchQuery:@"Probinsyano"];
        [builder setActionTaken:FACEBOOK_LIKE];
    }];
    
    [EventController writeEvent:attrib];
    
    PropertyEventSource *eventSourfce = [[PropertyEventSource alloc] init];
    NSLog(@"eventSource: %@", eventSourfce.propertyName);
    NSLog(@"eventConto %@", [EventController writeEvent:attrib]);
    //Pass the value of Event Attriutes to event writer
    NSLog(@"attributes: %@", [NSString stringWithFormat:@"%@", attrib]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
