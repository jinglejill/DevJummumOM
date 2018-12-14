//
//  SharedPrinterMenu.h
//  DevJummumOM
//
//  Created by Thidaporn Kijkamjai on 7/12/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedPrinterMenu : NSObject
@property (retain, nonatomic) NSMutableArray *printerMenuList;

+ (SharedPrinterMenu *)sharedPrinterMenu;
@end
