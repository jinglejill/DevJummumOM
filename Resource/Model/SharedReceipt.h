//
//  SharedReceipt.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/23/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedReceipt : NSObject
@property (retain, nonatomic) NSMutableArray *receiptList;

+ (SharedReceipt *)sharedReceipt;
@end
