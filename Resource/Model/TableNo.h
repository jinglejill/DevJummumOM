//
//  TableNo.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 18/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableNo : NSObject
@property (nonatomic) NSInteger tableNoID;
@property (nonatomic) NSInteger shopID;
@property (nonatomic) NSInteger name;
@property (retain, nonatomic) NSString * remark;
@property (nonatomic) NSInteger type;
@property (nonatomic) NSInteger zone;
@property (nonatomic) NSInteger status;
@property (nonatomic) NSInteger orderNo;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;



-(TableNo *)initWithShopID:(NSInteger)shopID name:(NSInteger)name remark:(NSString *)remark type:(NSInteger)type zone:(NSInteger)zone status:(NSInteger)status orderNo:(NSInteger)orderNo;
+(NSInteger)getNextID;
+(void)addObject:(TableNo *)tableNo;
+(void)removeObject:(TableNo *)tableNo;
+(void)addList:(NSMutableArray *)tableNoList;
+(void)removeList:(NSMutableArray *)tableNoList;
+(TableNo *)getTableNo:(NSInteger)tableNoID;
-(BOOL)editTableNo:(TableNo *)editingTableNo;
+(TableNo *)copyFrom:(TableNo *)fromTableNo to:(TableNo *)toTableNo;


@end
