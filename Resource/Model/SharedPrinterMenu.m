//
//  SharedPrinterMenu.m
//  DevJummumOM
//
//  Created by Thidaporn Kijkamjai on 7/12/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "SharedPrinterMenu.h"

@implementation SharedPrinterMenu
@synthesize printerMenuList;

+(SharedPrinterMenu *)sharedPrinterMenu {
    static dispatch_once_t pred;
    static SharedPrinterMenu *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedPrinterMenu alloc] init];
        shared.printerMenuList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
