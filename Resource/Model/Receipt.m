//
//  Receipt.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/23/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "Receipt.h"
#import "SharedReceipt.h"
#import "Utility.h"
#import "Setting.h"


@implementation Receipt

-(Receipt *)initWithBranchID:(NSInteger)branchID customerTableID:(NSInteger)customerTableID memberID:(NSInteger)memberID servingPerson:(NSInteger)servingPerson customerType:(NSInteger)customerType openTableDate:(NSDate *)openTableDate cashAmount:(float)cashAmount cashReceive:(float)cashReceive creditCardType:(NSInteger)creditCardType creditCardNo:(NSString *)creditCardNo creditCardAmount:(float)creditCardAmount transferDate:(NSDate *)transferDate transferAmount:(float)transferAmount remark:(NSString *)remark discountType:(NSInteger)discountType discountAmount:(float)discountAmount discountValue:(float)discountValue discountReason:(NSString *)discountReason serviceChargePercent:(float)serviceChargePercent serviceChargeValue:(float)serviceChargeValue priceIncludeVat:(NSInteger)priceIncludeVat vatPercent:(float)vatPercent vatValue:(float)vatValue status:(NSInteger)status statusRoute:(NSString *)statusRoute receiptNoID:(NSString *)receiptNoID receiptNoTaxID:(NSString *)receiptNoTaxID receiptDate:(NSDate *)receiptDate sendToKitchenDate:(NSDate *)sendToKitchenDate deliveredDate:(NSDate *)deliveredDate mergeReceiptID:(NSInteger)mergeReceiptID buffetReceiptID:(NSInteger)buffetReceiptID
{
    self = [super init];
    if(self)
    {
        self.receiptID = [Receipt getNextID];
        self.branchID = branchID;
        self.customerTableID = customerTableID;
        self.memberID = memberID;
        self.servingPerson = servingPerson;
        self.customerType = customerType;
        self.openTableDate = openTableDate;
        self.cashAmount = cashAmount;
        self.cashReceive = cashReceive;
        self.creditCardType = creditCardType;
        self.creditCardNo = creditCardNo;
        self.creditCardAmount = creditCardAmount;
        self.transferDate = transferDate;
        self.transferAmount = transferAmount;
        self.remark = remark;
        self.discountType = discountType;
        self.discountAmount = discountAmount;
        self.discountValue = discountValue;
        self.discountReason = discountReason;
        self.serviceChargePercent = serviceChargePercent;
        self.serviceChargeValue = serviceChargeValue;
        self.priceIncludeVat = priceIncludeVat;
        self.vatPercent = vatPercent;
        self.vatValue = vatValue;
        self.status = status;
        self.statusRoute = statusRoute;
        self.receiptNoID = receiptNoID;
        self.receiptNoTaxID = receiptNoTaxID;
        self.receiptDate = receiptDate;
        self.sendToKitchenDate = sendToKitchenDate;
        self.deliveredDate = deliveredDate;
        self.mergeReceiptID = mergeReceiptID;
        self.buffetReceiptID = buffetReceiptID;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"receiptID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedReceipt sharedReceipt].receiptList;
    
    
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

+(void)addObject:(Receipt *)receipt
{
    NSMutableArray *dataList = [SharedReceipt sharedReceipt].receiptList;
    [dataList addObject:receipt];
}

+(void)removeObject:(Receipt *)receipt
{
    NSMutableArray *dataList = [SharedReceipt sharedReceipt].receiptList;
    [dataList removeObject:receipt];
}

+(void)addList:(NSMutableArray *)receiptList
{
    NSMutableArray *dataList = [SharedReceipt sharedReceipt].receiptList;
    [dataList addObjectsFromArray:receiptList];
}

+(void)removeList:(NSMutableArray *)receiptList
{
    NSMutableArray *dataList = [SharedReceipt sharedReceipt].receiptList;
    [dataList removeObjectsInArray:receiptList];
}

+(Receipt *)getReceipt:(NSInteger)receiptID
{
    NSMutableArray *dataList = [SharedReceipt sharedReceipt].receiptList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_receiptID = %ld",receiptID];
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
        ((Receipt *)copy).receiptID = self.receiptID;
        ((Receipt *)copy).branchID = self.branchID;
        ((Receipt *)copy).customerTableID = self.customerTableID;
        ((Receipt *)copy).memberID = self.memberID;
        ((Receipt *)copy).servingPerson = self.servingPerson;
        ((Receipt *)copy).customerType = self.customerType;
        [copy setOpenTableDate:self.openTableDate];
        ((Receipt *)copy).cashAmount = self.cashAmount;
        ((Receipt *)copy).cashReceive = self.cashReceive;
        ((Receipt *)copy).creditCardType = self.creditCardType;
        [copy setCreditCardNo:self.creditCardNo];
        ((Receipt *)copy).creditCardAmount = self.creditCardAmount;
        [copy setTransferDate:self.transferDate];
        ((Receipt *)copy).transferAmount = self.transferAmount;
        [copy setRemark:self.remark];
        ((Receipt *)copy).discountType = self.discountType;
        ((Receipt *)copy).discountAmount = self.discountAmount;
        ((Receipt *)copy).discountValue = self.discountValue;
        [copy setDiscountReason:self.discountReason];
        ((Receipt *)copy).serviceChargePercent = self.serviceChargePercent;
        ((Receipt *)copy).serviceChargeValue = self.serviceChargeValue;
        ((Receipt *)copy).priceIncludeVat = self.priceIncludeVat;
        ((Receipt *)copy).vatPercent = self.vatPercent;
        ((Receipt *)copy).vatValue = self.vatValue;
        ((Receipt *)copy).status = self.status;
        [copy setStatusRoute:self.statusRoute];
        [copy setReceiptNoID:self.receiptNoID];
        [copy setReceiptNoTaxID:self.receiptNoTaxID];
        [copy setReceiptDate:self.receiptDate];
        [copy setSendToKitchenDate:self.sendToKitchenDate];
        [copy setDeliveredDate:self.deliveredDate];
        ((Receipt *)copy).mergeReceiptID = self.mergeReceiptID;
        ((Receipt *)copy).buffetReceiptID = self.buffetReceiptID;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];

    }
    
    return copy;
}

