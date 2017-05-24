//
//  EventBuilder.m
//  EventApp
//
//  Created by Benjoe Vidal on 23/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "EventBuilder.h"
#import "EventAttributes.h"
#import "Enumarations.h"
@implementation EventBuilder

-(instancetype) init{
    if (self = [super init]) {
        _clickedContent         = nil;
        _searchQuery            = nil;
        
        _actionTaken            = 0;
        
        _readArticles           = nil;
        _articleAuthor          = nil;
        _articlePostDate        = nil;
        _commentContent         = nil;
        _loginTimeStamp         = nil;
        _likedContent           = nil;
        _shareRetweetContent    = nil;
        _followEntity           = nil;
        
        _metaTags               = nil;
        _previousScreen         = nil;
        _screenDestination      = nil;
        
        _latitute               = 0;
        _longitude              = 0;
        
        _articleCharacterCount  = nil;
        _rating                 = nil;
        _duration               = nil;
        
    }
    return self;
}

@end
