//
//  SharedCurrentBranch.m
//  DevJummumOM
//
//  Created by Thidaporn Kijkamjai on 17/9/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "SharedCurrentBranch.h"

@implementation SharedCurrentBranch
@synthesize branch;

+(SharedCurrentBranch *)sharedCurrentBranch {
    static dispatch_once_t pred;
    static SharedCurrentBranch *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedCurrentBranch alloc] init];
        shared.branch = [[Branch alloc]init];
    });
    return shared;
}
@end
