//
//  SharedPromotion.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 20/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedPromotion.h"

@implementation SharedPromotion
@synthesize promotionList;

+(SharedPromotion *)sharedPromotion {
    static dispatch_once_t pred;
    static SharedPromotion *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedPromotion alloc] init];
        shared.promotionList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
