//
//  UserRewardRedemptionUsed.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 6/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "UserRewardRedemptionUsed.h"
#import "SharedUserRewardRedemptionUsed.h"
#import "Utility.h"


@implementation UserRewardRedemptionUsed

-(UserRewardRedemptionUsed *)initWithUserAccountID:(NSInteger)userAccountID rewardRedemptionID:(NSInteger)rewardRedemptionID receiptID:(NSInteger)receiptID
{
    self = [super init];
    if(self)
    {
        self.userRewardRedemptionUsedID = [UserRewardRedemptionUsed getNextID];
        self.userAccountID = userAccountID;
        self.rewardRedemptionID = rewardRedemptionID;
        self.receiptID = receiptID;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"userRewardRedemptionUsedID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedUserRewardRedemptionUsed sharedUserRewardRedemptionUsed].userRewardRedemptionUsedList;
    
    
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

+(void)addObject:(UserRewardRedemptionUsed *)userRewardRedemptionUsed
{
    NSMutableArray *dataList = [SharedUserRewardRedemptionUsed sharedUserRewardRedemptionUsed].userRewardRedemptionUsedList;
    [dataList addObject:userRewardRedemptionUsed];
}

+(void)removeObject:(UserRewardRedemptionUsed *)userRewardRedemptionUsed
{
    NSMutableArray *dataList = [SharedUserRewardRedemptionUsed sharedUserRewardRedemptionUsed].userRewardRedemptionUsedList;
    [dataList removeObject:userRewardRedemptionUsed];
}

+(void)addList:(NSMutableArray *)userRewardRedemptionUsedList
{
    NSMutableArray *dataList = [SharedUserRewardRedemptionUsed sharedUserRewardRedemptionUsed].userRewardRedemptionUsedList;
    [dataList addObjectsFromArray:userRewardRedemptionUsedList];
}

+(void)removeList:(NSMutableArray *)userRewardRedemptionUsedList
{
    NSMutableArray *dataList = [SharedUserRewardRedemptionUsed sharedUserRewardRedemptionUsed].userRewardRedemptionUsedList;
    [dataList removeObjectsInArray:userRewardRedemptionUsedList];
}

+(UserRewardRedemptionUsed *)getUserRewardRedemptionUsed:(NSInteger)userRewardRedemptionUsedID
{
    NSMutableArray *dataList = [SharedUserRewardRedemptionUsed sharedUserRewardRedemptionUsed].userRewardRedemptionUsedList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_userRewardRedemptionUsedID = %ld",userRewardRedemptionUsedID];
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
        ((UserRewardRedemptionUsed *)copy).userRewardRedemptionUsedID = self.userRewardRedemptionUsedID;
        ((UserRewardRedemptionUsed *)copy).userAccountID = self.userAccountID;
        ((UserRewardRedemptionUsed *)copy).rewardRedemptionID = self.rewardRedemptionID;
        ((UserRewardRedemptionUsed *)copy).receiptID = self.receiptID;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        
        
    }
    
    return copy;
}

-(BOOL)editUserRewardRedemptionUsed:(UserRewardRedemptionUsed *)editingUserRewardRedemptionUsed
{
    if(self.userRewardRedemptionUsedID == editingUserRewardRedemptionUsed.userRewardRedemptionUsedID
       && self.userAccountID == editingUserRewardRedemptionUsed.userAccountID
       && self.rewardRedemptionID == editingUserRewardRedemptionUsed.rewardRedemptionID
       && self.receiptID == editingUserRewardRedemptionUsed.receiptID
       )
    {
        return NO;
    }
    return YES;
}

+(UserRewardRedemptionUsed *)copyFrom:(UserRewardRedemptionUsed *)fromUserRewardRedemptionUsed to:(UserRewardRedemptionUsed *)toUserRewardRedemptionUsed
{
    toUserRewardRedemptionUsed.userRewardRedemptionUsedID = fromUserRewardRedemptionUsed.userRewardRedemptionUsedID;
    toUserRewardRedemptionUsed.userAccountID = fromUserRewardRedemptionUsed.userAccountID;
    toUserRewardRedemptionUsed.rewardRedemptionID = fromUserRewardRedemptionUsed.rewardRedemptionID;
    toUserRewardRedemptionUsed.receiptID = fromUserRewardRedemptionUsed.receiptID;
    toUserRewardRedemptionUsed.modifiedUser = [Utility modifiedUser];
    toUserRewardRedemptionUsed.modifiedDate = [Utility currentDateTime];
    
    return toUserRewardRedemptionUsed;
}

@end
