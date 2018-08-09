//
//  OrderTaking.m
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/10/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "OrderTaking.h"
#import "SharedOrderTaking.h"
#import "SharedCurrentOrderTaking.h"
#import "OrderNote.h"
#import "Menu.h"
#import "Utility.h"
#import "Receipt.h"
#import "MenuType.h"
#import "SubMenuType.h"
//#import "OrderCancelDiscount.h"


@implementation OrderTaking

-(OrderTaking *)initWithBranchID:(NSInteger)branchID customerTableID:(NSInteger)customerTableID menuID:(NSInteger)menuID quantity:(float)quantity specialPrice:(float)specialPrice price:(float)price takeAway:(NSInteger)takeAway noteIDListInText:(NSString *)noteIDListInText orderNo:(NSInteger)orderNo status:(NSInteger)status receiptID:(NSInteger)receiptID
{
    self = [super init];
    if(self)
    {
        self.orderTakingID = [OrderTaking getNextID];
        self.branchID = branchID;
        self.customerTableID = customerTableID;
        self.menuID = menuID;
        self.quantity = quantity;
        self.specialPrice = specialPrice;
        self.price = price;
        self.takeAway = takeAway;
        self.noteIDListInText = noteIDListInText;
        self.orderNo = orderNo;
        self.status = status;
        self.receiptID = receiptID;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"orderTakingID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
    
    
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

+(void)addObject:(OrderTaking *)orderTaking
{
    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
    [dataList addObject:orderTaking];
}

+(void)removeObject:(OrderTaking *)orderTaking
{
    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
    [dataList removeObject:orderTaking];
}

+(void)addList:(NSMutableArray *)orderTakingList
{
    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
    [dataList addObjectsFromArray:orderTakingList];
}

+(void)removeList:(NSMutableArray *)orderTakingList
{
    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
    [dataList removeObjectsInArray:orderTakingList];
}

+(OrderTaking *)getOrderTaking:(NSInteger)orderTakingID
{
    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_orderTakingID = %ld",orderTakingID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(OrderTaking *)getOrderTakingWithCustomerTableID:(NSInteger)customerTableID menuID:(NSInteger)menuID takeAway:(NSInteger)takeAway noteIDListInText:(NSString *)noteIDListInText status:(NSInteger)status;
{
    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_customerTableID = %ld and _menuID = %ld and _takeAway = %ld and _noteIDListInText = %@ and _status = %ld",customerTableID,menuID,takeAway,noteIDListInText,status];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSMutableArray *)getOrderTakingListWithStatus:(NSInteger)status orderTakingList:(NSMutableArray *)orderTakingList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_status = %ld",status];
    NSArray *filterArray = [orderTakingList filteredArrayUsingPredicate:predicate];
    
    return [filterArray mutableCopy];
}

+(NSMutableArray *)getOrderTakingListWithCustomerTableID:(NSInteger)customerTableID status:(NSInteger)status
{
    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_customerTableID = %ld and _status = %ld",customerTableID,status];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    return [filterArray mutableCopy];
}

+(NSMutableArray *)getOrderTakingListWithCustomerTableID:(NSInteger)customerTableID statusList:(NSArray *)statusList
{
    NSMutableArray *allOrderTakingList = [[NSMutableArray alloc]init];
    for(NSNumber *item in statusList)
    {
        [allOrderTakingList addObjectsFromArray:[self getOrderTakingListWithCustomerTableID:customerTableID status:[item integerValue]]];
    }
    return allOrderTakingList;
}

+(NSInteger)getTotalQuantity:(NSMutableArray *)orderTakingList
{
    NSInteger sum = 0;
    for(OrderTaking *item in orderTakingList)
    {
        sum += item.quantity;
    }
    return sum;
}

+(NSInteger)getSubTotalAmount:(NSMutableArray *)orderTakingList
{
    float sum = 0;
    for(OrderTaking *item in orderTakingList)
    {
        sum += item.quantity*item.specialPrice;
    }
    return sum;
}

+(NSInteger)getSubTotalAmountAllowDiscount:(NSMutableArray *)orderTakingList
{
    float sum = 0;
    for(OrderTaking *item in orderTakingList)
    {
        Menu *menu = [Menu getMenu:item.menuID branchID:item.branchID];
        MenuType *menuType = [MenuType getMenuType:menu.menuTypeID];
        if(menuType.allowDiscount)
        {
            sum += item.quantity*item.specialPrice;
        }
    }
    return sum;
}

-(id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        ((OrderTaking *)copy).orderTakingID = self.orderTakingID;
        ((OrderTaking *)copy).branchID = self.branchID;
        ((OrderTaking *)copy).customerTableID = self.customerTableID;
        ((OrderTaking *)copy).menuID = self.menuID;
        ((OrderTaking *)copy).quantity = self.quantity;
        ((OrderTaking *)copy).specialPrice = self.specialPrice;
        ((OrderTaking *)copy).price = self.price;
        ((OrderTaking *)copy).takeAway = self.takeAway;
        [copy setNoteIDListInText:self.noteIDListInText];
        ((OrderTaking *)copy).orderNo = self.orderNo;
        ((OrderTaking *)copy).status = self.status;
        ((OrderTaking *)copy).receiptID = self.receiptID;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        
        
        ((OrderTaking *)copy).menuOrderNo = self.menuOrderNo;
    }
    
    return copy;
}

+(NSMutableArray *)sortOrderTakingList:(NSMutableArray *)orderTakingList
{
    for(OrderTaking *item in orderTakingList)
    {
        Menu *menu = [Menu getMenu:item.menuID];
        item.menuOrderNo = menu.orderNo;
        SubMenuType *subMenuType = [SubMenuType getSubMenuType:menu.subMenuTypeID];
        item.subMenuOrderNo = subMenuType.orderNo;
        MenuType *menuType = [MenuType getMenuType:menu.menuTypeID];
        item.menuTypeOrderNo = menuType.orderNo;
        
        
//        OrderCancelDiscount *orderCancelDiscount = [OrderCancelDiscount getOrderCancelDiscount:item.orderTakingID];
//        item.cancelDiscountReason = orderCancelDiscount?orderCancelDiscount.reason:@"";
    }
    
    
    //sort
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_status" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"_takeAway" ascending:YES];
    NSSortDescriptor *sortDescriptor3_0 = [[NSSortDescriptor alloc] initWithKey:@"_menuTypeOrderNo" ascending:YES];
    NSSortDescriptor *sortDescriptor3 = [[NSSortDescriptor alloc] initWithKey:@"_subMenuOrderNo" ascending:YES];
    NSSortDescriptor *sortDescriptor4 = [[NSSortDescriptor alloc] initWithKey:@"_menuOrderNo" ascending:YES];
    NSSortDescriptor *sortDescriptor5 = [[NSSortDescriptor alloc] initWithKey:@"_noteIDListInText" ascending:YES];
    NSSortDescriptor *sortDescriptor6 = [[NSSortDescriptor alloc] initWithKey:@"_specialPrice" ascending:NO];
//    NSSortDescriptor *sortDescriptor7 = [[NSSortDescriptor alloc] initWithKey:@"_cancelDiscountReason" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor,sortDescriptor2,sortDescriptor3_0,sortDescriptor3,sortDescriptor4,sortDescriptor5,sortDescriptor6,nil];
    NSArray *sortArray = [orderTakingList sortedArrayUsingDescriptors:sortDescriptors];
    
    
    return [sortArray mutableCopy];
}

+(NSMutableArray *)getOrderTakingListWithReceiptID:(NSInteger)receiptID orderTakingList:(NSMutableArray *)orderTakingList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_receiptID = %ld",receiptID];
    NSArray *filterArray = [orderTakingList filteredArrayUsingPredicate:predicate];
    return [filterArray mutableCopy];
}

