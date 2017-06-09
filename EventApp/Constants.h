//
//  Constants.h
//  EventApp
//
//  Created by Benjoe Vidal on 01/06/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import <Foundation/Foundation.h>
#define I_WANT_TV_ID        @"com.abscbn.iwantv"
#define TFC_ID              @"com.ph.abscbn.tfc"
#define SKY_ON_DEMAND_ID    @"com.abs.cbn.sky.on.demand"
#define NEWS_ID             @"com.abs.cbn.news"
#define EVENTAPP_ID         @"com.ph.abscbn.ios.EventApp"
#define INVALID_ID          @"com.invalid"
// Used for saving to NSUserDefaults that a PIN has been set, and is the unique identifier for the Keychain.
#define PIN_SAVED @"hasSavedPIN"
// Used for saving the user's name to NSUserDefaults.
#define USERNAME @"username"
// Used to help secure the PIN.
// Ideally, this is randomly generated, but to avoid the unnecessary complexity and overhead of storing the Salt separately, we will standardize on this key.
//The reason that I want to add this is to prevent what’s called a “dictionary attack,” where someone has a whole list of pre-defined passwords and goes about trying every one of them against your password field.
#define SALT_HASH @"FvTivqTqZXsgLLx1v3P8TGRyVHaSOB1pvfm02wvGadj7RLHV8GrfxaZ84oGA8RsKdNRpxdAojXYg9iAj"

@interface Constants : NSObject
extern NSString* const eventAppsBaseURL;
extern NSString* const eventTokenURL;
extern NSString* const eventWriteURL;
extern NSString* const eventMobileResourceURL;



@end
