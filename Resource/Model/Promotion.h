//
//  Promotion.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 20/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Promotion : NSObject
@property (nonatomic) NSInteger promotionID;
@property (retain, nonatomic) NSDate * startDate;
@property (retain, nonatomic) NSDate * endDate;
@property (nonatomic) NSInteger discountType;
@property (nonatomic) float discountAmount;
@property (nonatomic) NSInteger minimumSpending;
@property (nonatomic) NSInteger maxDiscountAmountPerDay;
@property (nonatomic) NSInteger allowEveryone;
@property (nonatomic) NSInteger allowDiscountForAllMenuType;
@property (nonatomic) NSInteger noOfLimitUse;
@property (nonatomic) NSInteger noOfLimitUsePerUser;
@property (nonatomic) NSInteger noOfLimitUsePerUserPerDay;
@property (retain, nonatomic) NSString * voucherCode;
@property (nonatomic) NSInteger status;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;




@property (nonatomic) float moreDiscountToGo;
@property (nonatomic) NSInteger rewardRedemptionID;


-(Promotion *)initWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate discountType:(NSInteger)discountType discountAmount:(float)discountAmount minimumSpending:(NSInteger)minimumSpending maxDiscountAmountPerDay:(NSInteger)maxDiscountAmountPerDay allowEveryone:(NSInteger)allowEveryone allowDiscountForAllMenuType:(NSInteger)allowDiscountForAllMenuType noOfLimitUse:(NSInteger)noOfLimitUse noOfLimitUsePerUser:(NSInteger)noOfLimitUsePerUser noOfLimitUsePerUserPerDay:(NSInteger)noOfLimitUsePerUserPerDay voucherCode:(NSString *)voucherCode status:(NSInteger)status;
+(NSInteger)getNextID;
+(void)addObject:(Promotion *)promotion;
+(void)removeObject:(Promotion *)promotion;
+(void)addList:(NSMutableArray *)promotionList;
+(void)removeList:(NSMutableArray *)promotionList;
+(Promotion *)getPromotion:(NSInteger)promotionID;
-(BOOL)editPromotion:(Promotion *)editingPromotion;
+(Promotion *)copyFrom:(Promotion *)fromPromotion to:(Promotion *)toPromotion;


@end
