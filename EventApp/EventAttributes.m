//
//  EventAttributes.m
//  EventApp
//
//  Created by Benjoe Vidal on 22/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "EventAttributes.h"
#import "ABSEventAttributeQualifier.h"
@implementation EventAttributes
@synthesize violatedQualifiers;
-(instancetype) initWithBuilder:(EventBuilder *)builder{
    if (self = [super init]) {
        _clickedContent         = builder.clickedContent;
        _searchQuery            = builder.searchQuery;
         _actionTaken           = builder.actionTaken;
        _readArticles           = builder.readArticles;
        _articleAuthor          = builder.articleAuthor;
        _articlePostDate        = builder.articlePostDate;
        _commentContent         = builder.commentContent;
        _loginTimeStamp         = builder.loginTimeStamp;
        _likedContent           = builder.likedContent;
        _shareRetweetContent    = builder.shareRetweetContent;
        _followEntity           = builder.followEntity;

        _metaTags               = builder.metaTags;
        _previousScreen         = builder.previousScreen;
        _screenDestination      = builder.screenDestination;
        
        _latitute               = builder.latitute;
        _longitude              = builder.longitude;
        
        _articleCharacterCount  = builder.articleCharacterCount;
        _rating                 = builder.rating;
        _duration               = builder.duration;
    }
    
    return self;
}

-(EventBuilder *) makeBuilder{
    EventBuilder *builder = [EventBuilder new];
    builder.clickedContent          = _clickedContent;
    builder.searchQuery             = _searchQuery;
    builder.readArticles            = _readArticles;
    builder.articleAuthor           = _articleAuthor;
    builder.articlePostDate         = _articlePostDate;
    builder.commentContent          = _commentContent;
    builder.loginTimeStamp          = _loginTimeStamp;
    builder.likedContent            = _likedContent;
    builder.shareRetweetContent     = _shareRetweetContent;
    builder.followEntity            = _followEntity;
    builder.metaTags                = _metaTags;
    builder.previousScreen          = _previousScreen;
    builder.screenDestination       = _screenDestination;
    builder.latitute                = _latitute;
    builder.longitude               = _longitude;
    builder.articleCharacterCount   = _articleCharacterCount;
    builder.rating                  = _rating;
    builder.duration = _duration;
    return builder;
}

+(instancetype) makeWithBuilder:(void (^)(EventBuilder *))updateBlock{
    EventBuilder *builder = [EventBuilder new];
    updateBlock(builder);
    return [[EventAttributes alloc] initWithBuilder: builder];
}

-(instancetype) update:(void (^)(EventBuilder *))updateBlock{
    EventBuilder *builder = [self makeBuilder];
    updateBlock(builder);
    return [[EventAttributes alloc] initWithBuilder:builder];
}
-(instancetype) build{
    EventBuilder *builder = [EventBuilder new];
    return [self initWithBuilder:builder];
}

-(NSMutableArray *) getAttributeViolations{
    
    
    // get violated attribute from the other objecrs
    //check if the assign Qualifiers not contain new qualifiers
    // Create a set of validation per DP
    NSMutableArray *vio = [NSMutableArray array];
    [vio addObject:[ABSEventAttributeQualifier iwantTVQualifiedAttributes]];

    NSLog(@"vsio %@", vio);
    
    return vio;
}

@end
