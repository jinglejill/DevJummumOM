//
//  FacebookComment.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 26/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "FacebookComment.h"

@implementation FacebookComment
//-(FacebookComment*)initWithName:(NSString *)name comment:(NSString *)comment photoPath:(NSString *)photoPath
//{
//    self = [super init];
//    if(self)
//    {
//        self.name = name;
//        self.comment = comment;
//        self.photoPath = photoPath;
//    }
//    return self;
//}
-(FacebookComment*)initWithName:(NSString *)name
{
    self = [super init];
    if(self)
    {
        self.name = name;
    }
    return self;
}
@end
