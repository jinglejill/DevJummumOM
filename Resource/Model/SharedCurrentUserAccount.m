//
//  SharedCurrentUserAccount.m
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/6/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SharedCurrentUserAccount.h"

@implementation SharedCurrentUserAccount
@synthesize userAccount;

+(SharedCurrentUserAccount *)sharedCurrentUserAccount {
    static dispatch_once_t pred;
    static SharedCurrentUserAccount *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedCurrentUserAccount alloc] init];
        shared.userAccount = [[UserAccount alloc]init];
    });
    return shared;
}

@end
