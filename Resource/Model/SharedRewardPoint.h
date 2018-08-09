//
//  SharedRewardPoint.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 9/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedRewardPoint : NSObject
@property (retain, nonatomic) NSMutableArray *rewardPointList;

+ (SharedRewardPoint *)sharedRewardPoint;
@end
