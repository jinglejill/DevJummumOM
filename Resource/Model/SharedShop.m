//
//  SharedShop.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 18/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedShop.h"

@implementation SharedShop
@synthesize shopList;

+(SharedShop *)sharedShop {
    static dispatch_once_t pred;
    static SharedShop *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedShop alloc] init];
        shared.shopList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
