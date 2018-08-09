//
//  Shop.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 18/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "Shop.h"
#import "SharedShop.h"
#import "Utility.h"


@implementation Shop

-(Shop *)initWithName:(NSString *)name remark:(NSString *)remark percentVat:(float)percentVat status:(NSInteger)status
{
    self = [super init];
    if(self)
    {
        self.shopID = [Shop getNextID];
        self.name = name;
        self.remark = remark;
        self.percentVat = percentVat;
        self.status = status;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"shopID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedShop sharedShop].shopList;
    
    
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

+(void)addObject:(Shop *)shop
{
    NSMutableArray *dataList = [SharedShop sharedShop].shopList;
    [dataList addObject:shop];
}

+(void)removeObject:(Shop *)shop
{
    NSMutableArray *dataList = [SharedShop sharedShop].shopList;
    [dataList removeObject:shop];
}

+(void)addList:(NSMutableArray *)shopList
{
    NSMutableArray *dataList = [SharedShop sharedShop].shopList;
    [dataList addObjectsFromArray:shopList];
}

+(void)removeList:(NSMutableArray *)shopList
{
    NSMutableArray *dataList = [SharedShop sharedShop].shopList;
    [dataList removeObjectsInArray:shopList];
}

+(Shop *)getShop:(NSInteger)shopID
{
    NSMutableArray *dataList = [SharedShop sharedShop].shopList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_shopID = %ld",shopID];
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
        ((Shop *)copy).shopID = self.shopID;
        [copy setName:self.name];
        [copy setRemark:self.remark];
        ((Shop *)copy).percentVat = self.percentVat;
        ((Shop *)copy).status = self.status;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        
        
    }
    
    return copy;
}

-(BOOL)editShop:(Shop *)editingShop
{
    if(self.shopID == editingShop.shopID
       && [self.name isEqualToString:editingShop.name]
       && [self.remark isEqualToString:editingShop.remark]
       && self.percentVat == editingShop.percentVat
       && self.status == editingShop.status
       )
    {
        return NO;
    }
    return YES;
}

+(Shop *)copyFrom:(Shop *)fromShop to:(Shop *)toShop
{
    toShop.shopID = fromShop.shopID;
    toShop.name = fromShop.name;
    toShop.remark = fromShop.remark;
    toShop.percentVat = fromShop.percentVat;
    toShop.status = fromShop.status;
    toShop.modifiedUser = [Utility modifiedUser];
    toShop.modifiedDate = [Utility currentDateTime];
    
    return toShop;
}





@end
