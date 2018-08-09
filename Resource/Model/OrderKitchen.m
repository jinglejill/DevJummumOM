//
//  OrderKitchen.m
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/15/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "OrderKitchen.h"
#import "OrderTaking.h"
#import "SharedOrderKitchen.h"
#import "Menu.h"
#import "Utility.h"


@implementation OrderKitchen

-(OrderKitchen *)initWithCustomerTableID:(NSInteger)customerTableID orderTakingID:(NSInteger)orderTakingID sequenceNo:(NSInteger)sequenceNo customerTableIDOrder:(NSInteger)customerTableIDOrder
{
    self = [super init];
    if(self)
    {
        self.orderKitchenID = [OrderKitchen getNextID];
        self.customerTableID = customerTableID;
        self.orderTakingID = orderTakingID;
        self.sequenceNo = sequenceNo;
        self.customerTableIDOrder = customerTableIDOrder;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"orderKitchenID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedOrderKitchen sharedOrderKitchen].orderKitchenList;
    
    
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

+(void)addObject:(OrderKitchen *)orderKitchen
{
    NSMutableArray *dataList = [SharedOrderKitchen sharedOrderKitchen].orderKitchenList;
    [dataList addObject:orderKitchen];
}

+(void)addList:(NSMutableArray *)orderKitchenList
{
    NSMutableArray *dataList = [SharedOrderKitchen sharedOrderKitchen].orderKitchenList;
    [dataList addObjectsFromArray:orderKitchenList];
}

+(void)removeObject:(OrderKitchen *)orderKitchen
{
    NSMutableArray *dataList = [SharedOrderKitchen sharedOrderKitchen].orderKitchenList;
    [dataList removeObject:orderKitchen];
}

+(void)removeList:(NSMutableArray *)orderKitchenList
{
    NSMutableArray *dataList = [SharedOrderKitchen sharedOrderKitchen].orderKitchenList;
    [dataList removeObjectsInArray:orderKitchenList];
}

+(OrderKitchen *)getOrderKitchen:(NSInteger)orderKitchenID
{
    NSMutableArray *dataList = [SharedOrderKitchen sharedOrderKitchen].orderKitchenList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_orderKitchenID = %ld",orderKitchenID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSInteger)getNextSequenceNoWithCustomerTableID:(NSInteger)customerTableID status:(NSInteger)status
{
    NSMutableArray *orderKitchenList = [self getOrderKitchenListWithCustomerTableID:customerTableID status:status];
    orderKitchenList = [self getOrderKitchenListWithNoCustomerTableIDOrder:orderKitchenList];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_sequenceNo" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [orderKitchenList sortedArrayUsingDescriptors:sortDescriptors];
    
    if([sortArray count] > 0)
    {
        OrderKitchen *orderKitchen = sortArray[0];
        return orderKitchen.sequenceNo+1;
    }
    else
    {
        return 1;
    }
}

+(NSMutableArray *)getOrderKitchenListWithCustomerTableID:(NSInteger)customerTableID status:(NSInteger)status
{
    NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithCustomerTableID:customerTableID status:status];
    
    return [self getOrderKitchenListWithOrderTakingList:orderTakingList];
}

+(NSMutableArray *)getOrderKitchenListWithSequenceNo:(NSInteger)sequenceNo orderKitchenList:(NSMutableArray *)orderKitchenList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_sequenceNo = %ld",sequenceNo];
    NSArray *filterArray = [orderKitchenList filteredArrayUsingPredicate:predicate];
    
    
    return [filterArray mutableCopy];
}

+(OrderKitchen *)getOrderKitchenWithOrderTakingID:(NSInteger)orderTakingID
{
    NSMutableArray *dataList = [SharedOrderKitchen sharedOrderKitchen].orderKitchenList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_orderTakingID = %ld",orderTakingID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSMutableArray *)getOrderKitchenListWithMenuTypeID:(NSInteger)menuTypeID orderKitchenList:(NSMutableArray *)orderKitchenList
{
    NSMutableArray *filterOrderKitchenList = [[NSMutableArray alloc]init];
    for(OrderKitchen *item in orderKitchenList)
    {
        OrderTaking *orderTaking = [OrderTaking getOrderTaking:item.orderTakingID];
        Menu *menu = [Menu getMenu:orderTaking.menuID];
        if(menu.menuTypeID == menuTypeID)
        {
            [filterOrderKitchenList addObject:item];
        }
    }
    
    
    return filterOrderKitchenList;
}

+(NSMutableArray *)getOrderKitchenListWithOrderTakingList:(NSMutableArray *)orderTakingList
{
    NSMutableArray *orderKitchenList = [[NSMutableArray alloc]init];
    NSMutableArray *dataList = [SharedOrderKitchen sharedOrderKitchen].orderKitchenList;
    for(OrderTaking *item in orderTakingList)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_orderTakingID = %ld",item.orderTakingID];
        NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
        if([filterArray count]>0)
        {
            [orderKitchenList addObject:filterArray[0]];
        }
    }
    
    
    return orderKitchenList;
}

-(id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        ((OrderKitchen *)copy).orderKitchenID = self.orderKitchenID;
        ((OrderKitchen *)copy).customerTableID = self.customerTableID;
        ((OrderKitchen *)copy).orderTakingID = self.orderTakingID;
        ((OrderKitchen *)copy).sequenceNo = self.sequenceNo;
        ((OrderKitchen *)copy).customerTableIDOrder = self.customerTableIDOrder;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        
        
    }
    
    return copy;
}

+(NSMutableArray *)getOrderKitchenListWithNoCustomerTableIDOrder:(NSMutableArray *)orderKitchenList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_customerTableIDOrder = 0"];
    NSArray *filterArray = [orderKitchenList filteredArrayUsingPredicate:predicate];
    
    return [filterArray mutableCopy];
}

+(NSMutableArray *)getOrderKitchenListWithHaveCustomerTableIDOrder:(NSMutableArray *)orderKitchenList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_customerTableIDOrder != 0"];
    NSArray *filterArray = [orderKitchenList filteredArrayUsingPredicate:predicate];
    
    return [filterArray mutableCopy];
}

+(NSMutableArray *)getOrderKitchenListWithCustomerTableOrderID:(NSInteger)customerTableIDOrder orderKitchenList:(NSMutableArray *)orderKitchenList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_customerTableIDOrder = %ld",customerTableIDOrder];
    NSArray *filterArray = [orderKitchenList filteredArrayUsingPredicate:predicate];
    
    return [filterArray mutableCopy];
}
@end
