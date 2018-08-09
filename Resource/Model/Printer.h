//
//  Printer.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 24/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Printer : NSObject
@property (nonatomic) NSInteger printerID;
@property (retain, nonatomic) NSString * code;
@property (retain, nonatomic) NSString * name;
@property (retain, nonatomic) NSString * menuTypeIDListInText;
@property (retain, nonatomic) NSString * model;
@property (retain, nonatomic) NSString * portName;
@property (retain, nonatomic) NSString * macAddress;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;



@property (nonatomic) NSInteger printerStatus;

-(Printer *)initWithCode:(NSString *)code name:(NSString *)name menuTypeIDListInText:(NSString *)menuTypeIDListInText model:(NSString *)model portName:(NSString *)portName macAddress:(NSString *)macAddress;
+(NSInteger)getNextID;
+(void)addObject:(Printer *)printer;
+(void)removeObject:(Printer *)printer;
+(void)addList:(NSMutableArray *)printerList;
+(void)removeList:(NSMutableArray *)printerList;
+(Printer *)getPrinter:(NSInteger)printerID;
+(Printer *)getPrinterWithCode:(NSString *)code;
+(NSMutableArray *)getPrinterList;
+(Printer *)getPrinterWithName:(NSString *)name;
+(NSString *)getMenuTypeListInTextWithPrinter:(Printer *)printer;
+(NSMutableArray *)getMenuTypeListOtherThanPrinter:(Printer *)printer;
+(NSMutableArray *)getMenuTypeListWithPrinter:(Printer *)printer;
@end
