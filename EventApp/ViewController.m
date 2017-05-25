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
#import "DeviceInvariant.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        EventController *controller = [[EventController alloc] init];
        [controller setDelegate:self];
        NSString *sti = @"Ang Probinsyano Ep 2";
        EventAttributes *attrib = [EventAttributes makeWithBuilder:^(EventBuilder *builder) {
        [builder setClickedContent:@"Ang Probinsyano Ep 2 blahblah blah"];
        [builder setMetaTags:@"meta"];
        [builder setArticleAuthor:@"benjoe"];
        [builder setSearchQuery:sti];
        [builder setActionTaken:FACEBOOK_LIKE];
    }];
    [controller writeEvent:attrib];
    

    PropertyEventSource *eventSource = [[PropertyEventSource alloc] init];
    [eventSource setProperty:I_WANT_TV];
    NSLog(@"Property: %@", eventSource.propertyName);
    
    
        //no need to display the object's values.
        //Pass the value of Event Attriutes object to event writer

    NSLog(@"bundielID: %@", [[NSBundle mainBundle] bundleIdentifier] );
    
    DeviceInvariant *invariant = [[DeviceInvariant alloc] init];
    [invariant setDeviceOS:@"dawdaw"];
    
    NSLog(@"invariant: %@", invariant.deviceOS);
}

-(void) onSuccess{
    
}

-(void) onFail{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
