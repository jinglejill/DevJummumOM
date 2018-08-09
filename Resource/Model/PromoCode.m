//
//  PromoCode.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 3/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "PromoCode.h"
#import "SharedPromoCode.h"
#import "Utility.h"


@implementation PromoCode

-(PromoCode *)initWithCode:(NSString *)code rewardRedemptionID:(NSInteger)rewardRedemptionID orderNo:(NSInteger)orderNo
{
    self = [super init];
    if(self)
    {
        self.promoCodeID = [PromoCode getNextID];
        self.code = code;
        self.rewardRedemptionID = rewardRedemptionID;
        self.orderNo = orderNo;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"promoCodeID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedPromoCode sharedPromoCode].promoCodeList;
    
    
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

+(void)addObject:(PromoCode *)promoCode
{
    NSMutableArray *dataList = [SharedPromoCode sharedPromoCode].promoCodeList;
    [dataList addObject:promoCode];
}

+(void)removeObject:(PromoCode *)promoCode
{
    NSMutableArray *dataList = [SharedPromoCode sharedPromoCode].promoCodeList;
    [dataList removeObject:promoCode];
}

+(void)addList:(NSMutableArray *)promoCodeList
{
    NSMutableArray *dataList = [SharedPromoCode sharedPromoCode].promoCodeList;
    [dataList addObjectsFromArray:promoCodeList];
}

+(void)removeList:(NSMutableArray *)promoCodeList
{
    NSMutableArray *dataList = [SharedPromoCode sharedPromoCode].promoCodeList;
    [dataList removeObjectsInArray:promoCodeList];
}

+(PromoCode *)getPromoCode:(NSInteger)promoCodeID
{
    NSMutableArray *dataList = [SharedPromoCode sharedPromoCode].promoCodeList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_promoCodeID = %ld",promoCodeID];
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
        ((PromoCode *)copy).promoCodeID = self.promoCodeID;
        [copy setCode:self.code];
        ((PromoCode *)copy).rewardRedemptionID = self.rewardRedemptionID;
        ((PromoCode *)copy).orderNo = self.orderNo;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        
        
    }
    
    return copy;
}

-(BOOL)editPromoCode:(PromoCode *)editingPromoCode
{
    if(self.promoCodeID == editingPromoCode.promoCodeID
       && [self.code isEqualToString:editingPromoCode.code]
       && self.rewardRedemptionID == editingPromoCode.rewardRedemptionID
       && self.orderNo == editingPromoCode.orderNo
       )
    {
        return NO;
    }
    return YES;
}

+(PromoCode *)copyFrom:(PromoCode *)fromPromoCode to:(PromoCode *)toPromoCode
{
    toPromoCode.promoCodeID = fromPromoCode.promoCodeID;
    toPromoCode.code = fromPromoCode.code;
    toPromoCode.rewardRedemptionID = fromPromoCode.rewardRedemptionID;
    toPromoCode.orderNo = fromPromoCode.orderNo;
    toPromoCode.modifiedUser = [Utility modifiedUser];
    toPromoCode.modifiedDate = [Utility currentDateTime];
    
    return toPromoCode;
}

+(NSMutableArray *)sort:(NSMutableArray *)promoCodeList
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_rewardRedemptionSortDate" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [promoCodeList sortedArrayUsingDescriptors:sortDescriptors];
    
    return [sortArray mutableCopy];
}
@end
