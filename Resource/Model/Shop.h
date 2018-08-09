//
//  Shop.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 18/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shop : NSObject
@property (nonatomic) NSInteger shopID;
@property (retain, nonatomic) NSString * name;
@property (retain, nonatomic) NSString * remark;
@property (nonatomic) float percentVat;
@property (nonatomic) NSInteger status;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;



-(Shop *)initWithName:(NSString *)name remark:(NSString *)remark percentVat:(float)percentVat status:(NSInteger)status;
+(NSInteger)getNextID;
+(void)addObject:(Shop *)shop;
+(void)removeObject:(Shop *)shop;
+(void)addList:(NSMutableArray *)shopList;
+(void)removeList:(NSMutableArray *)shopList;
+(Shop *)getShop:(NSInteger)shopID;
-(BOOL)editShop:(Shop *)editingShop;
+(Shop *)copyFrom:(Shop *)fromShop to:(Shop *)toShop;


@end
