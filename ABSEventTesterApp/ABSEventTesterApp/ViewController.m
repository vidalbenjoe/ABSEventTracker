//
//  ViewController.m
//  ABSEventTesterApp
//
//  Created by Flydubai on 29/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "ViewController.h"
#import <ABSEventTracker/EventAttributes.h>
#import <ABSEventTracker/UserAttributes.h>
#import <ABSEventTracker/ABSEventTracker+Initializer.h>
@interface ViewController ()
- (IBAction)trackEvent:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)trackEvent:(id)sender {
    UserAttributes *user = [UserAttributes makeWithBuilder:^(UserBuilder *builder) {
        [builder setGigyaID:@""];
        [builder setFirstName:@""];
        [builder setLastName:@""];
    }];
    [ABSEventTracker initWithUser:user];
    
    EventAttributes *attrib = [EventAttributes makeWithBuilder:^(EventBuilder *builder) {
        
        [builder setClickedContent:@"Button"];
        [builder setSearchQuery:@"Search..."];
        [builder setReadArticles:@"Philstar"];
        [builder setArticleAuthor:@"Bob Ong"];
        [builder setArticlePostDate:@"June 15, 2017"];
        [builder setCommentContent:@"comment content"];
        [builder setFollowEntity:@"entity"];
        [builder setLikedContent:@"Liked"];
        [builder setMetaTags:@"TAGS"];
        [builder setPreviousScreen:@"previous screen"];
        [builder setScreenDestination:@"screenDestination"];
        
        [builder setActionTaken:SEARCH];
        [builder setArticleCharacterCount:4];
        [builder setLatitute:120.421412];
        [builder setLongitude:14.2323];
        [builder setDuration:230];
        [builder setRating:23];
        
    }];
    
    [ABSEventTracker initEventAttributes:attrib];
}


- (IBAction)readItem:(id)sender {
    [ABSEventTracker readPopularRecommendation];
}
@end
