//
//  EventAttributes.h
//  EventApp
//
//  Created by Benjoe Vidal on 22/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Action.h"
@class EventBuilder;
@interface EventAttributes : NSObject
@property(nonatomic, copy, readonly) NSString *clickedContent;
@property(nonatomic, copy, readonly) NSString *searchQuery;

@property(nonatomic) ActionTaken actionTaken;

@property(nonatomic, copy, readonly) NSString *readArticles;
@property(nonatomic, copy, readonly) NSString *articleAuthor;
@property(nonatomic, copy, readonly) NSString *articlePostDate;
@property(nonatomic, copy, readonly) NSString *commentContent;
@property(nonatomic, copy, readonly) NSString *loginTimeStamp;
@property(nonatomic, copy, readonly) NSString *likedContent;
@property(nonatomic, copy, readonly) NSString *shareRetweetContent;
@property(nonatomic, copy, readonly) NSString *followEntity;

@property(nonatomic, copy, readonly) NSString *metaTags;
@property(nonatomic, copy, readonly) NSString *previousScreen;
@property(nonatomic, copy, readonly) NSString *screenDestination;

@property(nonatomic) float latitute;
@property(nonatomic) float longitude;
@property(nonatomic) int articleCharacterCount;
@property(nonatomic) int rating;
@property(nonatomic) int duration;

+(instancetype) makeWithBuilder:(void (^) (EventBuilder *)) updateBlock;
-(instancetype) initWithBuilder:(EventBuilder *) builder;
-(instancetype) update:(void(^)(EventBuilder *)) updateBlock;
-(instancetype) build;

@end

@interface EventBuilder : NSObject
@property(nonatomic, copy) NSString *clickedContent;
@property(nonatomic, copy) NSString *searchQuery;

@property(nonatomic) ActionTaken actionTaken;

@property(nonatomic, copy) NSString *readArticles;
@property(nonatomic, copy) NSString *articleAuthor;
@property(nonatomic, copy) NSString *articlePostDate;
@property(nonatomic, copy) NSString *commentContent;
@property(nonatomic, copy) NSString *loginTimeStamp;
@property(nonatomic, copy) NSString *likedContent;
@property(nonatomic, copy) NSString *shareRetweetContent;
@property(nonatomic, copy) NSString *followEntity;

@property(nonatomic, copy) NSString *metaTags;
@property(nonatomic, copy) NSString *previousScreen;
@property(nonatomic, copy) NSString *screenDestination;

@property(nonatomic) float latitute;
@property(nonatomic) float longitude;
@property(nonatomic) int articleCharacterCount;
@property(nonatomic) int rating;
@property(nonatomic) int duration;

-(instancetype) init;


@end



