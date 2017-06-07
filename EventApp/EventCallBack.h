//
//  EventCallBack.h
//  EventApp
//
//  Created by Benjoe Vidal on 24/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EventCallBack <NSObject>
-(void) onSuccess;
-(void) onFailure;
-(void) onTokenRefresh;
-(void) onSecurityCodeRefresh;
@end