-(BOOL)editReceipt:(Receipt *)editingReceipt
{
    if(self.receiptID == editingReceipt.receiptID
       && self.branchID == editingReceipt.branchID
       && self.customerTableID == editingReceipt.customerTableID
       && self.memberID == editingReceipt.memberID
       && self.servingPerson == editingReceipt.servingPerson
       && self.customerType == editingReceipt.customerType
       && [self.openTableDate isEqual:editingReceipt.openTableDate]
       && self.cashAmount == editingReceipt.cashAmount
       && self.cashReceive == editingReceipt.cashReceive
       && self.creditCardType == editingReceipt.creditCardType
       && [self.creditCardNo isEqualToString:editingReceipt.creditCardNo]
       && self.creditCardAmount == editingReceipt.creditCardAmount
       && [self.transferDate isEqual:editingReceipt.transferDate]
       && self.transferAmount == editingReceipt.transferAmount
       && [self.remark isEqualToString:editingReceipt.remark]
       && self.discountType == editingReceipt.discountType
       && self.discountAmount == editingReceipt.discountAmount
       && self.discountValue == editingReceipt.discountValue
       && [self.discountReason isEqualToString:editingReceipt.discountReason]
       && self.serviceChargePercent == editingReceipt.serviceChargePercent
       && self.serviceChargeValue == editingReceipt.serviceChargeValue
       && self.priceIncludeVat == editingReceipt.priceIncludeVat
       && self.vatPercent == editingReceipt.vatPercent
       && self.vatValue == editingReceipt.vatValue
       && self.status == editingReceipt.status
       && [self.statusRoute isEqualToString:editingReceipt.statusRoute]
       && [self.receiptNoID isEqualToString:editingReceipt.receiptNoID]
       && [self.receiptNoTaxID isEqualToString:editingReceipt.receiptNoTaxID]
       && [self.receiptDate isEqual:editingReceipt.receiptDate]
       && [self.sendToKitchenDate isEqual:editingReceipt.sendToKitchenDate]
       && [self.deliveredDate isEqual:editingReceipt.deliveredDate]
       && self.mergeReceiptID == editingReceipt.mergeReceiptID
       && self.buffetReceiptID == editingReceipt.buffetReceiptID
       )
    {
        return NO;
    }
    return YES;
}

