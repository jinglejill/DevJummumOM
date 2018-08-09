//
//  SharedCurrentCredentialsDb.m
//  JummumShop
//
//  Created by Thidaporn Kijkamjai on 21/7/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedCurrentCredentialsDb.h"

@implementation SharedCurrentCredentialsDb
@synthesize credentialsDb;

+(SharedCurrentCredentialsDb *)sharedCurrentCredentialsDb
{
    static dispatch_once_t pred;
    static SharedCurrentCredentialsDb *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedCurrentCredentialsDb alloc] init];
        shared.credentialsDb = [[CredentialsDb alloc]init];
    });
    return shared;
}
@end
