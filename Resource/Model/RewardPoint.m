//
//  RewardPoint.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 9/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "RewardPoint.h"
#import "SharedRewardPoint.h"
#import "Utility.h"


@implementation RewardPoint

-(RewardPoint *)initWithMemberID:(NSInteger)memberID receiptID:(NSInteger)receiptID point:(float)point status:(NSInteger)status promoCodeID:(NSInteger)promoCodeID
{
    self = [super init];
    if(self)
    {
        self.rewardPointID = [RewardPoint getNextID];
        self.memberID = memberID;
        self.receiptID = receiptID;
        self.point = point;
        self.status = status;
        self.promoCodeID = promoCodeID;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"rewardPointID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedRewardPoint sharedRewardPoint].rewardPointList;
    
    
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

+(void)addObject:(RewardPoint *)rewardPoint
{
    NSMutableArray *dataList = [SharedRewardPoint sharedRewardPoint].rewardPointList;
    [dataList addObject:rewardPoint];
}

+(void)removeObject:(RewardPoint *)rewardPoint
{
    NSMutableArray *dataList = [SharedRewardPoint sharedRewardPoint].rewardPointList;
    [dataList removeObject:rewardPoint];
}

+(void)addList:(NSMutableArray *)rewardPointList
{
    NSMutableArray *dataList = [SharedRewardPoint sharedRewardPoint].rewardPointList;
    [dataList addObjectsFromArray:rewardPointList];
}

+(void)removeList:(NSMutableArray *)rewardPointList
{
    NSMutableArray *dataList = [SharedRewardPoint sharedRewardPoint].rewardPointList;
    [dataList removeObjectsInArray:rewardPointList];
}

+(RewardPoint *)getRewardPoint:(NSInteger)rewardPointID
{
    NSMutableArray *dataList = [SharedRewardPoint sharedRewardPoint].rewardPointList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_rewardPointID = %ld",rewardPointID];
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
        ((RewardPoint *)copy).rewardPointID = self.rewardPointID;
        ((RewardPoint *)copy).memberID = self.memberID;
        ((RewardPoint *)copy).receiptID = self.receiptID;
        ((RewardPoint *)copy).point = self.point;
        ((RewardPoint *)copy).status = self.status;
        ((RewardPoint *)copy).promoCodeID = self.promoCodeID;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        
        
    }
    
    return copy;
}

-(BOOL)editRewardPoint:(RewardPoint *)editingRewardPoint
{
    if(self.rewardPointID == editingRewardPoint.rewardPointID
       && self.memberID == editingRewardPoint.memberID
       && self.receiptID == editingRewardPoint.receiptID
       && self.point == editingRewardPoint.point
       && self.status == editingRewardPoint.status
       && self.promoCodeID == editingRewardPoint.promoCodeID
       )
    {
        return NO;
    }
    return YES;
}

+(RewardPoint *)copyFrom:(RewardPoint *)fromRewardPoint to:(RewardPoint *)toRewardPoint
{
    toRewardPoint.rewardPointID = fromRewardPoint.rewardPointID;
    toRewardPoint.memberID = fromRewardPoint.memberID;
    toRewardPoint.receiptID = fromRewardPoint.receiptID;
    toRewardPoint.point = fromRewardPoint.point;
    toRewardPoint.status = fromRewardPoint.status;
    toRewardPoint.promoCodeID = fromRewardPoint.promoCodeID;
    toRewardPoint.modifiedUser = [Utility modifiedUser];
    toRewardPoint.modifiedDate = [Utility currentDateTime];
    
    return toRewardPoint;
}

+(NSMutableArray *)sort:(NSMutableArray *)rewardPointList
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_rewardRedemptionSortDate" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [rewardPointList sortedArrayUsingDescriptors:sortDescriptors];
    
    return [sortArray mutableCopy];
}
@end
