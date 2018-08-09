//
//  SharedCurrentMenu.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 12/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedCurrentMenu.h"

@implementation SharedCurrentMenu
@synthesize menuList;

+(SharedCurrentMenu *)SharedCurrentMenu {
    static dispatch_once_t pred;
    static SharedCurrentMenu *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedCurrentMenu alloc] init];
        shared.menuList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
