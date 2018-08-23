//
//  Receipt.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/23/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Receipt : NSObject
@property (nonatomic) NSInteger receiptID;
@property (nonatomic) NSInteger branchID;
@property (nonatomic) NSInteger customerTableID;
@property (nonatomic) NSInteger memberID;
@property (nonatomic) NSInteger servingPerson;
@property (nonatomic) NSInteger customerType;
@property (retain, nonatomic) NSDate * openTableDate;
@property (nonatomic) float cashAmount;
@property (nonatomic) float cashReceive;
@property (nonatomic) NSInteger creditCardType;
@property (retain, nonatomic) NSString * creditCardNo;
@property (nonatomic) float creditCardAmount;
@property (retain, nonatomic) NSDate * transferDate;
@property (nonatomic) float transferAmount;
@property (retain, nonatomic) NSString * remark;
@property (nonatomic) NSInteger discountType;
@property (nonatomic) float discountAmount;
@property (nonatomic) float discountValue;
@property (retain, nonatomic) NSString * discountReason;
@property (nonatomic) float serviceChargePercent;
@property (nonatomic) float serviceChargeValue;
@property (nonatomic) NSInteger priceIncludeVat;
@property (nonatomic) float vatPercent;
@property (nonatomic) float vatValue;
@property (nonatomic) NSInteger status;
@property (retain, nonatomic) NSString * statusRoute;
@property (retain, nonatomic) NSString * receiptNoID;
@property (retain, nonatomic) NSString * receiptNoTaxID;
@property (retain, nonatomic) NSDate * receiptDate;
@property (retain, nonatomic) NSDate * sendToKitchenDate;
@property (retain, nonatomic) NSDate * deliveredDate;
@property (nonatomic) NSInteger mergeReceiptID;
@property (nonatomic) NSInteger buffetReceiptID;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;


@property (nonatomic) BOOL toBeProcessing;
@property (nonatomic) BOOL toBePrinting;

-(Receipt *)initWithBranchID:(NSInteger)branchID customerTableID:(NSInteger)customerTableID memberID:(NSInteger)memberID servingPerson:(NSInteger)servingPerson customerType:(NSInteger)customerType openTableDate:(NSDate *)openTableDate cashAmount:(float)cashAmount cashReceive:(float)cashReceive creditCardType:(NSInteger)creditCardType creditCardNo:(NSString *)creditCardNo creditCardAmount:(float)creditCardAmount transferDate:(NSDate *)transferDate transferAmount:(float)transferAmount remark:(NSString *)remark discountType:(NSInteger)discountType discountAmount:(float)discountAmount discountValue:(float)discountValue discountReason:(NSString *)discountReason serviceChargePercent:(float)serviceChargePercent serviceChargeValue:(float)serviceChargeValue priceIncludeVat:(NSInteger)priceIncludeVat vatPercent:(float)vatPercent vatValue:(float)vatValue status:(NSInteger)status statusRoute:(NSString *)statusRoute receiptNoID:(NSString *)receiptNoID receiptNoTaxID:(NSString *)receiptNoTaxID receiptDate:(NSDate *)receiptDate sendToKitchenDate:(NSDate *)sendToKitchenDate deliveredDate:(NSDate *)deliveredDate mergeReceiptID:(NSInteger)mergeReceiptID buffetReceiptID:(NSInteger)buffetReceiptID;
+(NSInteger)getNextID;
+(void)addObject:(Receipt *)receipt;
+(void)removeObject:(Receipt *)receipt;
+(void)addList:(NSMutableArray *)receiptList;
+(void)removeList:(NSMutableArray *)receiptList;
+(Receipt *)getReceipt:(NSInteger)receiptID;
+(Receipt *)getReceiptWithCustomerTableID:(NSInteger)customerTableID status:(NSInteger)status;
+(NSString *)getStringCreditCardType:(Receipt *)receipt;
-(id)copyWithZone:(NSZone *)zone;
+(Receipt *)copyFrom:(Receipt *)fromReceipt to:(Receipt *)toReceipt;
+(NSMutableArray *)getReceiptListWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate statusList:(NSArray *)statusList;
+(NSMutableArray *)getReceiptListWithReceiptNoID:(NSString *)receiptNoID;
+(NSMutableArray *)getRemarkReceiptListWithMemeberID:(NSInteger)memberID;
+(NSMutableArray *)getReceiptListWithMemeberID:(NSInteger)memberID;
+(NSMutableArray *)sortList:(NSMutableArray *)receiptList;
+(float)getAllCashAmountWithReceiptDate:(NSDate *)date;
+(float)getAllCreditAmountWithReceiptDate:(NSDate *)date;
+(float)getAllTransferAmountWithReceiptDate:(NSDate *)date;
+(NSDate *)getMaxModifiedDateWithMemberID:(NSInteger)memberID;
+(NSMutableArray *)getReceiptList;
+(void)removeAllObjects;
+(float)getTotalAmount:(Receipt *)receipt;
+(NSString *)getStrStatus:(Receipt *)receipt;
+(UIColor *)getStatusColor:(Receipt *)receipt;
+(NSInteger)getStateBeforeLast:(Receipt *)receipt;


+(Receipt *)getReceipt:(NSInteger)receiptID branchID:(NSInteger)branchID;
+(NSMutableArray *)getReceiptListWithStatus:(NSInteger)status branchID:(NSInteger)branchID;
+(void)updateStatus:(Receipt *)receipt;
+(NSMutableArray *)sortListAsc:(NSMutableArray *)receiptList;
+(NSDate *)getMaxModifiedDateWithBranchID:(NSInteger)branchID;
+(NSInteger)getPriorStatus:(Receipt *)receipt;
+(NSInteger)getIndex:(NSMutableArray *)receiptList receipt:(Receipt *)receipt;
@end
