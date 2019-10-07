//
//  EventAttributes.m
//  EventApp
//
//  Created by Benjoe Vidal on 22/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "EventAttributes.h"
@implementation EventAttributes

-(instancetype) initWithBuilder:(EventBuilder *)builder{
    if (self = [super init]) {
        
        _clickedContent         = builder.clickedContent;
        _errorMessage           = builder.errorMessage;
        _inputField             = builder.inputField;
        _searchQuery            = builder.searchQuery;
        _actionTaken            = builder.actionTaken;
        _readArticle            = builder.readArticle;
        _articleAuthor          = builder.articleAuthor;
        _articlePostDate        = builder.articlePostDate;
        _commentedArticle       = builder.commentedArticle;
        _commentContent         = builder.commentContent;
        _likedContent           = builder.likedContent;
        _shareRetweetContent    = builder.shareRetweetContent;
        _followedEntity         = builder.followedEntity;
        
        _metaTags               = builder.metaTags;
        _previousView           = builder.previousView;
        _destinationView        = builder.destinationView;
        _currentView            = builder.currentView;
        _kapamilyaName          = builder.kapamilyaName;
        _emailAddress           = builder.emailAddress;
        _mobileNumber           = builder.mobileNumber;
        
        _latitude               = builder.latitude;
        _longitude              = builder.longitude;
        
        _articleCharacterCount  = builder.articleCharacterCount;
        _rating                 = builder.rating;
        _readingDuration        = builder.readingDuration;
    }
    
    return self;
}

-(EventBuilder *) makeBuilder{
    EventBuilder *builder = [EventBuilder new];
    builder.actionTaken             = _actionTaken;
    builder.clickedContent          = _clickedContent;
    builder.errorMessage            = _errorMessage;
    builder.inputField              = _inputField;
    builder.searchQuery             = _searchQuery;
    builder.readArticle             = _readArticle;
    builder.articleAuthor           = _articleAuthor;
    builder.articlePostDate         = _articlePostDate;
    builder.commentedArticle        = _commentedArticle;
    builder.commentContent          = _commentContent;
    builder.likedContent            = _likedContent;
    builder.shareRetweetContent     = _shareRetweetContent;
    builder.followedEntity          = _followedEntity;
    builder.metaTags                = _metaTags;
    builder.previousView            = _previousView;
    builder.destinationView         = _destinationView;
    builder.currentView             = _currentView;
    builder.kapamilyaName           = _kapamilyaName;
    builder.emailAddress            = _emailAddress;
    builder.mobileNumber            = _mobileNumber;
    builder.latitude                = _latitude;
    builder.longitude               = _longitude;
    builder.articleCharacterCount   = _articleCharacterCount;
    builder.rating                  = _rating;
    builder.readingDuration         = _readingDuration;
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

@end

@implementation EventBuilder

-(instancetype) init{
    if (self = [super init]) {
        _clickedContent         = nil;
        _errorMessage           = nil;
        _inputField             = nil;
        _searchQuery            = nil;
        
        _readArticle            = nil;
        _articleAuthor          = nil;
        _articlePostDate        = nil;
        _commentedArticle       = nil;
        _commentContent         = nil;
        _likedContent           = nil;
        _shareRetweetContent    = nil;
        _followedEntity         = nil;
        
        _metaTags               = nil;
        _previousView           = nil;
        _destinationView        = nil;
        _currentView            = nil;
        
        _kapamilyaName              =   nil;
        _emailAddress               =   nil;
        _mobileNumber               =   nil;
        
        _actionTaken            = 0;
        _latitude               = 0;
        _longitude              = 0;
        
        _articleCharacterCount  = 0;
        _rating                 = 0;
        _readingDuration        = 0;
        
    }
    return self;
}

@end


