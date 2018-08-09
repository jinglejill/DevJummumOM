//
//  SharedLogIn.m
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/6/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SharedLogIn.h"

@implementation SharedLogIn
@synthesize logInList;

+(SharedLogIn *)sharedLogIn {
    static dispatch_once_t pred;
    static SharedLogIn *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedLogIn alloc] init];
        shared.logInList = [[NSMutableArray alloc]init];
    });
    return shared;
}

@end
