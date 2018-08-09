//
//  SharedOrderKitchen.m
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/15/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SharedOrderKitchen.h"

@implementation SharedOrderKitchen
@synthesize orderKitchenList;

+(SharedOrderKitchen *)sharedOrderKitchen {
    static dispatch_once_t pred;
    static SharedOrderKitchen *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedOrderKitchen alloc] init];
        shared.orderKitchenList = [[NSMutableArray alloc]init];
    });
    return shared;
}

@end
