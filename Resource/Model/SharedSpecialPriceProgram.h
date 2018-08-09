//
//  SharedSpecialPriceProgram.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/10/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedSpecialPriceProgram : NSObject
@property (retain, nonatomic) NSMutableArray *specialPriceProgramList;

+ (SharedSpecialPriceProgram *)sharedSpecialPriceProgram;


@end
