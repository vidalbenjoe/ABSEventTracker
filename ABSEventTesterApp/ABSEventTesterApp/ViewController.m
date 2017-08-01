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
#import <ABSEventTracker/ABSEventTracker.h>
#import <ABSEventTracker/VideoAttributes.h>
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
    
//    VideoAttributes *video = [VideoAttributes makeWithBuilder:^(VideoBuilder *builder) {
//        [builder setState:PLAYING];
//        [builder setVideoURL:@"http://youtube.com"];
//        [builder setAction:VIDEO_COMPLETE];
//        [builder setVideoTitle:@"Ang probinsyano"];
//        
//    }];
    
//    [ABSEventTracker initVideoAttributes:video];
    
    UserAttributes *user = [UserAttributes makeWithBuilder:^(UserBuilder *builder) {
        [builder setGigyaID:@"a0fp-b3es-a2ge-n3fv-a2bc-v9gw"];
        [builder setFirstName:@"Juan"];
        [builder setMiddleName:@"De la"];
        [builder setLastName:@"Cruz"];
    }];
    [ABSEventTracker initWithUser:user];
    
    
    EventAttributes *events = [EventAttributes makeWithBuilder:^(EventBuilder *builder) {
        [builder setClickedContent:@"News"];
        [builder setReadArticle:@"DZMM News"];
        [builder setArticleAuthor:@"Ted Failon"];
        [builder setArticlePostDate:@"June 15, 2017"];
    }];
    [ABSEventTracker initEventAttributes:events];
    
//    EventAttributes *attrib = [EventAttributes makeWithBuilder:^(EventBuilder *builder) {
//        [builder setActionTaken:VIDEO_BUFFER];
//        [builder setDuration:210];
//    }];
    
    VideoAttributes *video = [VideoAttributes makeWithBuilder:^(VideoBuilder * builder) {
        [builder setAction:VIDEO_PLAYED];
        [builder setVideoPlayPosition:234];
        }];
    [ABSEventTracker initVideoAttributes:video];
    
}

- (IBAction)readItem:(id)sender {
//    [ABSEventTracker readPopularRecommendation];
}
@end
