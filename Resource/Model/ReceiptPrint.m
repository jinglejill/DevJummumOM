//
//  ReceiptPrint.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 23/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "ReceiptPrint.h"
#import "SharedReceiptPrint.h"
#import "Utility.h"


@implementation ReceiptPrint

-(ReceiptPrint *)initWithReceiptID:(NSInteger)receiptID
{
    self = [super init];
    if(self)
    {
        self.receiptPrintID = [ReceiptPrint getNextID];
        self.receiptID = receiptID;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"receiptPrintID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedReceiptPrint sharedReceiptPrint].receiptPrintList;
    
    
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

+(void)addObject:(ReceiptPrint *)receiptPrint
{
    NSMutableArray *dataList = [SharedReceiptPrint sharedReceiptPrint].receiptPrintList;
    [dataList addObject:receiptPrint];
}

+(void)removeObject:(ReceiptPrint *)receiptPrint
{
    NSMutableArray *dataList = [SharedReceiptPrint sharedReceiptPrint].receiptPrintList;
    [dataList removeObject:receiptPrint];
}

+(void)addList:(NSMutableArray *)receiptPrintList
{
    NSMutableArray *dataList = [SharedReceiptPrint sharedReceiptPrint].receiptPrintList;
    [dataList addObjectsFromArray:receiptPrintList];
}

+(void)removeList:(NSMutableArray *)receiptPrintList
{
    NSMutableArray *dataList = [SharedReceiptPrint sharedReceiptPrint].receiptPrintList;
    [dataList removeObjectsInArray:receiptPrintList];
}

+(ReceiptPrint *)getReceiptPrint:(NSInteger)receiptPrintID
{
    NSMutableArray *dataList = [SharedReceiptPrint sharedReceiptPrint].receiptPrintList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_receiptPrintID = %ld",receiptPrintID];
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
        ((ReceiptPrint *)copy).receiptPrintID = self.receiptPrintID;
        ((ReceiptPrint *)copy).receiptID = self.receiptID;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        
        
    }
    
    return copy;
}

-(BOOL)editReceiptPrint:(ReceiptPrint *)editingReceiptPrint
{
    if(self.receiptPrintID == editingReceiptPrint.receiptPrintID
       && self.receiptID == editingReceiptPrint.receiptID
       )
    {
        return NO;
    }
    return YES;
}

+(ReceiptPrint *)copyFrom:(ReceiptPrint *)fromReceiptPrint to:(ReceiptPrint *)toReceiptPrint
{
    toReceiptPrint.receiptPrintID = fromReceiptPrint.receiptPrintID;
    toReceiptPrint.receiptID = fromReceiptPrint.receiptID;
    toReceiptPrint.modifiedUser = [Utility modifiedUser];
    toReceiptPrint.modifiedDate = [Utility currentDateTime];
    
    return toReceiptPrint;
}

+(ReceiptPrint *)getReceiptPrintWithReceiptID:(NSInteger)receiptID
{
    NSMutableArray *dataList = [SharedReceiptPrint sharedReceiptPrint].receiptPrintList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_receiptID = %ld",receiptID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

@end