+(Receipt *)copyFrom:(Receipt *)fromReceipt to:(Receipt *)toReceipt
{
    toReceipt.receiptID = fromReceipt.receiptID;
    toReceipt.branchID = fromReceipt.branchID;
    toReceipt.customerTableID = fromReceipt.customerTableID;
    toReceipt.memberID = fromReceipt.memberID;
    toReceipt.servingPerson = fromReceipt.servingPerson;
    toReceipt.customerType = fromReceipt.customerType;
    toReceipt.openTableDate = fromReceipt.openTableDate;
    toReceipt.cashAmount = fromReceipt.cashAmount;
    toReceipt.cashReceive = fromReceipt.cashReceive;
    toReceipt.creditCardType = fromReceipt.creditCardType;
    toReceipt.creditCardNo = fromReceipt.creditCardNo;
    toReceipt.creditCardAmount = fromReceipt.creditCardAmount;
    toReceipt.transferDate = fromReceipt.transferDate;
    toReceipt.transferAmount = fromReceipt.transferAmount;
    toReceipt.remark = fromReceipt.remark;
    toReceipt.discountType = fromReceipt.discountType;
    toReceipt.discountAmount = fromReceipt.discountAmount;
    toReceipt.discountValue = fromReceipt.discountValue;
    toReceipt.discountReason = fromReceipt.discountReason;
    toReceipt.serviceChargePercent = fromReceipt.serviceChargePercent;
    toReceipt.serviceChargeValue = fromReceipt.serviceChargeValue;
    toReceipt.priceIncludeVat = fromReceipt.priceIncludeVat;
    toReceipt.vatPercent = fromReceipt.vatPercent;
    toReceipt.vatValue = fromReceipt.vatValue;
    toReceipt.status = fromReceipt.status;
    toReceipt.statusRoute = fromReceipt.statusRoute;
    toReceipt.receiptNoID = fromReceipt.receiptNoID;
    toReceipt.receiptNoTaxID = fromReceipt.receiptNoTaxID;
    toReceipt.receiptDate = fromReceipt.receiptDate;
    toReceipt.sendToKitchenDate = fromReceipt.sendToKitchenDate;
    toReceipt.deliveredDate = fromReceipt.deliveredDate;
    toReceipt.mergeReceiptID = fromReceipt.mergeReceiptID;
    toReceipt.buffetReceiptID = fromReceipt.buffetReceiptID;
    toReceipt.modifiedUser = [Utility modifiedUser];
    toReceipt.modifiedDate = [Utility currentDateTime];
    
    return toReceipt;
}



+(NSMutableArray *)getReceiptListWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate statusList:(NSArray *)statusList
{
    NSMutableArray *receiptList = [[NSMutableArray alloc]init];
    NSMutableArray *dataList = [SharedReceipt sharedReceipt].receiptList;
    
    for(NSString *status in statusList)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_receiptDate BETWEEN %@ and _status = %ld", [NSArray arrayWithObjects:startDate, endDate, nil],[status integerValue]];
        NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
        [receiptList addObjectsFromArray:filterArray];
    }
    
    
    return [self sortList:receiptList];
}

+(NSMutableArray *)getReceiptListWithReceiptNoID:(NSString *)receiptNoID
{
    NSMutableArray *dataList = [SharedReceipt sharedReceipt].receiptList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_receiptNoID = %@",receiptNoID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    return [filterArray mutableCopy];
}

+(NSMutableArray *)getRemarkReceiptListWithMemeberID:(NSInteger)memberID
{
    NSMutableArray *dataList = [SharedReceipt sharedReceipt].receiptList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_memberID = %ld and _remark != %@",memberID,@""];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    
    
    return [filterArray mutableCopy];
}

+(NSMutableArray *)getReceiptListWithMemeberID:(NSInteger)memberID
{
    NSMutableArray *dataList = [SharedReceipt sharedReceipt].receiptList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_memberID = %ld",memberID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    
    
    return [filterArray mutableCopy];
}

+(NSMutableArray *)sortList:(NSMutableArray *)receiptList
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_receiptDate" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [receiptList sortedArrayUsingDescriptors:sortDescriptors];
    
    
    return [sortArray mutableCopy];
}

