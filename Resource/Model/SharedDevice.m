//
//  SharedDevice.m
//  DevJummumOM
//
//  Created by Thidaporn Kijkamjai on 21/8/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "SharedDevice.h"

@implementation SharedDevice
@synthesize deviceList;

+(SharedDevice *)sharedDevice {
    static dispatch_once_t pred;
    static SharedDevice *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedDevice alloc] init];
        shared.deviceList = [[NSMutableArray alloc]init];
    });
    return shared;
}

@end
