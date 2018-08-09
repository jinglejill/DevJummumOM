//
//  UserPromotionUsed.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 20/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserPromotionUsed : NSObject
@property (nonatomic) NSInteger userPromotionUsedID;
@property (nonatomic) NSInteger userAccountID;
@property (nonatomic) NSInteger promotionID;
@property (nonatomic) NSInteger receiptID;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;



-(UserPromotionUsed *)initWithUserAccountID:(NSInteger)userAccountID promotionID:(NSInteger)promotionID receiptID:(NSInteger)receiptID;
+(NSInteger)getNextID;
+(void)addObject:(UserPromotionUsed *)userPromotionUsed;
+(void)removeObject:(UserPromotionUsed *)userPromotionUsed;
+(void)addList:(NSMutableArray *)userPromotionUsedList;
+(void)removeList:(NSMutableArray *)userPromotionUsedList;
+(UserPromotionUsed *)getUserPromotionUsed:(NSInteger)userPromotionUsedID;
-(BOOL)editUserPromotionUsed:(UserPromotionUsed *)editingUserPromotionUsed;
+(UserPromotionUsed *)copyFrom:(UserPromotionUsed *)fromUserPromotionUsed to:(UserPromotionUsed *)toUserPromotionUsed;



@end
