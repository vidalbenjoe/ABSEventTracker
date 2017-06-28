//
//  KSCustomOperation.h
//  EventApp
//
//  Created by Flydubai on 22/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSCustomOperation : NSOperation
{
    BOOL executing;
    BOOL finished;
}

@property  (strong) NSDictionary *mainDataDictionary;
-(id)initWithData:(id)dataDictionary;
@end
