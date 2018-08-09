//
//  SharedReceipt.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/23/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SharedReceipt.h"

@implementation SharedReceipt
@synthesize receiptList;

+(SharedReceipt *)sharedReceipt {
    static dispatch_once_t pred;
    static SharedReceipt *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedReceipt alloc] init];
        shared.receiptList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
