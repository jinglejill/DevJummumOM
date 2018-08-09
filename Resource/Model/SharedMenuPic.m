//
//  SharedMenuPic.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 19/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedMenuPic.h"

@implementation SharedMenuPic
@synthesize menuPicList;

+(SharedMenuPic *)sharedMenuPic {
    static dispatch_once_t pred;
    static SharedMenuPic *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedMenuPic alloc] init];
        shared.menuPicList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
