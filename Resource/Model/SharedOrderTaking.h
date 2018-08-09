//
//  SharedOrderTaking.h
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/10/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedOrderTaking : NSObject
@property (retain, nonatomic) NSMutableArray *orderTakingList;

+ (SharedOrderTaking *)sharedOrderTaking;
@end
