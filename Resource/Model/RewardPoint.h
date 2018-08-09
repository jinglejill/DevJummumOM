//
//  RewardPoint.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 9/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RewardPoint : NSObject
@property (nonatomic) NSInteger rewardPointID;
@property (nonatomic) NSInteger memberID;
@property (nonatomic) NSInteger receiptID;
@property (nonatomic) float point;
@property (nonatomic) NSInteger status;
@property (nonatomic) NSInteger promoCodeID;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;




@property (retain, nonatomic) NSDate * rewardRedemptionSortDate;

-(RewardPoint *)initWithMemberID:(NSInteger)memberID receiptID:(NSInteger)receiptID point:(float)point status:(NSInteger)status promoCodeID:(NSInteger)promoCodeID;
+(NSInteger)getNextID;
+(void)addObject:(RewardPoint *)rewardPoint;
+(void)removeObject:(RewardPoint *)rewardPoint;
+(void)addList:(NSMutableArray *)rewardPointList;
+(void)removeList:(NSMutableArray *)rewardPointList;
+(RewardPoint *)getRewardPoint:(NSInteger)rewardPointID;
-(BOOL)editRewardPoint:(RewardPoint *)editingRewardPoint;
+(RewardPoint *)copyFrom:(RewardPoint *)fromRewardPoint to:(RewardPoint *)toRewardPoint;
+(NSMutableArray *)sort:(NSMutableArray *)rewardPointList;


@end
