//
//  RewardRedemption.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 24/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RewardRedemption : NSObject
@property (nonatomic) NSInteger rewardRedemptionID;
@property (nonatomic) NSInteger branchID;
@property (retain, nonatomic) NSDate * startDate;
@property (retain, nonatomic) NSDate * endDate;
@property (retain, nonatomic) NSString * header;
@property (retain, nonatomic) NSString * subTitle;
@property (retain, nonatomic) NSString * imageUrl;
@property (nonatomic) NSInteger point;
@property (retain, nonatomic) NSString * prefixPromoCode;
@property (retain, nonatomic) NSString * suffixPromoCode;
@property (nonatomic) NSInteger rewardLimit;
@property (nonatomic) NSInteger withInPeriod;
@property (retain, nonatomic) NSString * detail;
@property (retain, nonatomic) NSString * termsConditions;
@property (retain, nonatomic) NSDate * usingStartDate;
@property (retain, nonatomic) NSDate * usingEndDate;
@property (nonatomic) NSInteger discountType;
@property (nonatomic) float discountAmount;
@property (nonatomic) NSInteger minimumSpending;
@property (nonatomic) NSInteger maxDiscountAmountPerDay;
@property (nonatomic) NSInteger allowDiscountForAllMenuType;
@property (nonatomic) NSInteger orderNo;
@property (nonatomic) NSInteger status;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;






@property (retain, nonatomic) NSString * branchName;
@property (retain, nonatomic) NSDate * sortDate;
-(RewardRedemption *)initWithBranchID:(NSInteger)branchID startDate:(NSDate *)startDate endDate:(NSDate *)endDate header:(NSString *)header subTitle:(NSString *)subTitle imageUrl:(NSString *)imageUrl point:(NSInteger)point prefixPromoCode:(NSString *)prefixPromoCode suffixPromoCode:(NSString *)suffixPromoCode rewardLimit:(NSInteger)rewardLimit withInPeriod:(NSInteger)withInPeriod detail:(NSString *)detail termsConditions:(NSString *)termsConditions usingStartDate:(NSDate *)usingStartDate usingEndDate:(NSDate *)usingEndDate discountType:(NSInteger)discountType discountAmount:(float)discountAmount minimumSpending:(NSInteger)minimumSpending maxDiscountAmountPerDay:(NSInteger)maxDiscountAmountPerDay allowDiscountForAllMenuType:(NSInteger)allowDiscountForAllMenuType orderNo:(NSInteger)orderNo status:(NSInteger)status;
+(NSInteger)getNextID;
+(void)addObject:(RewardRedemption *)rewardRedemption;
+(void)removeObject:(RewardRedemption *)rewardRedemption;
+(void)addList:(NSMutableArray *)rewardRedemptionList;
+(void)removeList:(NSMutableArray *)rewardRedemptionList;
+(RewardRedemption *)getRewardRedemption:(NSInteger)rewardRedemptionID;
-(BOOL)editRewardRedemption:(RewardRedemption *)editingRewardRedemption;
+(RewardRedemption *)copyFrom:(RewardRedemption *)fromRewardRedemption to:(RewardRedemption *)toRewardRedemption;
+(NSMutableArray *)sort:(NSMutableArray *)rewardRedemptionList;

@end
