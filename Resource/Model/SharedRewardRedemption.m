//
//  SharedRewardRedemption.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 24/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedRewardRedemption.h"

@implementation SharedRewardRedemption
@synthesize rewardRedemptionList;

+(SharedRewardRedemption *)sharedRewardRedemption {
    static dispatch_once_t pred;
    static SharedRewardRedemption *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedRewardRedemption alloc] init];
        shared.rewardRedemptionList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
