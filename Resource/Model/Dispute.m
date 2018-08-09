//
//  Dispute.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 12/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "Dispute.h"
#import "SharedDispute.h"
#import "Utility.h"


@implementation Dispute

-(Dispute *)initWithReceiptID:(NSInteger)receiptID disputeReasonID:(NSInteger)disputeReasonID refundAmount:(float)refundAmount detail:(NSString *)detail phoneNo:(NSString *)phoneNo type:(NSInteger)type
{
    self = [super init];
    if(self)
    {
        self.disputeID = [Dispute getNextID];
        self.receiptID = receiptID;
        self.disputeReasonID = disputeReasonID;
        self.refundAmount = refundAmount;
        self.detail = detail;
        self.phoneNo = phoneNo;
        self.type = type;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"disputeID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedDispute sharedDispute].disputeList;
    
    
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

+(void)addObject:(Dispute *)dispute
{
    NSMutableArray *dataList = [SharedDispute sharedDispute].disputeList;
    [dataList addObject:dispute];
}

+(void)removeObject:(Dispute *)dispute
{
    NSMutableArray *dataList = [SharedDispute sharedDispute].disputeList;
    [dataList removeObject:dispute];
}

+(void)addList:(NSMutableArray *)disputeList
{
    NSMutableArray *dataList = [SharedDispute sharedDispute].disputeList;
    [dataList addObjectsFromArray:disputeList];
}

+(void)removeList:(NSMutableArray *)disputeList
{
    NSMutableArray *dataList = [SharedDispute sharedDispute].disputeList;
    [dataList removeObjectsInArray:disputeList];
}

+(Dispute *)getDispute:(NSInteger)disputeID
{
    NSMutableArray *dataList = [SharedDispute sharedDispute].disputeList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_disputeID = %ld",disputeID];
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
        ((Dispute *)copy).disputeID = self.disputeID;
        ((Dispute *)copy).receiptID = self.receiptID;
        ((Dispute *)copy).disputeReasonID = self.disputeReasonID;
        ((Dispute *)copy).refundAmount = self.refundAmount;
        [copy setDetail:self.detail];
        [copy setPhoneNo:self.phoneNo];
        ((Dispute *)copy).type = self.type;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        
        
    }
    
    return copy;
}

-(BOOL)editDispute:(Dispute *)editingDispute
{
    if(self.disputeID == editingDispute.disputeID
       && self.receiptID == editingDispute.receiptID
       && self.disputeReasonID == editingDispute.disputeReasonID
       && self.refundAmount == editingDispute.refundAmount
       && [self.detail isEqualToString:editingDispute.detail]
       && [self.phoneNo isEqualToString:editingDispute.phoneNo]
       && self.type == editingDispute.type
       )
    {
        return NO;
    }
    return YES;
}

+(Dispute *)copyFrom:(Dispute *)fromDispute to:(Dispute *)toDispute
{
    toDispute.disputeID = fromDispute.disputeID;
    toDispute.receiptID = fromDispute.receiptID;
    toDispute.disputeReasonID = fromDispute.disputeReasonID;
    toDispute.refundAmount = fromDispute.refundAmount;
    toDispute.detail = fromDispute.detail;
    toDispute.phoneNo = fromDispute.phoneNo;
    toDispute.type = fromDispute.type;
    toDispute.modifiedUser = [Utility modifiedUser];
    toDispute.modifiedDate = [Utility currentDateTime];
    
    return toDispute;
}

+(Dispute *)getDisputeWithReceiptID:(NSInteger)receiptID type:(NSInteger)type
{
    NSMutableArray *dataList = [SharedDispute sharedDispute].disputeList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_receiptID = %ld and type = %ld",receiptID,type];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_modifiedDate" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [filterArray sortedArrayUsingDescriptors:sortDescriptors];
    
    
    
    if([sortArray count] > 0)
    {
        return sortArray[0];
    }
    return nil;
}

+(NSMutableArray *)getList
{
    return  [SharedDispute sharedDispute].disputeList;
}

@end
