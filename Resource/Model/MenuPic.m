//
//  MenuPic.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 19/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "MenuPic.h"
#import "SharedMenuPic.h"
#import "Utility.h"


@implementation MenuPic

-(MenuPic *)initWithMenuID:(NSInteger)menuID picID:(NSInteger)picID
{
    self = [super init];
    if(self)
    {
        self.menuPicID = [MenuPic getNextID];
        self.menuID = menuID;
        self.picID = picID;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"menuPicID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedMenuPic sharedMenuPic].menuPicList;
    
    
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

+(void)addObject:(MenuPic *)menuPic
{
    NSMutableArray *dataList = [SharedMenuPic sharedMenuPic].menuPicList;
    [dataList addObject:menuPic];
}

+(void)removeObject:(MenuPic *)menuPic
{
    NSMutableArray *dataList = [SharedMenuPic sharedMenuPic].menuPicList;
    [dataList removeObject:menuPic];
}

+(void)addList:(NSMutableArray *)menuPicList
{
    NSMutableArray *dataList = [SharedMenuPic sharedMenuPic].menuPicList;
    [dataList addObjectsFromArray:menuPicList];
}

+(void)removeList:(NSMutableArray *)menuPicList
{
    NSMutableArray *dataList = [SharedMenuPic sharedMenuPic].menuPicList;
    [dataList removeObjectsInArray:menuPicList];
}

+(MenuPic *)getMenuPic:(NSInteger)menuPicID
{
    NSMutableArray *dataList = [SharedMenuPic sharedMenuPic].menuPicList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_menuPicID = %ld",menuPicID];
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
        ((MenuPic *)copy).menuPicID = self.menuPicID;
        ((MenuPic *)copy).menuID = self.menuID;
        ((MenuPic *)copy).picID = self.picID;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        
        
    }
    
    return copy;
}

-(BOOL)editMenuPic:(MenuPic *)editingMenuPic
{
    if(self.menuPicID == editingMenuPic.menuPicID
       && self.menuID == editingMenuPic.menuID
       && self.picID == editingMenuPic.picID
       )
    {
        return NO;
    }
    return YES;
}

+(MenuPic *)copyFrom:(MenuPic *)fromMenuPic to:(MenuPic *)toMenuPic
{
    toMenuPic.menuPicID = fromMenuPic.menuPicID;
    toMenuPic.menuID = fromMenuPic.menuID;
    toMenuPic.picID = fromMenuPic.picID;
    toMenuPic.modifiedUser = [Utility modifiedUser];
    toMenuPic.modifiedDate = [Utility currentDateTime];
    
    return toMenuPic;
}
@end
