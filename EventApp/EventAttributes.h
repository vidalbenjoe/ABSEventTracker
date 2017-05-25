//
//  EventAttributes.h
//  EventApp
//
//  Created by Benjoe Vidal on 22/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventBuilder.h"

@interface EventAttributes : NSObject

@property(nonatomic, retain, readonly, getter= clickedContents) NSString *clickedContent;
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
@property(nonatomic) NSInteger *articleCharacterCount;
@property(nonatomic) NSInteger *rating;
@property(nonatomic) NSInteger *duration;

+(instancetype) makeWithBuilder:(void (^) (EventBuilder *)) updateBlock;
-(instancetype) initWithBuilder:(EventBuilder *) builder;
-(instancetype) update:(void(^)(EventBuilder *)) updateBlock;
-(instancetype) build;

@end


