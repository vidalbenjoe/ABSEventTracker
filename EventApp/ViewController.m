//
//  ViewController.m
//  EventApp
//
//  Created by Benjoe Vidal on 19/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "DeviceInfo.h"
#import "DeviceFingerprinting.h"

#import "EventAttributes.h"
#import "ABSEventTracker.h"
#import "DeviceInvariant.h"
#import "AttributeManager.h"
#import "ABSNetworking.h"
#import "ABSEventAttributeQualifier.h"
#import "ABSBigDataServiceDispatcher.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *appTitle;
@end

@implementation ViewController
@synthesize appTitle;
- (void)viewDidLoad {
    [super viewDidLoad];
    [appTitle setAdjustsFontSizeToFitWidth:TRUE];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)writerButton:(id)sender {
    EventAttributes *attrib = [EventAttributes makeWithBuilder:^(EventBuilder *builder) {
        [builder setClickedContent:@"Button"];
        [builder setMetaTags:@"TAGS"];
        [builder setArticleAuthor:@"Bob Ong"];
        [builder setSearchQuery:@""];
        [builder setActionTaken:FACEBOOK_LIKE];
        [builder setPreviousScreen:@"asda"];
    }];
    
    [ABSEventTracker initEventAttributes:attrib];
    
}
@end
