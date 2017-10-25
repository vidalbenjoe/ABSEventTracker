//
//  FormatUtils.h
//  EventApp
//
//  Created by Benjoe Vidal on 15/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormatUtils : NSObject
/**
 * Get current time and date
 */
+(NSString*) getCurrentTimeAndDate: (NSDate *) date;
/**
 * Date formatter
 */
+(NSString *) dateFormatter:(NSDate *) date;
/**
 * Generate randomUUID
 */
+(NSString *) randomUUID;
+(NSInteger) timeDifferenceInSeconds: (NSDate *) start endTime: (NSDate *) end;
@end
