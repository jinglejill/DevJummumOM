//
//  SharedUserAccount.m
//  SaleAndInventoryManagement
//
//  Created by Thidaporn Kijkamjai on 7/30/2558 BE.
//  Copyright (c) 2558 Thidaporn Kijkamjai. All rights reserved.
//

#import "SharedUserAccount.h"

@implementation SharedUserAccount
@synthesize userAccountList;

+(SharedUserAccount *)sharedUserAccount {
    static dispatch_once_t pred;
    static SharedUserAccount *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedUserAccount alloc] init];
        shared.userAccountList = [[NSMutableArray alloc]init];
    });
    return shared;
}


@end
