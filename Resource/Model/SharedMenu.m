//
//  SharedMenu.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 27/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedMenu.h"

@implementation SharedMenu
@synthesize menuList;

+(SharedMenu *)sharedMenu {
    static dispatch_once_t pred;
    static SharedMenu *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedMenu alloc] init];
        shared.menuList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
