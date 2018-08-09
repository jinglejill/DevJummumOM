//
//  SharedOrderTaking.m
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/10/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SharedOrderTaking.h"

@implementation SharedOrderTaking
@synthesize orderTakingList;

+(SharedOrderTaking *)sharedOrderTaking {
    static dispatch_once_t pred;
    static SharedOrderTaking *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedOrderTaking alloc] init];
        shared.orderTakingList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
