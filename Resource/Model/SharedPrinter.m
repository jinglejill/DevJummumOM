//
//  SharedPrinter.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 24/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedPrinter.h"

@implementation SharedPrinter
@synthesize printerList;

+(SharedPrinter *)sharedPrinter {
    static dispatch_once_t pred;
    static SharedPrinter *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedPrinter alloc] init];
        shared.printerList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
