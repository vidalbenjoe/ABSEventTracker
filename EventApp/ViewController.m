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
#import "CacheManager.h"

@interface ViewController ()

- (IBAction)logoutButton:(id)sender;

- (IBAction)loginButton:(id)sender;
- (IBAction)facebookLikeButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageUI;
@property (weak, nonatomic) IBOutlet UITextField *serchField;

- (IBAction)readPlist:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *appTitle;
- (IBAction)clearCache:(UIButton *)sender;
@end

@implementation ViewController
@synthesize appTitle;
- (void)viewDidLoad {
    [super viewDidLoad];
    [appTitle setAdjustsFontSizeToFitWidth:TRUE];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didRecognizeTapGesture:)];
    [self.serchField.superview addGestureRecognizer:tapGesture];
    [self.imageUI.superview addGestureRecognizer:tapGesture];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)writerButton:(id)sender {
    
    EventAttributes *attrib = [EventAttributes makeWithBuilder:^(EventBuilder *builder) {
        [builder setClickedContent:@"Button"];
        [builder setSearchQuery:@"Search..."];
        [builder setActionTaken:SEARCH];
        [builder setReadArticles:@"Philstar"];
        [builder setArticleAuthor:@"Bob Ong"];
        [builder setArticlePostDate:@"June 15, 2017"];
        [builder setCommentContent:@"comment content"];
        [builder setArticleCharacterCount:4];
        [builder setFollowEntity:@"entity"];
        [builder setLikedContent:@"Liked"];
        [builder setMetaTags:@"TAGS"];
        [builder setLatitute:120.421412];
        [builder setLongitude:14.2323];
        [builder setDuration:230];
        [builder setRating:23];
        [builder setPreviousScreen:@"previous screen"];
        [builder setScreenDestination:@"screenDestination"];
    }];
    
    [ABSEventTracker initEventAttributes:attrib];
    NSLog(@"EventAttdwributes: %ld", (long)[attrib actionTaken]);
}
- (IBAction)readPlist:(UIButton *)sender {
     NSLog(@"sdadwww: %@", [CacheManager retrieveFailedAttributesFromCacheByIndex]);
}
- (IBAction)clearCache:(UIButton *)sender {
    [CacheManager removeAllCachedAttributes];
}

- (void) didRecognizeTapGesture:(UITapGestureRecognizer*) gesture {
    CGPoint point = [gesture locationInView:gesture.view];
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (CGRectContainsPoint(self.serchField.frame, point)) {
            NSLog(@"UI-ACTION: SEARCH");
            EventAttributes *attrib = [EventAttributes makeWithBuilder:^(EventBuilder *builder) {
                [builder setActionTaken:SEARCH];
            }];
            [ABSEventTracker initEventAttributes:attrib];
        }else if (CGRectContainsPoint(self.imageUI.frame, point)) {
            NSLog(@"UI-ACTION: IMAGE_TAP");
            EventAttributes *attrib = [EventAttributes makeWithBuilder:^(EventBuilder *builder) {
                [builder setActionTaken:CLICK_IMAGE];
            }];
            [ABSEventTracker initEventAttributes:attrib];
        }

    }
}

- (IBAction)logoutButton:(id)sender {
    EventAttributes *attrib = [EventAttributes makeWithBuilder:^(EventBuilder *builder) {
        [builder setActionTaken:LOGOUT];
    }];
    [ABSEventTracker initEventAttributes:attrib];
}

- (IBAction)loginButton:(id)sender {
    NSLog(@"UI-ACTION: LOGIN");
    UserAttributes *user = [UserAttributes makeWithBuilder:^(UserBuilder *builder) {
        [builder setFirstName:@"Benjoe"];
        [builder setLastName:@"Vidal"];
        [builder setMiddleName:@"Rivera"];
        [builder setSsoID:@"SSOID"];
        [builder setGigyaID:@"GIGYAID"];
    }];
    [ABSEventTracker initWithUser:user];

}

- (IBAction)facebookLikeButton:(id)sender {
    NSLog(@"UI-ACTION: FACEBOOK LIKE");
    EventAttributes *attrib = [EventAttributes makeWithBuilder:^(EventBuilder *builder) {
        [builder setActionTaken:FACEBOOK_LIKE];
    }];
    
    [ABSEventTracker initEventAttributes:attrib];
}
@end
