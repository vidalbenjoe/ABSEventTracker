//
//  EventAttributes.h
//  EventApp
/**********************************************************************
 **                                                                  **
 **                                                                  **
 **                        ABSEventTracker                           **
 **            Created by Benjoe Vidal on 22/05/2017.                **
 **          Copyright © 2017 ABS-CBN. All rights reserved.          **
 **                                                                  **
 **                                                                  **
 **                                                                  **
 **********************************************************************/

#import <Foundation/Foundation.h>
#import "GenericEventController.h"

@class EventBuilder;
@interface EventAttributes : NSObject

@property(nonatomic, copy, readonly) NSString *clickedContent;
@property(nonatomic, copy, readonly) NSString *errorMessage;
@property(nonatomic, copy, readonly) NSString *inputField;
@property(nonatomic, copy, readonly) NSString *searchQuery;

@property(nonatomic) ActionTaken actionTaken;

@property(nonatomic, copy, readonly) NSString *readArticle;
@property(nonatomic, copy, readonly) NSString *articleAuthor;
@property(nonatomic, copy, readonly) NSString *articlePostDate;
@property(nonatomic, copy, readonly) NSString *commentedArticle;
@property(nonatomic, copy, readonly) NSString *commentContent;
@property(nonatomic, copy, readonly) NSString *likedContent;
@property(nonatomic, copy, readonly) NSString *shareRetweetContent;
@property(nonatomic, copy, readonly) NSString *followedEntity;

@property(nonatomic, copy, readonly) NSString *metaTags;
@property(nonatomic, copy, readonly) NSString *previousView;
@property(nonatomic, copy, readonly) NSString *destinationView;
@property(nonatomic, copy, readonly) NSString *currentView;

@property(nonatomic, copy, readonly) NSString *kapamilyaName;
@property(nonatomic, copy, readonly) NSString *emailAddress;
@property(nonatomic, copy, readonly) NSString *mobileNumber;
@property(nonatomic, copy, readonly) NSString *UserName;

@property(nonatomic) float latitude;
@property(nonatomic) float longitude;
@property(nonatomic) int articleCharacterCount;
@property(nonatomic) int rating;
@property(nonatomic) int readingDuration;

+(instancetype) makeWithBuilder:(void (^) (EventBuilder *)) updateBlock;
-(instancetype) initWithBuilder:(EventBuilder *) builder;
-(instancetype) update:(void(^)(EventBuilder *)) updateBlock;
-(instancetype) build;
@end

@interface EventBuilder : NSObject
@property(nonatomic, copy) NSString *clickedContent;
@property(nonatomic, copy) NSString *errorMessage;
@property(nonatomic, copy) NSString *inputField;
@property(nonatomic, copy) NSString *searchQuery;

@property(assign, nonatomic) ActionTaken actionTaken;

@property(nonatomic, copy) NSString *readArticle;
@property(nonatomic, copy) NSString *articleAuthor;
@property(nonatomic, copy) NSString *articlePostDate;
@property(nonatomic, copy) NSString *commentedArticle;
@property(nonatomic, copy) NSString *commentContent;
@property(nonatomic, copy) NSString *likedContent;
@property(nonatomic, copy) NSString *shareRetweetContent;
@property(nonatomic, copy) NSString *followedEntity;

@property(nonatomic, copy) NSString *metaTags;
@property(nonatomic, copy) NSString *previousView;
@property(nonatomic, copy) NSString *destinationView;
@property(nonatomic, copy) NSString *currentView;


@property(nonatomic, copy) NSString *kapamilyaName;
@property(nonatomic, copy) NSString *emailAddress;
@property(nonatomic, copy) NSString *mobileNumber;
@property(nonatomic, copy) NSString *UserName;


@property(nonatomic) float latitude;
@property(nonatomic) float longitude;
@property(nonatomic) int articleCharacterCount;
@property(nonatomic) int rating;
@property(nonatomic) int readingDuration;

-(instancetype) init;

@end