+(NSMutableArray *)getOrderTakingListWithReceiptID:(NSInteger)receiptID
{
    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_receiptID = %ld",receiptID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    return [filterArray mutableCopy];
}

+(NSMutableArray *)getOrderTakingListWithReceiptList:(NSMutableArray *)receiptList
{
    NSMutableArray *orderTakingList = [[NSMutableArray alloc]init];
    
    for(Receipt *item in receiptList)
    {
        NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_receiptID = %ld",item.receiptID];
        NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
        [orderTakingList addObjectsFromArray:filterArray];
    }
    
    return orderTakingList;
}

+(NSMutableArray *)getOrderTakingListWithMenuID:(NSInteger)menuID
{
    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_menuID = %ld",menuID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    return [filterArray mutableCopy];
}

+(NSMutableArray *)getOrderTakingListWithMenuID:(NSInteger)menuID orderTakingList:(NSMutableArray *)orderTakingList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_menuID = %ld",menuID];
    NSArray *filterArray = [orderTakingList filteredArrayUsingPredicate:predicate];
    
    NSMutableArray *sortArray = [self sortListByOrderTakingIDDesc:[filterArray mutableCopy]];
    return sortArray;
}



+(void)deleteOrderTakingDuplicateKey:(OrderTaking *)orderTaking
{
    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_orderTakingID = %ld",orderTaking.orderTakingID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    for(int i=0; i<[filterArray count]; i++)
    {
        OrderTaking *deleteOrderTaking = filterArray[i];
        if([orderTaking.modifiedUser isEqualToString:deleteOrderTaking.modifiedUser])
        {
            [dataList removeObject:deleteOrderTaking];
            return;
        }
    }
}

+(NSMutableArray *)getOrderTakingListWithStatus:(NSInteger)status takeAway:(NSInteger)takeAway menuID:(NSInteger)menuID orderTakingList:(NSMutableArray *)orderTakingList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_status = %ld and _takeAway = %ld and _menuID = %ld",status,takeAway,menuID];
    NSArray *filterArray = [orderTakingList filteredArrayUsingPredicate:predicate];
    
    return [filterArray mutableCopy];
}

