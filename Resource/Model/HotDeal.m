//
//  HotDeal.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 23/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "HotDeal.h"
#import "SharedHotDeal.h"
#import "Utility.h"


@implementation HotDeal

-(HotDeal *)initWithBranchID:(NSInteger)branchID startDate:(NSDate *)startDate endDate:(NSDate *)endDate header:(NSString *)header subTitle:(NSString *)subTitle imageUrl:(NSString *)imageUrl orderNo:(NSInteger)orderNo status:(NSInteger)status
{
    self = [super init];
    if(self)
    {
        self.hotDealID = [HotDeal getNextID];
        self.branchID = branchID;
        self.startDate = startDate;
        self.endDate = endDate;
        self.header = header;
        self.subTitle = subTitle;
        self.imageUrl = imageUrl;
        self.orderNo = orderNo;
        self.status = status;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"hotDealID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedHotDeal sharedHotDeal].hotDealList;
    
    
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

+(void)addObject:(HotDeal *)hotDeal
{
    NSMutableArray *dataList = [SharedHotDeal sharedHotDeal].hotDealList;
    [dataList addObject:hotDeal];
}

+(void)removeObject:(HotDeal *)hotDeal
{
    NSMutableArray *dataList = [SharedHotDeal sharedHotDeal].hotDealList;
    [dataList removeObject:hotDeal];
}

+(void)addList:(NSMutableArray *)hotDealList
{
    NSMutableArray *dataList = [SharedHotDeal sharedHotDeal].hotDealList;
    [dataList addObjectsFromArray:hotDealList];
}

+(void)removeList:(NSMutableArray *)hotDealList
{
    NSMutableArray *dataList = [SharedHotDeal sharedHotDeal].hotDealList;
    [dataList removeObjectsInArray:hotDealList];
}

+(HotDeal *)getHotDeal:(NSInteger)hotDealID
{
    NSMutableArray *dataList = [SharedHotDeal sharedHotDeal].hotDealList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_hotDealID = %ld",hotDealID];
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
        ((HotDeal *)copy).hotDealID = self.hotDealID;
        ((HotDeal *)copy).branchID = self.branchID;
        [copy setStartDate:self.startDate];
        [copy setEndDate:self.endDate];
        [copy setHeader:self.header];
        [copy setSubTitle:self.subTitle];
        [copy setImageUrl:self.imageUrl];
        ((HotDeal *)copy).orderNo = self.orderNo;
        ((HotDeal *)copy).status = self.status;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        
        
    }
    
    return copy;
}

-(BOOL)editHotDeal:(HotDeal *)editingHotDeal
{
    if(self.hotDealID == editingHotDeal.hotDealID
       && self.branchID == editingHotDeal.branchID
       && [self.startDate isEqual:editingHotDeal.startDate]
       && [self.endDate isEqual:editingHotDeal.endDate]
       && [self.header isEqualToString:editingHotDeal.header]
       && [self.subTitle isEqualToString:editingHotDeal.subTitle]
       && [self.imageUrl isEqualToString:editingHotDeal.imageUrl]
       && self.orderNo == editingHotDeal.orderNo
       && self.status == editingHotDeal.status
       )
    {
        return NO;
    }
    return YES;
}

+(HotDeal *)copyFrom:(HotDeal *)fromHotDeal to:(HotDeal *)toHotDeal
{
    toHotDeal.hotDealID = fromHotDeal.hotDealID;
    toHotDeal.branchID = fromHotDeal.branchID;
    toHotDeal.startDate = fromHotDeal.startDate;
    toHotDeal.endDate = fromHotDeal.endDate;
    toHotDeal.header = fromHotDeal.header;
    toHotDeal.subTitle = fromHotDeal.subTitle;
    toHotDeal.imageUrl = fromHotDeal.imageUrl;
    toHotDeal.orderNo = fromHotDeal.orderNo;
    toHotDeal.status = fromHotDeal.status;
    toHotDeal.modifiedUser = [Utility modifiedUser];
    toHotDeal.modifiedDate = [Utility currentDateTime];
    
    return toHotDeal;
}




















@end
