//
//  Promotion.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 20/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "Promotion.h"
#import "SharedPromotion.h"
#import "Utility.h"

#import "SharedPromotion.h"
#import "Utility.h"


@implementation Promotion

-(Promotion *)initWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate discountType:(NSInteger)discountType discountAmount:(float)discountAmount minimumSpending:(NSInteger)minimumSpending maxDiscountAmountPerDay:(NSInteger)maxDiscountAmountPerDay allowEveryone:(NSInteger)allowEveryone allowDiscountForAllMenuType:(NSInteger)allowDiscountForAllMenuType noOfLimitUse:(NSInteger)noOfLimitUse noOfLimitUsePerUser:(NSInteger)noOfLimitUsePerUser noOfLimitUsePerUserPerDay:(NSInteger)noOfLimitUsePerUserPerDay voucherCode:(NSString *)voucherCode status:(NSInteger)status
{
    self = [super init];
    if(self)
    {
        self.promotionID = [Promotion getNextID];
        self.startDate = startDate;
        self.endDate = endDate;
        self.discountType = discountType;
        self.discountAmount = discountAmount;
        self.minimumSpending = minimumSpending;
        self.maxDiscountAmountPerDay = maxDiscountAmountPerDay;
        self.allowEveryone = allowEveryone;
        self.allowDiscountForAllMenuType = allowDiscountForAllMenuType;
        self.noOfLimitUse = noOfLimitUse;
        self.noOfLimitUsePerUser = noOfLimitUsePerUser;
        self.noOfLimitUsePerUserPerDay = noOfLimitUsePerUserPerDay;
        self.voucherCode = voucherCode;
        self.status = status;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"promotionID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedPromotion sharedPromotion].promotionList;
    
    
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

+(void)addObject:(Promotion *)promotion
{
    NSMutableArray *dataList = [SharedPromotion sharedPromotion].promotionList;
    [dataList addObject:promotion];
}

+(void)removeObject:(Promotion *)promotion
{
    NSMutableArray *dataList = [SharedPromotion sharedPromotion].promotionList;
    [dataList removeObject:promotion];
}

+(void)addList:(NSMutableArray *)promotionList
{
    NSMutableArray *dataList = [SharedPromotion sharedPromotion].promotionList;
    [dataList addObjectsFromArray:promotionList];
}

+(void)removeList:(NSMutableArray *)promotionList
{
    NSMutableArray *dataList = [SharedPromotion sharedPromotion].promotionList;
    [dataList removeObjectsInArray:promotionList];
}

+(Promotion *)getPromotion:(NSInteger)promotionID
{
    NSMutableArray *dataList = [SharedPromotion sharedPromotion].promotionList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_promotionID = %ld",promotionID];
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
        ((Promotion *)copy).promotionID = self.promotionID;
        [copy setStartDate:self.startDate];
        [copy setEndDate:self.endDate];
        ((Promotion *)copy).discountType = self.discountType;
        ((Promotion *)copy).discountAmount = self.discountAmount;
        ((Promotion *)copy).minimumSpending = self.minimumSpending;
        ((Promotion *)copy).maxDiscountAmountPerDay = self.maxDiscountAmountPerDay;
        ((Promotion *)copy).allowEveryone = self.allowEveryone;
        ((Promotion *)copy).allowDiscountForAllMenuType = self.allowDiscountForAllMenuType;
        ((Promotion *)copy).noOfLimitUse = self.noOfLimitUse;
        ((Promotion *)copy).noOfLimitUsePerUser = self.noOfLimitUsePerUser;
        ((Promotion *)copy).noOfLimitUsePerUserPerDay = self.noOfLimitUsePerUserPerDay;
        [copy setVoucherCode:self.voucherCode];
        ((Promotion *)copy).status = self.status;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        
        
    }
    
    return copy;
}

-(BOOL)editPromotion:(Promotion *)editingPromotion
{
    if(self.promotionID == editingPromotion.promotionID
       && [self.startDate isEqual:editingPromotion.startDate]
       && [self.endDate isEqual:editingPromotion.endDate]
       && self.discountType == editingPromotion.discountType
       && self.discountAmount == editingPromotion.discountAmount
       && self.minimumSpending == editingPromotion.minimumSpending
       && self.maxDiscountAmountPerDay == editingPromotion.maxDiscountAmountPerDay
       && self.allowEveryone == editingPromotion.allowEveryone
       && self.allowDiscountForAllMenuType == editingPromotion.allowDiscountForAllMenuType
       && self.noOfLimitUse == editingPromotion.noOfLimitUse
       && self.noOfLimitUsePerUser == editingPromotion.noOfLimitUsePerUser
       && self.noOfLimitUsePerUserPerDay == editingPromotion.noOfLimitUsePerUserPerDay
       && [self.voucherCode isEqualToString:editingPromotion.voucherCode]
       && self.status == editingPromotion.status
       )
    {
        return NO;
    }
    return YES;
}

+(Promotion *)copyFrom:(Promotion *)fromPromotion to:(Promotion *)toPromotion
{
    toPromotion.promotionID = fromPromotion.promotionID;
    toPromotion.startDate = fromPromotion.startDate;
    toPromotion.endDate = fromPromotion.endDate;
    toPromotion.discountType = fromPromotion.discountType;
    toPromotion.discountAmount = fromPromotion.discountAmount;
    toPromotion.minimumSpending = fromPromotion.minimumSpending;
    toPromotion.maxDiscountAmountPerDay = fromPromotion.maxDiscountAmountPerDay;
    toPromotion.allowEveryone = fromPromotion.allowEveryone;
    toPromotion.allowDiscountForAllMenuType = fromPromotion.allowDiscountForAllMenuType;
    toPromotion.noOfLimitUse = fromPromotion.noOfLimitUse;
    toPromotion.noOfLimitUsePerUser = fromPromotion.noOfLimitUsePerUser;
    toPromotion.noOfLimitUsePerUserPerDay = fromPromotion.noOfLimitUsePerUserPerDay;
    toPromotion.voucherCode = fromPromotion.voucherCode;
    toPromotion.status = fromPromotion.status;
    toPromotion.modifiedUser = [Utility modifiedUser];
    toPromotion.modifiedDate = [Utility currentDateTime];
    
    return toPromotion;
}


@end
