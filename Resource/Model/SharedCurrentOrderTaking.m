//
//  SharedCurrentOrderTaking.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 12/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedCurrentOrderTaking.h"

@implementation SharedCurrentOrderTaking
@synthesize orderTakingList;

+(SharedCurrentOrderTaking *)sharedCurrentOrderTaking {
    static dispatch_once_t pred;
    static SharedCurrentOrderTaking *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedCurrentOrderTaking alloc] init];
        shared.orderTakingList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
