//
//  SharedHotDeal.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 23/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedHotDeal : NSObject
@property (retain, nonatomic) NSMutableArray *hotDealList;

+ (SharedHotDeal *)sharedHotDeal;
@end
