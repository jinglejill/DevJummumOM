//
//  RewardRedemption.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 24/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "RewardRedemption.h"
#import "SharedRewardRedemption.h"
#import "Utility.h"


@implementation RewardRedemption

-(RewardRedemption *)initWithBranchID:(NSInteger)branchID startDate:(NSDate *)startDate endDate:(NSDate *)endDate header:(NSString *)header subTitle:(NSString *)subTitle imageUrl:(NSString *)imageUrl point:(NSInteger)point prefixPromoCode:(NSString *)prefixPromoCode suffixPromoCode:(NSString *)suffixPromoCode rewardLimit:(NSInteger)rewardLimit withInPeriod:(NSInteger)withInPeriod detail:(NSString *)detail termsConditions:(NSString *)termsConditions usingStartDate:(NSDate *)usingStartDate usingEndDate:(NSDate *)usingEndDate discountType:(NSInteger)discountType discountAmount:(float)discountAmount minimumSpending:(NSInteger)minimumSpending maxDiscountAmountPerDay:(NSInteger)maxDiscountAmountPerDay allowDiscountForAllMenuType:(NSInteger)allowDiscountForAllMenuType orderNo:(NSInteger)orderNo status:(NSInteger)status
{
    self = [super init];
    if(self)
    {
        self.rewardRedemptionID = [RewardRedemption getNextID];
        self.branchID = branchID;
        self.startDate = startDate;
        self.endDate = endDate;
        self.header = header;
        self.subTitle = subTitle;
        self.imageUrl = imageUrl;
        self.point = point;
        self.prefixPromoCode = prefixPromoCode;
        self.suffixPromoCode = suffixPromoCode;
        self.rewardLimit = rewardLimit;
        self.withInPeriod = withInPeriod;
        self.detail = detail;
        self.termsConditions = termsConditions;
        self.usingStartDate = usingStartDate;
        self.usingEndDate = usingEndDate;
        self.discountType = discountType;
        self.discountAmount = discountAmount;
        self.minimumSpending = minimumSpending;
        self.maxDiscountAmountPerDay = maxDiscountAmountPerDay;
        self.allowDiscountForAllMenuType = allowDiscountForAllMenuType;
        self.orderNo = orderNo;
        self.status = status;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"rewardRedemptionID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedRewardRedemption sharedRewardRedemption].rewardRedemptionList;
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:propertyName ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [dataList sortedArrayUsingDescriptors:sortDescriptors];
    dataList = [sortArray mutableCopy];
    
    if([dataList count] == 0)
    {
        return -1;
    }
    else
    {
        id value = [dataList[0] valueForKey:primaryKeyName];
        if([value integerValue]>0)
        {
            return -1;
        }
        else
        {
            return [value integerValue]-1;
        }
    }
}

+(void)addObject:(RewardRedemption *)rewardRedemption
{
    NSMutableArray *dataList = [SharedRewardRedemption sharedRewardRedemption].rewardRedemptionList;
    [dataList addObject:rewardRedemption];
}

+(void)removeObject:(RewardRedemption *)rewardRedemption
{
    NSMutableArray *dataList = [SharedRewardRedemption sharedRewardRedemption].rewardRedemptionList;
    [dataList removeObject:rewardRedemption];
}

+(void)addList:(NSMutableArray *)rewardRedemptionList
{
    NSMutableArray *dataList = [SharedRewardRedemption sharedRewardRedemption].rewardRedemptionList;
    [dataList addObjectsFromArray:rewardRedemptionList];
}

+(void)removeList:(NSMutableArray *)rewardRedemptionList
{
    NSMutableArray *dataList = [SharedRewardRedemption sharedRewardRedemption].rewardRedemptionList;
    [dataList removeObjectsInArray:rewardRedemptionList];
}

+(RewardRedemption *)getRewardRedemption:(NSInteger)rewardRedemptionID
{
    NSMutableArray *dataList = [SharedRewardRedemption sharedRewardRedemption].rewardRedemptionList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_rewardRedemptionID = %ld",rewardRedemptionID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

-(id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        ((RewardRedemption *)copy).rewardRedemptionID = self.rewardRedemptionID;
        ((RewardRedemption *)copy).branchID = self.branchID;
        [copy setStartDate:self.startDate];
        [copy setEndDate:self.endDate];
        [copy setHeader:self.header];
        [copy setSubTitle:self.subTitle];
        [copy setImageUrl:self.imageUrl];
        ((RewardRedemption *)copy).point = self.point;
        [copy setPrefixPromoCode:self.prefixPromoCode];
        [copy setSuffixPromoCode:self.suffixPromoCode];
        ((RewardRedemption *)copy).rewardLimit = self.rewardLimit;
        ((RewardRedemption *)copy).withInPeriod = self.withInPeriod;
        [copy setDetail:self.detail];
        [copy setTermsConditions:self.termsConditions];
        [copy setUsingStartDate:self.usingStartDate];
        [copy setUsingEndDate:self.usingEndDate];
        ((RewardRedemption *)copy).discountType = self.discountType;
        ((RewardRedemption *)copy).discountAmount = self.discountAmount;
        ((RewardRedemption *)copy).minimumSpending = self.minimumSpending;
        ((RewardRedemption *)copy).maxDiscountAmountPerDay = self.maxDiscountAmountPerDay;
        ((RewardRedemption *)copy).allowDiscountForAllMenuType = self.allowDiscountForAllMenuType;
        ((RewardRedemption *)copy).orderNo = self.orderNo;
        ((RewardRedemption *)copy).status = self.status;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        
        
    }
    
    return copy;
}

-(BOOL)editRewardRedemption:(RewardRedemption *)editingRewardRedemption
{
    if(self.rewardRedemptionID == editingRewardRedemption.rewardRedemptionID
       && self.branchID == editingRewardRedemption.branchID
       && [self.startDate isEqual:editingRewardRedemption.startDate]
       && [self.endDate isEqual:editingRewardRedemption.endDate]
       && [self.header isEqualToString:editingRewardRedemption.header]
       && [self.subTitle isEqualToString:editingRewardRedemption.subTitle]
       && [self.imageUrl isEqualToString:editingRewardRedemption.imageUrl]
       && self.point == editingRewardRedemption.point
       && [self.prefixPromoCode isEqualToString:editingRewardRedemption.prefixPromoCode]
       && [self.suffixPromoCode isEqualToString:editingRewardRedemption.suffixPromoCode]
       && self.rewardLimit == editingRewardRedemption.rewardLimit
       && self.withInPeriod == editingRewardRedemption.withInPeriod
       && [self.detail isEqualToString:editingRewardRedemption.detail]
       && [self.termsConditions isEqualToString:editingRewardRedemption.termsConditions]
       && [self.usingStartDate isEqual:editingRewardRedemption.usingStartDate]
       && [self.usingEndDate isEqual:editingRewardRedemption.usingEndDate]
       && self.discountType == editingRewardRedemption.discountType
       && self.discountAmount == editingRewardRedemption.discountAmount
       && self.minimumSpending == editingRewardRedemption.minimumSpending
       && self.maxDiscountAmountPerDay == editingRewardRedemption.maxDiscountAmountPerDay
       && self.allowDiscountForAllMenuType == editingRewardRedemption.allowDiscountForAllMenuType
       && self.orderNo == editingRewardRedemption.orderNo
       && self.status == editingRewardRedemption.status
       )
    {
        return NO;
    }
    return YES;
}

+(RewardRedemption *)copyFrom:(RewardRedemption *)fromRewardRedemption to:(RewardRedemption *)toRewardRedemption
{
    toRewardRedemption.rewardRedemptionID = fromRewardRedemption.rewardRedemptionID;
    toRewardRedemption.branchID = fromRewardRedemption.branchID;
    toRewardRedemption.startDate = fromRewardRedemption.startDate;
    toRewardRedemption.endDate = fromRewardRedemption.endDate;
    toRewardRedemption.header = fromRewardRedemption.header;
    toRewardRedemption.subTitle = fromRewardRedemption.subTitle;
    toRewardRedemption.imageUrl = fromRewardRedemption.imageUrl;
    toRewardRedemption.point = fromRewardRedemption.point;
    toRewardRedemption.prefixPromoCode = fromRewardRedemption.prefixPromoCode;
    toRewardRedemption.suffixPromoCode = fromRewardRedemption.suffixPromoCode;
    toRewardRedemption.rewardLimit = fromRewardRedemption.rewardLimit;
    toRewardRedemption.withInPeriod = fromRewardRedemption.withInPeriod;
    toRewardRedemption.detail = fromRewardRedemption.detail;
    toRewardRedemption.termsConditions = fromRewardRedemption.termsConditions;
    toRewardRedemption.usingStartDate = fromRewardRedemption.usingStartDate;
    toRewardRedemption.usingEndDate = fromRewardRedemption.usingEndDate;
    toRewardRedemption.discountType = fromRewardRedemption.discountType;
    toRewardRedemption.discountAmount = fromRewardRedemption.discountAmount;
    toRewardRedemption.minimumSpending = fromRewardRedemption.minimumSpending;
    toRewardRedemption.maxDiscountAmountPerDay = fromRewardRedemption.maxDiscountAmountPerDay;
    toRewardRedemption.allowDiscountForAllMenuType = fromRewardRedemption.allowDiscountForAllMenuType;
    toRewardRedemption.orderNo = fromRewardRedemption.orderNo;
    toRewardRedemption.status = fromRewardRedemption.status;
    toRewardRedemption.modifiedUser = [Utility modifiedUser];
    toRewardRedemption.modifiedDate = [Utility currentDateTime];
    
    return toRewardRedemption;
}


+(NSMutableArray *)sort:(NSMutableArray *)rewardRedemptionList
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_sortDate" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [rewardRedemptionList sortedArrayUsingDescriptors:sortDescriptors];
    
    return [sortArray mutableCopy];
}
@end

