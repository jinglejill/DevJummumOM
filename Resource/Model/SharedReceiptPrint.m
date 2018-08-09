//
//  SharedReceiptPrint.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 23/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedReceiptPrint.h"

@implementation SharedReceiptPrint
@synthesize receiptPrintList;

+(SharedReceiptPrint *)sharedReceiptPrint {
    static dispatch_once_t pred;
    static SharedReceiptPrint *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedReceiptPrint alloc] init];
        shared.receiptPrintList = [[NSMutableArray alloc]init];
    });
    return shared;
}

@end
