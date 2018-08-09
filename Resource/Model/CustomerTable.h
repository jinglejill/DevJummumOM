//
//  CustomerTable.h
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/9/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerTable : NSObject
@property (nonatomic) NSInteger customerTableID;
@property (retain, nonatomic) NSString * tableName;
@property (nonatomic) NSInteger type;
@property (retain, nonatomic) NSString * color;
@property (retain, nonatomic) NSString * zone;
@property (nonatomic) NSInteger orderNo;
@property (nonatomic) NSInteger status;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;



@property (nonatomic) NSInteger branchID;

-(CustomerTable *)initWithTableName:(NSString *)tableName type:(NSInteger)type color:(NSString *)color zone:(NSString *)zone orderNo:(NSInteger)orderNo status:(NSInteger)status;
+(NSInteger)getNextID;
+(void)addObject:(CustomerTable *)customerTable;
+(CustomerTable *)getCustomerTable:(NSInteger)customerTableID;
+(CustomerTable *)getCustomerTable:(NSInteger)customerTableID branchID:(NSInteger)branchID;
+(NSMutableArray *)getCustomerTableListWithStatus:(NSInteger)status;
+(CustomerTable *)getCustomerTableWithTableName:(NSString *)tableName status:(NSInteger)status;
+(NSInteger)getSelectedIndexWithCustomerTableList:(NSMutableArray *)customerTableList customerTableID:(NSInteger)customerTableID;
+(NSString *)getTableNameListInTextWithCustomerTableList:(NSMutableArray *)customerTableList;
+(NSMutableArray *)getCustomerTableListWithCustomerTableIDList:(NSArray*)customerTableIDList;
+(NSMutableArray *)sortList:(NSMutableArray *)customerTableList;

+(NSMutableArray *)getCustomerTableZoneListWithType:(NSInteger)type status:(NSInteger)status;
+(NSMutableArray *)getCustomerTableZoneListWithType:(NSInteger)type status:(NSInteger)status customerTableList:(NSMutableArray *)customerTableList;
+(NSMutableArray *)getCustomerTableZoneListWithCustomerTableList:(NSMutableArray *)customerTableList;
+(NSMutableArray *)getCustomerTableListWithType:(NSInteger)type status:(NSInteger)status;
+(NSMutableArray *)getCustomerTableListWithType:(NSInteger)type status:(NSInteger)status customerTableList:(NSMutableArray *)customerTableList;
+(NSMutableArray *)getCustomerTableListWithZone:(NSString *)zone customerTableList:(NSMutableArray *)customerTableList;
+(void)setSharedData:(NSMutableArray *)dataList;
+(NSMutableArray *)getCustomerTableListWithBranchID:(NSInteger)branchID;
@end
