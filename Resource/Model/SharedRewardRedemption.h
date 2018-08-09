//
//  SharedRewardRedemption.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 24/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedRewardRedemption : NSObject
@property (retain, nonatomic) NSMutableArray *rewardRedemptionList;

+ (SharedRewardRedemption *)sharedRewardRedemption;
@end
