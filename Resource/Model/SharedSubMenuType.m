//
//  SharedSubMenuType.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/19/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SharedSubMenuType.h"

@implementation SharedSubMenuType
@synthesize subMenuTypeList;

+(SharedSubMenuType *)sharedSubMenuType {
    static dispatch_once_t pred;
    static SharedSubMenuType *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedSubMenuType alloc] init];
        shared.subMenuTypeList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
