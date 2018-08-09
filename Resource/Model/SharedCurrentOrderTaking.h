//
//  SharedCurrentOrderTaking.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 12/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedCurrentOrderTaking : NSObject
@property (retain, nonatomic) NSMutableArray *orderTakingList;

+ (SharedCurrentOrderTaking *)sharedCurrentOrderTaking;
@end
