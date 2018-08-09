//
//  HotDeal.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 23/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotDeal : NSObject
@property (nonatomic) NSInteger hotDealID;
@property (nonatomic) NSInteger branchID;
@property (retain, nonatomic) NSDate * startDate;
@property (retain, nonatomic) NSDate * endDate;
@property (retain, nonatomic) NSString * header;
@property (retain, nonatomic) NSString * subTitle;
@property (retain, nonatomic) NSString * imageUrl;
@property (nonatomic) NSInteger orderNo;
@property (nonatomic) NSInteger status;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;




@property (retain, nonatomic) NSString * branchName;


-(HotDeal *)initWithBranchID:(NSInteger)branchID startDate:(NSDate *)startDate endDate:(NSDate *)endDate header:(NSString *)header subTitle:(NSString *)subTitle imageUrl:(NSString *)imageUrl orderNo:(NSInteger)orderNo status:(NSInteger)status;
+(NSInteger)getNextID;
+(void)addObject:(HotDeal *)hotDeal;
+(void)removeObject:(HotDeal *)hotDeal;
+(void)addList:(NSMutableArray *)hotDealList;
+(void)removeList:(NSMutableArray *)hotDealList;
+(HotDeal *)getHotDeal:(NSInteger)hotDealID;
-(BOOL)editHotDeal:(HotDeal *)editingHotDeal;
+(HotDeal *)copyFrom:(HotDeal *)fromHotDeal to:(HotDeal *)toHotDeal;



@end
