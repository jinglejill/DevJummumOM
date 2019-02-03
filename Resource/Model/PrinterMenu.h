//
//  PrinterMenu.h
//  DevJummumOM
//
//  Created by Thidaporn Kijkamjai on 7/12/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Printer.h"


@interface PrinterMenu : NSObject
@property (nonatomic) NSInteger printerMenuID;
@property (nonatomic) NSInteger printerID;
@property (nonatomic) NSInteger menuID;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;

@property (nonatomic) NSInteger branchID;

- (NSDictionary *)dictionary;
-(PrinterMenu *)initWithPrinterID:(NSInteger)printerID menuID:(NSInteger)menuID;
+(NSInteger)getNextID;
+(void)addObject:(PrinterMenu *)printerMenu;
+(void)removeObject:(PrinterMenu *)printerMenu;
+(void)addList:(NSMutableArray *)printerMenuList;
+(void)removeList:(NSMutableArray *)printerMenuList;
+(PrinterMenu *)getPrinterMenu:(NSInteger)printerMenuID;
-(BOOL)editPrinterMenu:(PrinterMenu *)editingPrinterMenu;
+(PrinterMenu *)copyFrom:(PrinterMenu *)fromPrinterMenu to:(PrinterMenu *)toPrinterMenu;

+(BOOL)hasMenuID:(NSInteger)menuID inPrinter:(Printer *)printer;
+(void)removeAllObjects;
@end
