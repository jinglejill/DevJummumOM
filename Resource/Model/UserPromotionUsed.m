//
//  UserPromotionUsed.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 20/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "UserPromotionUsed.h"
#import "SharedUserPromotionUsed.h"
#import "Utility.h"


@implementation UserPromotionUsed

-(UserPromotionUsed *)initWithUserAccountID:(NSInteger)userAccountID promotionID:(NSInteger)promotionID receiptID:(NSInteger)receiptID
{
    self = [super init];
    if(self)
    {
        self.userPromotionUsedID = [UserPromotionUsed getNextID];
        self.userAccountID = userAccountID;
        self.promotionID = promotionID;
        self.receiptID = receiptID;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"userPromotionUsedID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedUserPromotionUsed sharedUserPromotionUsed].userPromotionUsedList;
    
    
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

+(void)addObject:(UserPromotionUsed *)userPromotionUsed
{
    NSMutableArray *dataList = [SharedUserPromotionUsed sharedUserPromotionUsed].userPromotionUsedList;
    [dataList addObject:userPromotionUsed];
}

+(void)removeObject:(UserPromotionUsed *)userPromotionUsed
{
    NSMutableArray *dataList = [SharedUserPromotionUsed sharedUserPromotionUsed].userPromotionUsedList;
    [dataList removeObject:userPromotionUsed];
}

+(void)addList:(NSMutableArray *)userPromotionUsedList
{
    NSMutableArray *dataList = [SharedUserPromotionUsed sharedUserPromotionUsed].userPromotionUsedList;
    [dataList addObjectsFromArray:userPromotionUsedList];
}

+(void)removeList:(NSMutableArray *)userPromotionUsedList
{
    NSMutableArray *dataList = [SharedUserPromotionUsed sharedUserPromotionUsed].userPromotionUsedList;
    [dataList removeObjectsInArray:userPromotionUsedList];
}

+(UserPromotionUsed *)getUserPromotionUsed:(NSInteger)userPromotionUsedID
{
    NSMutableArray *dataList = [SharedUserPromotionUsed sharedUserPromotionUsed].userPromotionUsedList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_userPromotionUsedID = %ld",userPromotionUsedID];
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
        ((UserPromotionUsed *)copy).userPromotionUsedID = self.userPromotionUsedID;
        ((UserPromotionUsed *)copy).userAccountID = self.userAccountID;
        ((UserPromotionUsed *)copy).promotionID = self.promotionID;
        ((UserPromotionUsed *)copy).receiptID = self.receiptID;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        
        
    }
    
    return copy;
}

-(BOOL)editUserPromotionUsed:(UserPromotionUsed *)editingUserPromotionUsed
{
    if(self.userPromotionUsedID == editingUserPromotionUsed.userPromotionUsedID
       && self.userAccountID == editingUserPromotionUsed.userAccountID
       && self.promotionID == editingUserPromotionUsed.promotionID
       && self.receiptID == editingUserPromotionUsed.receiptID
       )
    {
        return NO;
    }
    return YES;
}

+(UserPromotionUsed *)copyFrom:(UserPromotionUsed *)fromUserPromotionUsed to:(UserPromotionUsed *)toUserPromotionUsed
{
    toUserPromotionUsed.userPromotionUsedID = fromUserPromotionUsed.userPromotionUsedID;
    toUserPromotionUsed.userAccountID = fromUserPromotionUsed.userAccountID;
    toUserPromotionUsed.promotionID = fromUserPromotionUsed.promotionID;
    toUserPromotionUsed.receiptID = fromUserPromotionUsed.receiptID;
    toUserPromotionUsed.modifiedUser = [Utility modifiedUser];
    toUserPromotionUsed.modifiedDate = [Utility currentDateTime];
    
    return toUserPromotionUsed;
}

@end
