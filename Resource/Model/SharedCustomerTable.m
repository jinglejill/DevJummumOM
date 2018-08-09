//
//  SharedCustomerTable.m
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/9/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SharedCustomerTable.h"

@implementation SharedCustomerTable
@synthesize customerTableList;

+(SharedCustomerTable *)sharedCustomerTable {
    static dispatch_once_t pred;
    static SharedCustomerTable *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedCustomerTable alloc] init];
        shared.customerTableList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
