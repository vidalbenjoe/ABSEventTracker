//
//  UserToItem.h
//  ABSEventTracker
/**********************************************************************
 **                                                                  **
 **                                                                  **
 **                        ABSEventTracker                           **
 **            Created by Benjoe Vidal on 30/08/2017.                **
 **          Copyright © 2017 ABS-CBN. All rights reserved.          **
 **                                                                  **
 **                                                                  **
 **                                                                  **
 **********************************************************************/
#import <Foundation/Foundation.h>

@interface UserToItem : NSObject
@property(nonatomic, strong) NSString *categoryID;
@property(nonatomic, strong) NSString *contentID;
@property(nonatomic) double rating;

-(instancetype) initWithDictionary:(NSDictionary *) item;
@end
