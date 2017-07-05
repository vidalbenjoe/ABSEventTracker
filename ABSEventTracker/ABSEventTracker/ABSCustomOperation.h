//
//  ABSCustomOperation.h
//  EventApp
//
//  Created by  Benjoe Vidal on 22/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABSCustomOperation : NSOperation
{
    BOOL executing;
    BOOL finished;
}

@property  (strong) NSDictionary *mainDataDictionary;
/*!
 * initilize data sent by EventDispatcher
 */
-(id)initWithData:(id)dataDictionary;
@end
