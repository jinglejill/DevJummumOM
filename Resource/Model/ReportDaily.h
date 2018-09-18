//
//  ReportDaily.h
//  DevJummumOM
//
//  Created by Thidaporn Kijkamjai on 17/9/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportDaily : NSObject
@property (retain, nonatomic) NSDate * receiptDate;
@property (nonatomic) float balance;
@property (nonatomic) float totalAmount;
@property (nonatomic) float discountValue;
@property (nonatomic) float afterDiscount;
@property (nonatomic) float serviceChargeValue;
@property (nonatomic) float vatValue;
@property (nonatomic) float netTotal;
@property (nonatomic) float transactionFeeValue;
@property (nonatomic) float jummumPayValue;
@property (nonatomic) NSInteger status;//not transfer, transferred
@property (nonatomic) NSInteger receiptID;
@property (retain, nonatomic) NSString *receiptNoID;


@property (nonatomic) NSInteger expand;
@end
