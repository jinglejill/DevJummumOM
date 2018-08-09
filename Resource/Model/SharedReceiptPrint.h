//
//  SharedReceiptPrint.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 23/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedReceiptPrint : NSObject
@property (retain, nonatomic) NSMutableArray *receiptPrintList;

+ (SharedReceiptPrint *)sharedReceiptPrint;
@end
