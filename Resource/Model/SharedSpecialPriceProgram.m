//
//  SharedSpecialPriceProgram.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/10/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SharedSpecialPriceProgram.h"

@implementation SharedSpecialPriceProgram
@synthesize specialPriceProgramList;

+(SharedSpecialPriceProgram *)sharedSpecialPriceProgram {
    static dispatch_once_t pred;
    static SharedSpecialPriceProgram *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedSpecialPriceProgram alloc] init];
        shared.specialPriceProgramList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
