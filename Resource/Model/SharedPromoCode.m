//
//  SharedPromoCode.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 3/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedPromoCode.h"

@implementation SharedPromoCode

@synthesize promoCodeList;

+(SharedPromoCode *)sharedPromoCode {
    static dispatch_once_t pred;
    static SharedPromoCode *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedPromoCode alloc] init];
        shared.promoCodeList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
