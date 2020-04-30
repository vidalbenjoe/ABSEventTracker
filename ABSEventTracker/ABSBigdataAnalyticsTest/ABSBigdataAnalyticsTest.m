//
//  ABSBigdataAnalyticsTest.m
//  ABSBigdataAnalyticsTest
//
//  Created by Benjoe Vidal on 4/29/20.
//  Copyright © 2020 ABS-CBN. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ABSEventTracker.h"


@interface ABSBigdataAnalyticsTest : XCTestCase
@property(nonatomic, strong) VideoAttributes *videoBuil;
@property(nonatomic, strong) VideoBuilder *videobuilder;
@property(nonatomic, strong) ABSEventTracker *absevent;
@end

@implementation ABSBigdataAnalyticsTest

- (void)mainTest{
//    VideoAttributes *vide = [VideoAttributes new];
//    vide.actionTaken = VIDEO_PLAYED;
    
    
}

- (void)setUp {
   
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void) testVideoAttributeSharedInstanceTest{
    VideoAttributes *video = [VideoAttributes sharedInstance];
    XCTAssertTrue(video, "Check SharedInstance");
         
}

- (void) testInitVideo{
    VideoBuilder *builder = [VideoBuilder new];
    VideoAttributes *nve = [[VideoAttributes alloc] initWithBuilder:builder];
    
     XCTAssert(nve, "Check SharedInstance");
}

-(void) testStaginInialize{
//
//    ABSEventTracker *event = [[ABSEventTracker alloc] init];
//    [ABSEventTracker initializeTracker:STAGING isEnableHTTPLogs:YES];
    
    
}


-(void) testAlphaNumeric{
   
    UserAttributes *user = [UserAttributes makeWithBuilder:^(UserBuilder *builder) {
            [builder setGigyaID:@"v"];
            
            }];
    
    NSString *str = user.gigyaID;
    NSCharacterSet *alphaSet = [NSCharacterSet alphanumericCharacterSet];
    BOOL isAlphanumeric = [[str stringByTrimmingCharactersInSet:alphaSet] isEqualToString:@""];
    
    
    XCTAssertTrue(isAlphanumeric, "GigyaisAlphaNumeric");
    
}

- (void)testExample {
   
    VideoAttributes *video = [VideoAttributes makeWithBuilder:^(VideoBuilder *builder) {
           [builder setActionTaken:VIDEO_PLAYED];
           [builder setVideoPlayPosition: 1.0];
           [builder setVideoTitle:@"La Luna Sangre Episode 1"];
           [builder setVideoURL:@"https://abs-cbn.com/lalunasangre"];
           [builder setVideoDuration:100.4];
           [builder setIsVideoFullScreen:YES];
           [builder setVideoVolume:32.4];
           [builder setVideoWidth:640];
           [builder setVideoHeight:320];
           [builder setVideoType:@".mp4"];
           [builder setVideoQuality:@"HD"];
           [builder setVideoContentID:@"ck921-321521-sfsaf-23123-gsdvsd"];
           [builder setVideoCategoryID:@"sd21c-das-231321-asfafsa-23231-asfasf"];
           [builder setVideoTimeStamp:@"11/22/1993 22:34"];
       }];
    
  
    
    XCTAssertTrue(video.actionTaken == VIDEO_PLAYED, "Test if Action taken is equal to play");
       
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}


-(void) testPlayVideoEvent{
    VideoAttributes *video = [VideoAttributes makeWithBuilder:^(VideoBuilder *builder) {
           [builder setActionTaken:VIDEO_PLAYED];
       }];
    XCTAssertTrue(video.actionTaken == VIDEO_PLAYED, "Test if Action taken is equal to play");
    XCTAssertTrue(video.actionTaken == VIDEO_PLAYED, "Test if Action taken is equal to play");
}



- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
