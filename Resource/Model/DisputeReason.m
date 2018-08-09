//
//  DisputeReason.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 12/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "DisputeReason.h"
#import "SharedDisputeReason.h"
#import "Utility.h"


@implementation DisputeReason

-(DisputeReason *)initWithText:(NSString *)text type:(NSInteger)type status:(NSInteger)status orderNo:(NSInteger)orderNo
{
    self = [super init];
    if(self)
    {
        self.disputeReasonID = [DisputeReason getNextID];
        self.text = text;
        self.type = type;
        self.status = status;
        self.orderNo = orderNo;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"disputeReasonID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedDisputeReason sharedDisputeReason].disputeReasonList;
    
    
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

+(void)addObject:(DisputeReason *)disputeReason
{
    NSMutableArray *dataList = [SharedDisputeReason sharedDisputeReason].disputeReasonList;
    [dataList addObject:disputeReason];
}

+(void)removeObject:(DisputeReason *)disputeReason
{
    NSMutableArray *dataList = [SharedDisputeReason sharedDisputeReason].disputeReasonList;
    [dataList removeObject:disputeReason];
}

+(void)addList:(NSMutableArray *)disputeReasonList
{
    NSMutableArray *dataList = [SharedDisputeReason sharedDisputeReason].disputeReasonList;
    [dataList addObjectsFromArray:disputeReasonList];
}

+(void)removeList:(NSMutableArray *)disputeReasonList
{
    NSMutableArray *dataList = [SharedDisputeReason sharedDisputeReason].disputeReasonList;
    [dataList removeObjectsInArray:disputeReasonList];
}

+(DisputeReason *)getDisputeReason:(NSInteger)disputeReasonID
{
    NSMutableArray *dataList = [SharedDisputeReason sharedDisputeReason].disputeReasonList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_disputeReasonID = %ld",disputeReasonID];
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
        ((DisputeReason *)copy).disputeReasonID = self.disputeReasonID;
        [copy setText:self.text];
        ((DisputeReason *)copy).type = self.type;
        ((DisputeReason *)copy).status = self.status;
        ((DisputeReason *)copy).orderNo = self.orderNo;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        
        
    }
    
    return copy;
}

-(BOOL)editDisputeReason:(DisputeReason *)editingDisputeReason
{
    if(self.disputeReasonID == editingDisputeReason.disputeReasonID
       && [self.text isEqualToString:editingDisputeReason.text]
       && self.type == editingDisputeReason.type
       && self.status == editingDisputeReason.status
       && self.orderNo == editingDisputeReason.orderNo
       )
    {
        return NO;
    }
    return YES;
}

+(DisputeReason *)copyFrom:(DisputeReason *)fromDisputeReason to:(DisputeReason *)toDisputeReason
{
    toDisputeReason.disputeReasonID = fromDisputeReason.disputeReasonID;
    toDisputeReason.text = fromDisputeReason.text;
    toDisputeReason.type = fromDisputeReason.type;
    toDisputeReason.status = fromDisputeReason.status;
    toDisputeReason.orderNo = fromDisputeReason.orderNo;
    toDisputeReason.modifiedUser = [Utility modifiedUser];
    toDisputeReason.modifiedDate = [Utility currentDateTime];
    
    return toDisputeReason;
}

+(DisputeReason *)getDisputeReasonWithText:(NSString *)text
{
    NSMutableArray *dataList = [SharedDisputeReason sharedDisputeReason].disputeReasonList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_text = %@",text];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    if([filterArray count]>0)
    {
        return filterArray[0];
    }
    return nil;
}

+(void)setSharedData:(NSMutableArray *)dataList
{
    [SharedDisputeReason sharedDisputeReason].disputeReasonList = dataList;
}
@end
