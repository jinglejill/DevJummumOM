//
//  SharedShop.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 18/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedShop : NSObject
@property (retain, nonatomic) NSMutableArray *shopList;

+ (SharedShop *)sharedShop;

@end
