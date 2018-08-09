//
//  SubMenuType.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/19/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubMenuType : NSObject
@property (nonatomic) NSInteger subMenuTypeID;
@property (nonatomic) NSInteger menuTypeID;
@property (retain, nonatomic) NSString * name;
@property (nonatomic) NSInteger orderNo;
@property (nonatomic) NSInteger status;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;



-(SubMenuType *)initWithMenuTypeID:(NSInteger)menuTypeID name:(NSString *)name orderNo:(NSInteger)orderNo status:(NSInteger)status;
+(NSInteger)getNextID;
+(void)addObject:(SubMenuType *)subMenuType;
+(void)removeObject:(SubMenuType *)subMenuType;
+(SubMenuType *)getSubMenuType:(NSInteger)subMenuTypeID;
+(NSMutableArray *)getSubMenuTypeListWithMenuTypeID:(NSInteger)menuTypeID;
+(NSMutableArray *)getSubMenuTypeListWithMenuTypeID:(NSInteger)menuTypeID status:(NSInteger)status;
+(NSInteger)getNextOrderNoWithStatus:(NSInteger)status;
-(BOOL)editSubMenuType:(SubMenuType *)editingSubMenuType;
+(void)setSharedData:(NSMutableArray *)dataList;
+(NSMutableArray *)getSubMenuTypeList;

@end