+(NSMutableArray *)sortListByNoteIDListInText:(NSMutableArray *)orderTakingList
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_noteIDListInText" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [orderTakingList sortedArrayUsingDescriptors:sortDescriptors];
    
    return [sortArray mutableCopy];
}

+(NSMutableArray *)sortListByModifiedDateDesc:(NSMutableArray *)orderTakingList
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_modifiedDate" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [orderTakingList sortedArrayUsingDescriptors:sortDescriptors];
    
    return [sortArray mutableCopy];
}

+(NSMutableArray *)sortListByOrderTakingIDDesc:(NSMutableArray *)orderTakingList
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_orderTakingID" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [orderTakingList sortedArrayUsingDescriptors:sortDescriptors];
    
    return [sortArray mutableCopy];
}

+(NSMutableArray *)separateOrder:(NSMutableArray *)orderTakingList
{
    NSMutableArray *separateOrderTakingList = [[NSMutableArray alloc]init];
    for(OrderTaking *item in orderTakingList)
    {
        for(int i=0; i<item.quantity; i++)
        {
            OrderTaking *orderTaking = [item copy];
            orderTaking.quantity = 1;
            [separateOrderTakingList addObject:orderTaking];
        }
    }
    return separateOrderTakingList;
}

//+(void)removeAllObject
//{
//    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
//    [dataList removeAllObjects];
//}
//
//+(NSMutableArray *)getOrderTakingList
//{
//    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
//    return dataList;
//}

+(NSMutableArray *)getCurrentOrderTakingList
{
    NSMutableArray *dataList = [SharedCurrentOrderTaking sharedCurrentOrderTaking].orderTakingList;
    return dataList;
}

+(void)setCurrentOrderTakingList:(NSMutableArray *)orderTakingList
{
    [SharedCurrentOrderTaking sharedCurrentOrderTaking].orderTakingList = orderTakingList;
}

+(void)removeCurrentOrderTakingList
{
    NSMutableArray *dataList = [SharedCurrentOrderTaking sharedCurrentOrderTaking].orderTakingList;
    [dataList removeAllObjects];
}

+(NSMutableArray *)createSumUpOrderTakingWithTheSameMenuAndNote:(NSMutableArray *)orderTakingList
{
    
    NSArray *sortArray = [OrderTaking sortOrderTakingList:orderTakingList];
    NSMutableArray *newOrderTakingList = [[NSMutableArray alloc]init];
    
    
    NSInteger countQuantity = 0;
    NSInteger previousTakeAway = -1;
    NSInteger previousMenuID = -1;
    NSString *strPreviousNoteIDListInText = @"-";
    
    
    for(OrderTaking *item in sortArray)
    {
        if(item.takeAway != previousTakeAway || item.menuID != previousMenuID || ![item.noteIDListInText isEqualToString:strPreviousNoteIDListInText])
        {
            if([newOrderTakingList count]>0)
            {
                OrderTaking *lastOrderTaking = newOrderTakingList[[newOrderTakingList count]-1];
                lastOrderTaking.quantity = countQuantity;
            }
            OrderTaking *copyOrderTaking = [item copy];
            [newOrderTakingList addObject:copyOrderTaking];
            countQuantity = 1;
        }
        else
        {
            countQuantity++;
        }
        previousTakeAway = item.takeAway;
        previousMenuID = item.menuID;
        strPreviousNoteIDListInText = item.noteIDListInText;
    }
    
    if([newOrderTakingList count]>0)
    {
        OrderTaking *lastOrderTaking = newOrderTakingList[[newOrderTakingList count]-1];
        lastOrderTaking.quantity = countQuantity;
    }
    
    return newOrderTakingList;
    
}

+(float)getSumQuantity:(NSMutableArray *)orderTakingList
{
    float sum = 0;
    for(OrderTaking *item in orderTakingList)
    {
        sum += item.quantity;
    }
    return sum;
}

+(float)getSumSpecialPrice:(NSMutableArray *)orderTakingList
{
    float sum = 0;
    for(OrderTaking *item in orderTakingList)
    {
        sum += item.quantity*item.specialPrice;
    }
    return sum;
}

+(NSMutableArray *)updateStatus:(NSInteger)status orderTakingList:(NSMutableArray *)orderTakingList
{
    for(OrderTaking *item in orderTakingList)
    {
        item.status = status;
        item.modifiedUser = [Utility modifiedUser];
        item.modifiedDate = [Utility currentDateTime];
    }
    return orderTakingList;
}

+(NSMutableArray *)getOrderTakingList
{
    return [SharedOrderTaking sharedOrderTaking].orderTakingList;
}

+(void)removeAllObjects
{
    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
    [dataList removeAllObjects];
}

+(NSMutableArray *)getOrderTakingListWithReceiptID:(NSInteger)receiptID branchID:(NSInteger)branchID
{
    NSMutableArray *dataList = [SharedOrderTaking sharedOrderTaking].orderTakingList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_receiptID = %ld and _branchID = %ld",receiptID,branchID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    return [filterArray mutableCopy];
}
@end
