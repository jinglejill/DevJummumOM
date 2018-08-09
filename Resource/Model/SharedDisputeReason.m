//
//  SharedDisputeReason.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 12/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedDisputeReason.h"

@implementation SharedDisputeReason
@synthesize disputeReasonList;

+(SharedDisputeReason *)sharedDisputeReason {
    static dispatch_once_t pred;
    static SharedDisputeReason *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedDisputeReason alloc] init];
        shared.disputeReasonList = [[NSMutableArray alloc]init];
    });
    return shared;
}

@end
