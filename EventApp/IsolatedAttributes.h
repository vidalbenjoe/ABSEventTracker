//
//  IsolatedAttributes.h
//  EventApp
//
//  Created by Benjoe Vidal on 29/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IsolatedAttributes : NSObject
@property(nonatomic, copy, readonly) NSString *applicationLoadTimeStamp;
@property(nonatomic, copy, readonly) NSString *applicationAbandonTimeStamp;
@property(nonatomic, copy, readonly) NSString *postCommentTimeStamp;
@property(nonatomic, copy, readonly) NSString *logoutTimeStamp;
@property(nonatomic, copy, readonly) NSString *bigdateSessionID;
@property(nonatomic, copy, readonly) NSString *sessionStartTimeStamp;
@property(nonatomic, copy, readonly) NSString *sessionEndTimeStamp;
@property(nonatomic, copy, readonly) NSString *searchTimeStamp;
@end
