//
//  ABSEventAttributeQualifier.m
//  EventApp
//
//  Created by Benjoe Vidal on 31/05/2017.
//  Copyright © 2017 ABS-CBN. All rights reserved.
//

#import "ABSEventAttributeQualifier.h"
#import "Enumerations.h"

@implementation ABSEventAttributeQualifier
+(NSMutableArray *) iwantTVQualifiedAttributes{
    NSMutableArray *qualifiers = [[NSMutableArray alloc] initWithObjects:
                                  @"CLICKEDCONTENT",
                                  @"LATITUDE",
                                  @"LONGITUDE",
                                  @"SEACHQUERY",
                                  @"ACTIONTAKEN",
                                  @"LOGINTIMESTAMP",
                                  @"RATING",
                                  @"METATAGS",
                                  @"PREVIOUSAPP",
                                  @"TARGETAPP",nil];
    
    return qualifiers;
}
+(NSMutableArray *) skyOnDemandQualifiedAttributes{
    NSMutableArray *qualifiers = [[NSMutableArray alloc] initWithObjects:
                                  @"CLICKEDCONTENT",
                                  @"LATITUDE",
                                  @"LONGITUDE",
                                  @"SEACHQUERY",
                                  @"ACTIONTAKEN",
                                  @"LOGINTIMESTAMP",
                                  @"SHARETWEETCONTENT",
                                  @"RATING",
                                  @"METATAGS",
                                  @"PREVIOUSAPP",
                                  @"TARGETAPP",nil];
    return qualifiers;
}


+(NSMutableArray *) newsQualifiedAttributes{
    NSMutableArray *qualifiers = [[NSMutableArray alloc] initWithObjects:
                                  @"CLICKEDCONTENT",
                                  @"LATITUDE",
                                  @"LONGITUDE",
                                  @"ACTIONTAKEN",
                                  @"READARTICLE",
                                  @"ARTICLEAUTHOR",
                                  @"ARTICLEPOSTDATE",
                                  @"COMMENTCONTENT",
                                  @"ARTICLECHARACTERCOUNT",
                                  @"LOGINTIMESTAMP",
                                  @"READINGDURATIONINMILLS",
                                  @"RATING",
                                  @"METATAGS",
                                  @"PREVIOUSAPP",
                                  @"TARGETAPP",nil];
    return qualifiers;
}

+(NSMutableArray *) testQualifiedAttributes{
    NSMutableArray *qualifiers = [[NSMutableArray alloc] initWithObjects:
                                  @"CLICKEDCONTENT",
                                  @"LATITUDE",
                                  @"LONGITUDE",
                                  @"ACTIONTAKEN",
                                  @"READARTICLE",
                                  @"ARTICLEAUTHOR",
                                  @"ARTICLEPOSTDATE",
                                  @"COMMENTCONTENT",
                                  @"ARTICLECHARACTERCOUNT",
                                  @"LOGINTIMESTAMP",
                                  @"READINGDURATIONINMILLS",
                                  @"RATING",
                                  @"METATAGS",
                                  @"PREVIOUSAPP",
                                  @"TARGETAPP",nil];
    return qualifiers;
}



@end
