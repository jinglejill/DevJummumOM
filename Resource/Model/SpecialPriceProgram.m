//
//  SpecialPriceProgram.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/10/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SpecialPriceProgram.h"
#import "SharedSpecialPriceProgram.h"
#import "Utility.h"
#import "Menu.h"


@implementation SpecialPriceProgram

-(SpecialPriceProgram *)initWithMenuID:(NSInteger)menuID startDate:(NSDate *)startDate endDate:(NSDate *)endDate specialPrice:(float)specialPrice
{
    self = [super init];
    if(self)
    {
        self.specialPriceProgramID = [SpecialPriceProgram getNextID];
        self.menuID = menuID;
        self.startDate = startDate;
        self.endDate = endDate;
        self.specialPrice = specialPrice;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"specialPriceProgramID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedSpecialPriceProgram sharedSpecialPriceProgram].specialPriceProgramList;
    
    
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

+(void)addObject:(SpecialPriceProgram *)specialPriceProgram
{
    NSMutableArray *dataList = [SharedSpecialPriceProgram sharedSpecialPriceProgram].specialPriceProgramList;
    [dataList addObject:specialPriceProgram];
}

+(void)removeObject:(SpecialPriceProgram *)specialPriceProgram
{
    NSMutableArray *dataList = [SharedSpecialPriceProgram sharedSpecialPriceProgram].specialPriceProgramList;
    [dataList removeObject:specialPriceProgram];
}

+(void)addList:(NSMutableArray *)specialPriceProgramList
{
    NSMutableArray *dataList = [SharedSpecialPriceProgram sharedSpecialPriceProgram].specialPriceProgramList;
    [dataList addObjectsFromArray:specialPriceProgramList];
}

+(void)removeList:(NSMutableArray *)specialPriceProgramList
{
    NSMutableArray *dataList = [SharedSpecialPriceProgram sharedSpecialPriceProgram].specialPriceProgramList;
    [dataList removeObjectsInArray:specialPriceProgramList];
}

+(SpecialPriceProgram *)getSpecialPriceProgram:(NSInteger)specialPriceProgramID
{
    NSMutableArray *dataList = [SharedSpecialPriceProgram sharedSpecialPriceProgram].specialPriceProgramList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_specialPriceProgramID = %ld",specialPriceProgramID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(SpecialPriceProgram *)getSpecialPriceProgramTodayWithMenuID:(NSInteger)menuID branchID:(NSInteger)branchID
{
    NSMutableArray *dataList = [SharedSpecialPriceProgram sharedSpecialPriceProgram].specialPriceProgramList;
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];//year christ
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];//local time +7]
    NSDate *today = [calendar startOfDayForDate:[Utility currentDateTime]];
    
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_menuID = %ld and _startDate <= %@ and _endDate >= %@",menuID, today,today];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count]>0)
    {
        NSArray *sortedArray = [SpecialPriceProgram sortList:[filterArray mutableCopy] branchID:branchID];
        return sortedArray[0];
    }
    return nil;
}

+(NSMutableArray *)getSpecialPriceProgramListWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    NSMutableArray *dataList = [SharedSpecialPriceProgram sharedSpecialPriceProgram].specialPriceProgramList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_endDate >= %@",startDate];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    return [self sortList:[filterArray mutableCopy]];
}

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        ((SpecialPriceProgram *)copy).specialPriceProgramID = self.specialPriceProgramID;
        ((SpecialPriceProgram *)copy).menuID = self.menuID;
        [copy setStartDate:self.startDate];
        [copy setEndDate:self.endDate];
        ((SpecialPriceProgram *)copy).specialPrice = self.specialPrice;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        
        
    }
    
    return copy;
}

+ (NSMutableArray *)sortList:(NSMutableArray *)specialPriceProgramList branchID:(NSInteger)branchID
{
    for(SpecialPriceProgram *item in specialPriceProgramList)
    {
        Menu *menu = [Menu getMenu:item.menuID branchID:branchID];
        item.menuOrder = menu.orderNo;
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_startDate" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"_endDate" ascending:YES];
    NSSortDescriptor *sortDescriptor3 = [[NSSortDescriptor alloc] initWithKey:@"_menuOrder" ascending:YES];
    NSSortDescriptor *sortDescriptor4 = [[NSSortDescriptor alloc] initWithKey:@"_specialPrice" ascending:YES];
    NSArray *sortDescriptors1 = [NSArray arrayWithObjects:sortDescriptor,sortDescriptor2,sortDescriptor3,sortDescriptor4, nil];
    NSArray *sortedArray = [specialPriceProgramList sortedArrayUsingDescriptors:sortDescriptors1];
    
    return [sortedArray mutableCopy];
}

+(void)setSharedData:(NSMutableArray *)dataList
{
    [SharedSpecialPriceProgram sharedSpecialPriceProgram].specialPriceProgramList = dataList;
}

@end
