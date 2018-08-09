//
//  SharedSetting.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/28/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SharedSetting.h"

@implementation SharedSetting
@synthesize settingList;

+(SharedSetting *)sharedSetting {
    static dispatch_once_t pred;
    static SharedSetting *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedSetting alloc] init];
        shared.settingList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
