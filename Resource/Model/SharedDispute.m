//
//  SharedDispute.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 12/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedDispute.h"

@implementation SharedDispute
@synthesize disputeList;

+(SharedDispute *)sharedDispute {
    static dispatch_once_t pred;
    static SharedDispute *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedDispute alloc] init];
        shared.disputeList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
