//
//  SubMenuType.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/19/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SubMenuType.h"
#import "SharedSubMenuType.h"
#import "Utility.h"


@implementation SubMenuType

-(SubMenuType *)initWithMenuTypeID:(NSInteger)menuTypeID name:(NSString *)name orderNo:(NSInteger)orderNo status:(NSInteger)status
{
    self = [super init];
    if(self)
    {
        self.subMenuTypeID = [SubMenuType getNextID];
        self.menuTypeID = menuTypeID;
        self.name = name;
        self.orderNo = orderNo;
        self.status = status;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"subMenuTypeID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedSubMenuType sharedSubMenuType].subMenuTypeList;
    
    
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

+(void)addObject:(SubMenuType *)subMenuType
{
    NSMutableArray *dataList = [SharedSubMenuType sharedSubMenuType].subMenuTypeList;
    [dataList addObject:subMenuType];
}

+(void)removeObject:(SubMenuType *)subMenuType
{
    NSMutableArray *dataList = [SharedSubMenuType sharedSubMenuType].subMenuTypeList;
    [dataList removeObject:subMenuType];
}

+(SubMenuType *)getSubMenuType:(NSInteger)subMenuTypeID
{
    NSMutableArray *dataList = [SharedSubMenuType sharedSubMenuType].subMenuTypeList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_subMenuTypeID = %ld",subMenuTypeID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSMutableArray *)getSubMenuTypeListWithMenuTypeID:(NSInteger)menuTypeID
{
    NSMutableArray *dataList = [SharedSubMenuType sharedSubMenuType].subMenuTypeList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_menuTypeID = %ld",menuTypeID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_status" ascending:NO];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor,sortDescriptor2, nil];
    NSArray *sortArray = [filterArray sortedArrayUsingDescriptors:sortDescriptors];
    return [sortArray mutableCopy];
}

+(NSMutableArray *)getSubMenuTypeListWithMenuTypeID:(NSInteger)menuTypeID status:(NSInteger)status
{
    NSMutableArray *dataList = [SharedSubMenuType sharedSubMenuType].subMenuTypeList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_menuTypeID = %ld and _status = %ld",menuTypeID,status];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [filterArray sortedArrayUsingDescriptors:sortDescriptors];
    return [sortArray mutableCopy];
}

+(NSInteger)getNextOrderNoWithStatus:(NSInteger)status
{
    NSMutableArray *dataList = [SharedSubMenuType sharedSubMenuType].subMenuTypeList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_status = %ld",status];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [filterArray sortedArrayUsingDescriptors:sortDescriptors];
    
    if([sortArray count] == 0)
    {
        return 1;
    }
    else
    {
        SubMenuType *subMenuType = sortArray[0];
        return subMenuType.orderNo+1;
    }
}


- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        ((SubMenuType *)copy).subMenuTypeID = self.subMenuTypeID;
        ((SubMenuType *)copy).menuTypeID = self.menuTypeID;
        [copy setName:[self.name copyWithZone:zone]];
        ((SubMenuType *)copy).orderNo = self.orderNo;
        ((SubMenuType *)copy).status = self.status;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        
        
    }
    
    return copy;
}

-(BOOL)editSubMenuType:(SubMenuType *)editingSubMenuType
{
    if([self.name isEqualToString:editingSubMenuType.name] &&
       self.status == editingSubMenuType.status
       )
    {
        return NO;
    }
    return YES;
}

+(void)setSharedData:(NSMutableArray *)dataList
{
    [SharedSubMenuType sharedSubMenuType].subMenuTypeList = dataList;
}

+(NSMutableArray *)getSubMenuTypeList
{
    NSMutableArray *dataList = [SharedSubMenuType sharedSubMenuType].subMenuTypeList;
    return dataList;
}
@end
