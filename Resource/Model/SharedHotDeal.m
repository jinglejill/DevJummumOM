//
//  SharedHotDeal.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 23/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedHotDeal.h"

@implementation SharedHotDeal
@synthesize hotDealList;

+(SharedHotDeal *)sharedHotDeal {
    static dispatch_once_t pred;
    static SharedHotDeal *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedHotDeal alloc] init];
        shared.hotDealList = [[NSMutableArray alloc]init];
    });
    return shared;
}

@end
