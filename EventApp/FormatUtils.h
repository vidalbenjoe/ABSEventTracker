//
//  FormatUtils.h
//  EventApp
//
//  Created by Benjoe Vidal on 15/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormatUtils : NSObject

+(NSString *) getCurrentTimeAndDate;
+(NSString *) dateFormatter:(NSDate *) date;
+(NSString *) randomUUID;
@end
