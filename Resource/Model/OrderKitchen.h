//
//  OrderKitchen.h
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/15/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderKitchen : NSObject
@property (nonatomic) NSInteger orderKitchenID;
@property (nonatomic) NSInteger customerTableID;
@property (nonatomic) NSInteger orderTakingID;
@property (nonatomic) NSInteger sequenceNo;
@property (nonatomic) NSInteger customerTableIDOrder;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;




@property (nonatomic) NSInteger quantity;


-(OrderKitchen *)initWithCustomerTableID:(NSInteger)customerTableID orderTakingID:(NSInteger)orderTakingID sequenceNo:(NSInteger)sequenceNo customerTableIDOrder:(NSInteger)customerTableIDOrder;
+(NSInteger)getNextID;
+(void)addObject:(OrderKitchen *)orderKitchen;
+(void)addList:(NSMutableArray *)orderKitchenList;
+(void)removeObject:(OrderKitchen *)orderKitchen;
+(void)removeList:(NSMutableArray *)orderTakingList;
+(OrderKitchen *)getOrderKitchen:(NSInteger)orderKitchenID;
+(NSInteger)getNextSequenceNoWithCustomerTableID:(NSInteger)customerTableID status:(NSInteger)status;
+(NSMutableArray *)getOrderKitchenListWithCustomerTableID:(NSInteger)customerTableID status:(NSInteger)status;
+(NSMutableArray *)getOrderKitchenListWithSequenceNo:(NSInteger)sequenceNo orderKitchenList:(NSMutableArray *)orderKitchenList;
+(OrderKitchen *)getOrderKitchenWithOrderTakingID:(NSInteger)orderTakingID;
+(NSMutableArray *)getOrderKitchenListWithMenuTypeID:(NSInteger)menuTypeID orderKitchenList:(NSMutableArray *)orderKitchenList;
+(NSMutableArray *)getOrderKitchenListWithOrderTakingList:(NSMutableArray *)orderTakingList;
+(NSMutableArray *)getOrderKitchenListWithNoCustomerTableIDOrder:(NSMutableArray *)orderKitchenList;
+(NSMutableArray *)getOrderKitchenListWithHaveCustomerTableIDOrder:(NSMutableArray *)orderKitchenList;
+(NSMutableArray *)getOrderKitchenListWithCustomerTableOrderID:(NSInteger)customerTableIDOrder orderKitchenList:(NSMutableArray *)orderKitchenList;
@end
