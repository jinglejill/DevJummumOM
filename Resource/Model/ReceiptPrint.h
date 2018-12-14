//
//  ReceiptPrint.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 23/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceiptPrint : NSObject
@property (nonatomic) NSInteger receiptPrintID;
@property (nonatomic) NSInteger receiptID;
@property (nonatomic) NSInteger printerID;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;

- (NSDictionary *)dictionary;
-(ReceiptPrint *)initWithReceiptID:(NSInteger)receiptID printerID:(NSInteger)printerID;
+(NSInteger)getNextID;
+(void)addObject:(ReceiptPrint *)receiptPrint;
+(void)removeObject:(ReceiptPrint *)receiptPrint;
+(void)addList:(NSMutableArray *)receiptPrintList;
+(void)removeList:(NSMutableArray *)receiptPrintList;
+(ReceiptPrint *)getReceiptPrint:(NSInteger)receiptPrintID;
-(BOOL)editReceiptPrint:(ReceiptPrint *)editingReceiptPrint;
+(ReceiptPrint *)copyFrom:(ReceiptPrint *)fromReceiptPrint to:(ReceiptPrint *)toReceiptPrint;

@end
