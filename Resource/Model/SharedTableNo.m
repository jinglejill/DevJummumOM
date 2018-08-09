    //
//  SharedTableNo.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 18/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedTableNo.h"

@implementation SharedTableNo
@synthesize tableNoList;

+(SharedTableNo *)sharedTableNo {
    static dispatch_once_t pred;
    static SharedTableNo *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedTableNo alloc] init];
        shared.tableNoList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
