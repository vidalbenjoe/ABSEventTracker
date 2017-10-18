//
//  HTTPCallBack.h
//  ABSEventTracker
/**********************************************************************
 **                                                                  **
 **                                                                  **
 **                        ABSEventTracker                           **
 **            Created by Benjoe Vidal on 10/07/2017.                **
 **          Copyright © 2017 ABS-CBN. All rights reserved.          **
 **                                                                  **
 **                                                                  **
 **                                                                  **
 **********************************************************************/
#import <Foundation/Foundation.h>

@protocol HTTPCallBack <NSObject>
@optional
-(void) onSuccess;
@optional
-(void) onFailure;
+(void) onTokenRefresh;
@end
