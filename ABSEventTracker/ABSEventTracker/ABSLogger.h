//
//  ABSLogger.h
//  ABSEventTracker
//
//  Created by Benjoe Vidal on 19/07/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, LogLevel){
    LOG_SUCCESS     =   0,
    LOG_FINE        =   1,
    LOG_DEBUG       =   2,
    LOG_INFO        =   3,
    LOG_WARN        =   4,
    LOG_ERROR       =   5,
};
@interface ABSLogger : NSObject 

@property(nonatomic, weak) NSString *message;

+(instancetype) initialize;
-(NSString*) Message;
-(NSString*) getLogMessage;
@end