+(float)getAllCashAmountWithReceiptDate:(NSDate *)date
{
    NSDate *startOfTheDay = [Utility setStartOfTheDay:date];
    NSDate *endOfTheDay = [Utility setEndOfTheDay:date];
    NSMutableArray *dataList = [SharedReceipt sharedReceipt].receiptList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_receiptDate >= %@ and _receiptDate <= %@",startOfTheDay,endOfTheDay];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    float sum = 0;
    for(Receipt *item in filterArray)
    {
        sum += item.cashAmount;
    }
    
    return sum;
}

+(float)getAllCreditAmountWithReceiptDate:(NSDate *)date
{
    NSDate *startOfTheDay = [Utility setStartOfTheDay:date];
    NSDate *endOfTheDay = [Utility setEndOfTheDay:date];
    NSMutableArray *dataList = [SharedReceipt sharedReceipt].receiptList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_receiptDate >= %@ and _receiptDate <= %@",startOfTheDay,endOfTheDay];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    float sum = 0;
    for(Receipt *item in filterArray)
    {
        sum += item.creditCardAmount;
    }
    
    return sum;
}

+(float)getAllTransferAmountWithReceiptDate:(NSDate *)date
{
    NSDate *startOfTheDay = [Utility setStartOfTheDay:date];
    NSDate *endOfTheDay = [Utility setEndOfTheDay:date];
    NSMutableArray *dataList = [SharedReceipt sharedReceipt].receiptList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_receiptDate >= %@ and _receiptDate <= %@",startOfTheDay,endOfTheDay];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    float sum = 0;
    for(Receipt *item in filterArray)
    {
        sum += item.transferAmount;
    }
    
    return sum;
}

+(NSDate *)getMaxModifiedDateWithMemberID:(NSInteger)memberID
{
    NSMutableArray *dataList = [SharedReceipt sharedReceipt].receiptList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_memberID = %ld",memberID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_modifiedDate" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [filterArray sortedArrayUsingDescriptors:sortDescriptors];
    
    if([sortArray count] > 0)
    {
        Receipt *receipt = sortArray[0];
        return receipt.modifiedDate;
    }
    
    return nil;
}

+(NSMutableArray *)getReceiptList
{
    return [SharedReceipt sharedReceipt].receiptList;
}

+(void)removeAllObjects
{
    NSMutableArray *dataList = [SharedReceipt sharedReceipt].receiptList;
    [dataList removeAllObjects];
}

+(float)getTotalAmount:(Receipt *)receipt
{
    return receipt.cashAmount+receipt.creditCardAmount+receipt.transferAmount;
}

+(NSString *)getStrStatus:(Receipt *)receipt
{
    NSString *strStatus;
    switch (receipt.status)
    {
        case 2:
        {
            NSString *message = [Setting getValue:@"034m" example:@"ลูกค้าสั่ง"];
            strStatus = message;
        }
            break;
        case 5:
        {
            NSString *message = [Setting getValue:@"035m" example:@"กำลังทำ"];
            strStatus = message;
        }
            break;
        case 6:
        {
            NSString *message = [Setting getValue:@"036m" example:@"เสิร์ฟแล้ว"];
            strStatus = message;
        }
            break;
        case 7:
        {
            NSString *message = [Setting getValue:@"037m" example:@"Pending cancel"];
            strStatus = message;
        }
            break;
        case 8:
        {
            NSString *message = [Setting getValue:@"038m" example:@"Order dispute in process"];
            strStatus = message;
        }
            break;
        case 9:
        {
            NSString *message = [Setting getValue:@"039m" example:@"Order cancelled"];
            strStatus = message;
        }
            break;
        case 10:
        {
            NSString *message = [Setting getValue:@"040m" example:@"Order dispute finished"];
            strStatus = message;
        }
            break;
        case 11:
        {
            NSString *message = [Setting getValue:@"041m" example:@"Negotiate"];
            strStatus = message;
        }
            break;
        case 12:
        {
            NSString *message = [Setting getValue:@"042m" example:@"Review dispute"];
            strStatus = message;
        }
            break;
        case 13:
        {
            NSString *message = [Setting getValue:@"043m" example:@"Review dispute in process"];
            strStatus = message;
        }
        break;
        case 14:
        {
            NSString *message = [Setting getValue:@"044m" example:@"Order dispute finished"];
            strStatus = message;
        }
        break;
        default:
            break;
    }
    
    return strStatus;
}

