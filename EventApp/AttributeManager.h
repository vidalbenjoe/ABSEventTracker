//
//  AttributeManager.h
//  EventApp
//
//  Created by Benjoe Vidal on 25/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventAttributes.h"
#import "UserAttributes.h"

@interface AttributeManager : NSObject


@property(nonatomic) EventAttributes *eventattributes;
@property(nonatomic) UserAttributes *userattributes;


+(id) init;
-(void) setEventAttributes:(EventAttributes*) eventAttrib;
@end
