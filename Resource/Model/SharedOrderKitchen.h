//
//  SharedOrderKitchen.h
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/15/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedOrderKitchen : NSObject
@property (retain, nonatomic) NSMutableArray *orderKitchenList;

+ (SharedOrderKitchen *)sharedOrderKitchen;
@end
