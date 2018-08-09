//
//  PromotionMenu.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 20/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "PromotionMenu.h"
#import "SharedPromotionMenu.h"
#import "Utility.h"


@implementation PromotionMenu

-(PromotionMenu *)initWithPromotionID:(NSInteger)promotionID menuID:(NSInteger)menuID
{
    self = [super init];
    if(self)
    {
        self.promotionMenuID = [PromotionMenu getNextID];
        self.promotionID = promotionID;
        self.menuID = menuID;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"promotionMenuID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedPromotionMenu sharedPromotionMenu].promotionMenuList;
    
    
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

+(void)addObject:(PromotionMenu *)promotionMenu
{
    NSMutableArray *dataList = [SharedPromotionMenu sharedPromotionMenu].promotionMenuList;
    [dataList addObject:promotionMenu];
}

+(void)removeObject:(PromotionMenu *)promotionMenu
{
    NSMutableArray *dataList = [SharedPromotionMenu sharedPromotionMenu].promotionMenuList;
    [dataList removeObject:promotionMenu];
}

+(void)addList:(NSMutableArray *)promotionMenuList
{
    NSMutableArray *dataList = [SharedPromotionMenu sharedPromotionMenu].promotionMenuList;
    [dataList addObjectsFromArray:promotionMenuList];
}

+(void)removeList:(NSMutableArray *)promotionMenuList
{
    NSMutableArray *dataList = [SharedPromotionMenu sharedPromotionMenu].promotionMenuList;
    [dataList removeObjectsInArray:promotionMenuList];
}

+(PromotionMenu *)getPromotionMenu:(NSInteger)promotionMenuID
{
    NSMutableArray *dataList = [SharedPromotionMenu sharedPromotionMenu].promotionMenuList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_promotionMenuID = %ld",promotionMenuID];
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
        ((PromotionMenu *)copy).promotionMenuID = self.promotionMenuID;
        ((PromotionMenu *)copy).promotionID = self.promotionID;
        ((PromotionMenu *)copy).menuID = self.menuID;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        
        
    }
    
    return copy;
}

-(BOOL)editPromotionMenu:(PromotionMenu *)editingPromotionMenu
{
    if(self.promotionMenuID == editingPromotionMenu.promotionMenuID
       && self.promotionID == editingPromotionMenu.promotionID
       && self.menuID == editingPromotionMenu.menuID
       )
    {
        return NO;
    }
    return YES;
}

+(PromotionMenu *)copyFrom:(PromotionMenu *)fromPromotionMenu to:(PromotionMenu *)toPromotionMenu
{
    toPromotionMenu.promotionMenuID = fromPromotionMenu.promotionMenuID;
    toPromotionMenu.promotionID = fromPromotionMenu.promotionID;
    toPromotionMenu.menuID = fromPromotionMenu.menuID;
    toPromotionMenu.modifiedUser = [Utility modifiedUser];
    toPromotionMenu.modifiedDate = [Utility currentDateTime];
    
    return toPromotionMenu;
}

+(PromotionMenu *)getPromotionMenuWithMenuID:(NSInteger)menuID promotionMenuList:(NSMutableArray *)promotionMenuList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_menuID = %ld",menuID];
    NSArray *filterArray = [promotionMenuList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}
@end
