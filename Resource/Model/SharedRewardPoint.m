//
//  SharedRewardPoint.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 9/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedRewardPoint.h"

@implementation SharedRewardPoint
@synthesize rewardPointList;

+(SharedRewardPoint *)sharedRewardPoint {
    static dispatch_once_t pred;
    static SharedRewardPoint *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedRewardPoint alloc] init];
        shared.rewardPointList = [[NSMutableArray alloc]init];
    });
    return shared;
}

@end
