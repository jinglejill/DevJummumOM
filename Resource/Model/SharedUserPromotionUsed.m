//
//  SharedUserPromotionUsed.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 20/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedUserPromotionUsed.h"

@implementation SharedUserPromotionUsed
@synthesize userPromotionUsedList;

+(SharedUserPromotionUsed *)sharedUserPromotionUsed {
    static dispatch_once_t pred;
    static SharedUserPromotionUsed *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedUserPromotionUsed alloc] init];
        shared.userPromotionUsedList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
