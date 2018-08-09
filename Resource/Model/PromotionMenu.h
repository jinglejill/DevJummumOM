//
//  PromotionMenu.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 20/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PromotionMenu : NSObject
@property (nonatomic) NSInteger promotionMenuID;
@property (nonatomic) NSInteger promotionID;
@property (nonatomic) NSInteger menuID;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;



-(PromotionMenu *)initWithPromotionID:(NSInteger)promotionID menuID:(NSInteger)menuID;
+(NSInteger)getNextID;
+(void)addObject:(PromotionMenu *)promotionMenu;
+(void)removeObject:(PromotionMenu *)promotionMenu;
+(void)addList:(NSMutableArray *)promotionMenuList;
+(void)removeList:(NSMutableArray *)promotionMenuList;
+(PromotionMenu *)getPromotionMenu:(NSInteger)promotionMenuID;
-(BOOL)editPromotionMenu:(PromotionMenu *)editingPromotionMenu;
+(PromotionMenu *)copyFrom:(PromotionMenu *)fromPromotionMenu to:(PromotionMenu *)toPromotionMenu;
+(PromotionMenu *)getPromotionMenuWithMenuID:(NSInteger)menuID promotionMenuList:(NSMutableArray *)promotionMenuList;
@end
