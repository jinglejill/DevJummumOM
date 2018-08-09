//
//  SharedPushSync.m
//  SAIM_UPDATING
//
//  Created by Thidaporn Kijkamjai on 5/19/2559 BE.
//  Copyright © 2559 Thidaporn Kijkamjai. All rights reserved.
//

#import "SharedPushSync.h"

@implementation SharedPushSync
@synthesize pushSyncList;

+(SharedPushSync *)sharedPushSync {
    static dispatch_once_t pred;
    static SharedPushSync *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedPushSync alloc] init];
        shared.pushSyncList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
