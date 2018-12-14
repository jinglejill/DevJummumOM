//
//  OrderTaking.h
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/10/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderTaking : NSObject
@property (nonatomic) NSInteger orderTakingID;
@property (nonatomic) NSInteger branchID;
@property (nonatomic) NSInteger customerTableID;
@property (nonatomic) NSInteger menuID;
@property (nonatomic) float quantity;
@property (nonatomic) float specialPrice;
@property (nonatomic) float price;
@property (nonatomic) NSInteger takeAway;
@property (nonatomic) float takeAwayPrice;
@property (retain, nonatomic) NSString * noteIDListInText;
@property (nonatomic) float notePrice;
@property (nonatomic) float discountProgramValue;
@property (nonatomic) float discountValue;
@property (nonatomic) NSInteger orderNo;
@property (nonatomic) NSInteger status;
@property (nonatomic) NSInteger receiptID;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;


@property (nonatomic) NSInteger menuOrderNo;
@property (nonatomic) NSInteger subMenuOrderNo;
@property (nonatomic) NSInteger menuTypeOrderNo;

- (NSDictionary *)dictionary;
-(OrderTaking *)initWithBranchID:(NSInteger)branchID customerTableID:(NSInteger)customerTableID menuID:(NSInteger)menuID quantity:(float)quantity specialPrice:(float)specialPrice price:(float)price takeAway:(NSInteger)takeAway takeAwayPrice:(float)takeAwayPrice noteIDListInText:(NSString *)noteIDListInText notePrice:(float)notePrice discountProgramValue:(float)discountProgramValue discountValue:(float)discountValue orderNo:(NSInteger)orderNo status:(NSInteger)status receiptID:(NSInteger)receiptID;
+(NSInteger)getNextID;
+(void)addObject:(OrderTaking *)orderTaking;
+(void)removeObject:(OrderTaking *)orderTaking;
+(void)addList:(NSMutableArray *)orderTakingList;
+(void)removeList:(NSMutableArray *)orderTakingList;
+(OrderTaking *)getOrderTaking:(NSInteger)orderTakingID;

+(OrderTaking *)getOrderTakingWithCustomerTableID:(NSInteger)customerTableID menuID:(NSInteger)menuID takeAway:(NSInteger)takeAway noteIDListInText:(NSString *)noteIDListInText status:(NSInteger)status;
+(NSMutableArray *)getOrderTakingListWithStatus:(NSInteger)status orderTakingList:(NSMutableArray *)orderTakingList;
+(NSMutableArray *)getOrderTakingListWithCustomerTableID:(NSInteger)customerTableID status:(NSInteger)status;
+(NSMutableArray *)getOrderTakingListWithCustomerTableID:(NSInteger)customerTableID statusList:(NSArray *)statusList;
+(NSInteger)getTotalQuantity:(NSMutableArray *)orderTakingList;
+(NSInteger)getSubTotalAmount:(NSMutableArray *)orderTakingList;
+(NSInteger)getSubTotalAmountAllowDiscount:(NSMutableArray *)orderTakingList;
+(NSMutableArray *)sortOrderTakingList:(NSMutableArray *)orderTakingList;
//+(NSMutableArray *)sortOrderTakingListAndReason:(NSMutableArray *)orderTakingList;
+(NSMutableArray *)createSumUpOrderTakingFromSeveralSendToKitchen:(NSMutableArray *)orderTakingList;
+(NSMutableArray *)createSumUpOrderTakingGroupByNoteAndPriceFromSeveralSendToKitchen:(NSMutableArray *)orderTakingList;
//+(NSMutableArray *)createSumUpOrderTakingGroupByNoteFromSeveralSendToKitchen:(NSMutableArray *)orderTakingList;
+(NSMutableArray *)getOrderTakingListWithReceiptID:(NSInteger)receiptID orderTakingList:(NSMutableArray *)orderTakingList;
+(NSMutableArray *)getOrderTakingListWithReceiptID:(NSInteger)receiptID;
+(NSMutableArray *)getOrderTakingListWithReceiptList:(NSMutableArray *)receiptList;
+(NSMutableArray *)getOrderTakingListWithMenuID:(NSInteger)menuID;
+(NSMutableArray *)getOrderTakingListWithMenuID:(NSInteger)menuID orderTakingList:(NSMutableArray *)orderTakingList;
+(void)deleteOrderTakingDuplicateKey:(OrderTaking *)orderTaking;
+(NSMutableArray *)getOrderTakingListWithStatus:(NSInteger)status takeAway:(NSInteger)takeAway menuID:(NSInteger)menuID orderTakingList:(NSMutableArray *)orderTakingList;
+(NSMutableArray *)sortListByNoteIDListInText:(NSMutableArray *)orderTakingList;
+(NSMutableArray *)sortListByModifiedDateDesc:(NSMutableArray *)orderTakingList;
+(NSMutableArray *)sortListByOrderTakingIDDesc:(NSMutableArray *)orderTakingList;
+(NSMutableArray *)separateOrder:(NSMutableArray *)orderTakingList;
//+(void)removeAllObject;
+(NSMutableArray *)getOrderTakingList;
+(NSMutableArray *)getCurrentOrderTakingList;
+(void)setCurrentOrderTakingList:(NSMutableArray *)orderTakingList;
+(void)removeCurrentOrderTakingList;
+(NSMutableArray *)createSumUpOrderTakingWithTheSameMenuAndNote:(NSMutableArray *)orderTakingList;
+(float)getSumQuantity:(NSMutableArray *)orderTakingList;
+(float)getSumSpecialPrice:(NSMutableArray *)orderTakingList;
+(NSMutableArray *)updateStatus:(NSInteger)status orderTakingList:(NSMutableArray *)orderTakingList;
+(void)removeAllObjects;
+(NSMutableArray *)getOrderTakingListWithReceiptID:(NSInteger)receiptID branchID:(NSInteger)branchID;
@end
