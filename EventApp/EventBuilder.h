//
//  EventBuilder.h
//  EventApp
//
//  Created by Benjoe Vidal on 23/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enumerations.h"

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
@property(nonatomic) int *articleCharacterCount;
@property(nonatomic) int *rating;
@property(nonatomic) int *duration;

-(instancetype) init;


@end
