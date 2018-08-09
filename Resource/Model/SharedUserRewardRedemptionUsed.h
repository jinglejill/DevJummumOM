//
//  SharedUserRewardRedemptionUsed.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 6/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedUserRewardRedemptionUsed : NSObject
@property (retain, nonatomic) NSMutableArray *userRewardRedemptionUsedList;

+ (SharedUserRewardRedemptionUsed *)sharedUserRewardRedemptionUsed;
@end