+(UIColor *)getStatusColor:(Receipt *)receipt
{
    UIColor *color;
    switch (receipt.status)
    {
        case 2:
        {
            color = mOrange;
        }
            break;
        case 5:
        {
            color = mOrange;
        }
            break;
        case 6:
        {
            color = mGreen;
        }
            break;
        case 7:
        {
            color = mOrange;
        }
            break;
        case 8:
        {
            color = mOrange;
        }
            break;
        case 9:
        {
            color = mRed;
        }
            break;
        case 10:
        {
            color = mRed;
        }
            break;
        case 11:
        {
            color = mOrange;
        }
            break;
        case 12:
        {
            color = mOrange;
        }
            break;
        case 13:
        {
            color = mOrange;
        }
        break;
        case 14:
        {
            color = mRed;
        }
        break;
        
        default:
            break;
    }
    
    return color;
}

+(NSInteger)getStateBeforeLast:(Receipt *)receipt
{
    NSArray *statusList = [receipt.statusRoute componentsSeparatedByString:@","];
    if([statusList count]>1)
    {
        return [statusList[[statusList count]-2] integerValue];
    }
    return 0;
}

+(Receipt *)getReceipt:(NSInteger)receiptID branchID:(NSInteger)branchID
{
    NSMutableArray *dataList = [SharedReceipt sharedReceipt].receiptList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_receiptID = %ld and _branchID = %ld",receiptID,branchID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSMutableArray *)getReceiptListWithStatus:(NSInteger)status branchID:(NSInteger)branchID
{
    NSMutableArray *dataList = [SharedReceipt sharedReceipt].receiptList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_status = %ld and _branchID = %ld",status,branchID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    return [filterArray mutableCopy];
}

+(void)updateStatus:(Receipt *)receipt
{
    Receipt *selectedReceipt = [self getReceipt:receipt.receiptID branchID:receipt.branchID];
    selectedReceipt.status = receipt.status;
    selectedReceipt.statusRoute = receipt.statusRoute;
    selectedReceipt.modifiedUser = receipt.modifiedUser;
    selectedReceipt.modifiedDate = receipt.modifiedDate;    
}
//
//+(NSMutableArray *)sortListDesc:(NSMutableArray *)receiptList
//{
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_receiptDate" ascending:NO];
//    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"_receiptID" ascending:NO];
//    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor,sortDescriptor2, nil];
//    NSArray *sortArray = [receiptList sortedArrayUsingDescriptors:sortDescriptors];
//    
//    
//    return [sortArray mutableCopy];
//}

+(NSMutableArray *)sortListAsc:(NSMutableArray *)receiptList
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_receiptDate" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"_receiptID" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor,sortDescriptor2, nil];
    NSArray *sortArray = [receiptList sortedArrayUsingDescriptors:sortDescriptors];
    
    
    return [sortArray mutableCopy];
}

+(NSDate *)getMaxModifiedDateWithBranchID:(NSInteger)branchID
{
    NSMutableArray *dataList = [SharedReceipt sharedReceipt].receiptList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_branchID = %ld",branchID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_modifiedDate" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [filterArray sortedArrayUsingDescriptors:sortDescriptors];
    
    if([sortArray count] > 0)
    {
        Receipt *receipt = sortArray[0];
        return receipt.modifiedDate;
    }
    else
    {
        return [Utility stringToDate:@"2018-01-01 00:00:00" fromFormat:@"yyyy-MM-dd HH:mm:ss"];
    }    
}

+(NSInteger)getPriorStatus:(Receipt *)receipt
{
    NSArray *arrStatus = [receipt.statusRoute componentsSeparatedByString: @","];
    if([arrStatus count] >= 2)
    {
        return [arrStatus[[arrStatus count]-2] integerValue];
    }
    return 0;
}

+(NSInteger)getIndex:(NSMutableArray *)receiptList receipt:(Receipt *)receipt
{
    NSInteger i;
    for(i=0; i<[receiptList count]; i++)
    {
        Receipt *item = receiptList[i];
        if(item.receiptID == receipt.receiptID)
        {
            return i;
        }
    }
    return 0;
}
@end
