//
//  SharedUserRewardRedemptionUsed.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 6/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedUserRewardRedemptionUsed.h"

@implementation SharedUserRewardRedemptionUsed
@synthesize userRewardRedemptionUsedList;

+(SharedUserRewardRedemptionUsed *)sharedUserRewardRedemptionUsed {
    static dispatch_once_t pred;
    static SharedUserRewardRedemptionUsed *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedUserRewardRedemptionUsed alloc] init];
        shared.userRewardRedemptionUsedList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
