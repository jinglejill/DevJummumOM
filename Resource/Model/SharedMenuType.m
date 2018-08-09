//
//  SharedMenuType.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 20/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedMenuType.h"

@implementation SharedMenuType
@synthesize menuTypeList;

+(SharedMenuType *)sharedMenuType {
    static dispatch_once_t pred;
    static SharedMenuType *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedMenuType alloc] init];
        shared.menuTypeList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
