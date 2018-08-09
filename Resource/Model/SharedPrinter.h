//
//  SharedPrinter.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 24/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedPrinter : NSObject
@property (retain, nonatomic) NSMutableArray *printerList;

+ (SharedPrinter *)sharedPrinter;
@end
