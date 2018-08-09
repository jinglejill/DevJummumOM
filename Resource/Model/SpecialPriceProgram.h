//
//  SpecialPriceProgram.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 10/10/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpecialPriceProgram : NSObject
@property (nonatomic) NSInteger specialPriceProgramID;
@property (nonatomic) NSInteger menuID;
@property (retain, nonatomic) NSDate * startDate;
@property (retain, nonatomic) NSDate * endDate;
@property (nonatomic) float specialPrice;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;


@property (nonatomic) NSInteger menuOrder;

-(SpecialPriceProgram *)initWithMenuID:(NSInteger)menuID startDate:(NSDate *)startDate endDate:(NSDate *)endDate specialPrice:(float)specialPrice;
+(NSInteger)getNextID;
+(void)addObject:(SpecialPriceProgram *)specialPriceProgram;
+(void)removeObject:(SpecialPriceProgram *)specialPriceProgram;
+(void)addList:(NSMutableArray *)specialPriceProgramList;
+(void)removeList:(NSMutableArray *)specialPriceProgramList;
+(SpecialPriceProgram *)getSpecialPriceProgram:(NSInteger)specialPriceProgramID;
+(SpecialPriceProgram *)getSpecialPriceProgramTodayWithMenuID:(NSInteger)menuID branchID:(NSInteger)branchID;
+(NSMutableArray *)getSpecialPriceProgramListWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;
+(NSMutableArray *)sortList:(NSMutableArray *)specialPriceProgramList;
+(void)setSharedData:(NSMutableArray *)dataList;
@end
