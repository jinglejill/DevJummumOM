//
//  SharedBranch.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedBranch.h"

@implementation SharedBranch
@synthesize branchList;

+(SharedBranch *)sharedBranch {
    static dispatch_once_t pred;
    static SharedBranch *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedBranch alloc] init];
        shared.branchList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
