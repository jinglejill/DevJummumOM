//
//  SharedPromotionMenu.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 20/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedPromotionMenu.h"

@implementation SharedPromotionMenu
@synthesize promotionMenuList;

+(SharedPromotionMenu *)sharedPromotionMenu {
    static dispatch_once_t pred;
    static SharedPromotionMenu *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedPromotionMenu alloc] init];
        shared.promotionMenuList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
