//
//  TableNo.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 18/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "TableNo.h"
#import "SharedTableNo.h"
#import "Utility.h"


@implementation TableNo

-(TableNo *)initWithShopID:(NSInteger)shopID name:(NSInteger)name remark:(NSString *)remark type:(NSInteger)type zone:(NSInteger)zone status:(NSInteger)status orderNo:(NSInteger)orderNo
{
    self = [super init];
    if(self)
    {
        self.tableNoID = [TableNo getNextID];
        self.shopID = shopID;
        self.name = name;
        self.remark = remark;
        self.type = type;
        self.zone = zone;
        self.status = status;
        self.orderNo = orderNo;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"tableNoID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedTableNo sharedTableNo].tableNoList;
    
    
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

+(void)addObject:(TableNo *)tableNo
{
    NSMutableArray *dataList = [SharedTableNo sharedTableNo].tableNoList;
    [dataList addObject:tableNo];
}

+(void)removeObject:(TableNo *)tableNo
{
    NSMutableArray *dataList = [SharedTableNo sharedTableNo].tableNoList;
    [dataList removeObject:tableNo];
}

+(void)addList:(NSMutableArray *)tableNoList
{
    NSMutableArray *dataList = [SharedTableNo sharedTableNo].tableNoList;
    [dataList addObjectsFromArray:tableNoList];
}

+(void)removeList:(NSMutableArray *)tableNoList
{
    NSMutableArray *dataList = [SharedTableNo sharedTableNo].tableNoList;
    [dataList removeObjectsInArray:tableNoList];
}

+(TableNo *)getTableNo:(NSInteger)tableNoID
{
    NSMutableArray *dataList = [SharedTableNo sharedTableNo].tableNoList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_tableNoID = %ld",tableNoID];
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
        ((TableNo *)copy).tableNoID = self.tableNoID;
        ((TableNo *)copy).shopID = self.shopID;
        ((TableNo *)copy).name = self.name;
        [copy setRemark:self.remark];
        ((TableNo *)copy).type = self.type;
        ((TableNo *)copy).zone = self.zone;
        ((TableNo *)copy).status = self.status;
        ((TableNo *)copy).orderNo = self.orderNo;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        
        
    }
    
    return copy;
}

-(BOOL)editTableNo:(TableNo *)editingTableNo
{
    if(self.tableNoID == editingTableNo.tableNoID
       && self.shopID == editingTableNo.shopID
       && self.name == editingTableNo.name
       && [self.remark isEqualToString:editingTableNo.remark]
       && self.type == editingTableNo.type
       && self.zone == editingTableNo.zone
       && self.status == editingTableNo.status
       && self.orderNo == editingTableNo.orderNo
       )
    {
        return NO;
    }
    return YES;
}

+(TableNo *)copyFrom:(TableNo *)fromTableNo to:(TableNo *)toTableNo
{
    toTableNo.tableNoID = fromTableNo.tableNoID;
    toTableNo.shopID = fromTableNo.shopID;
    toTableNo.name = fromTableNo.name;
    toTableNo.remark = fromTableNo.remark;
    toTableNo.type = fromTableNo.type;
    toTableNo.zone = fromTableNo.zone;
    toTableNo.status = fromTableNo.status;
    toTableNo.orderNo = fromTableNo.orderNo;
    toTableNo.modifiedUser = [Utility modifiedUser];
    toTableNo.modifiedDate = [Utility currentDateTime];
    
    return toTableNo;
}

@end
