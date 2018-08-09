//
//  SharedPromoCode.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 3/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedPromoCode : NSObject
@property (retain, nonatomic) NSMutableArray *promoCodeList;

+ (SharedPromoCode *)sharedPromoCode;

@end
