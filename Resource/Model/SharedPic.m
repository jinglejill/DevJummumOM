//
//  SharedPic.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 19/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedPic.h"

@implementation SharedPic
@synthesize picList;

+(SharedPic *)sharedPic {
    static dispatch_once_t pred;
    static SharedPic *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedPic alloc] init];
        shared.picList = [[NSMutableArray alloc]init];
    });
    return shared;
}

@end
