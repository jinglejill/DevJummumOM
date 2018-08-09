//
//  PromoCode.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 3/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PromoCode : NSObject
@property (nonatomic) NSInteger promoCodeID;
@property (retain, nonatomic) NSString * code;
@property (nonatomic) NSInteger rewardRedemptionID;
@property (nonatomic) NSInteger orderNo;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;




@property (retain, nonatomic) NSDate * rewardRedemptionSortDate;

-(PromoCode *)initWithCode:(NSString *)code rewardRedemptionID:(NSInteger)rewardRedemptionID orderNo:(NSInteger)orderNo;
+(NSInteger)getNextID;
+(void)addObject:(PromoCode *)promoCode;
+(void)removeObject:(PromoCode *)promoCode;
+(void)addList:(NSMutableArray *)promoCodeList;
+(void)removeList:(NSMutableArray *)promoCodeList;
+(PromoCode *)getPromoCode:(NSInteger)promoCodeID;
-(BOOL)editPromoCode:(PromoCode *)editingPromoCode;
+(PromoCode *)copyFrom:(PromoCode *)fromPromoCode to:(PromoCode *)toPromoCode;
+(NSMutableArray *)sort:(NSMutableArray *)promoCodeList;
@end
