//
//  Branch.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Branch : NSObject
@property (nonatomic) NSInteger branchID;
@property (retain, nonatomic) NSString * dbName;
@property (nonatomic) NSInteger mainBranchID;
@property (retain, nonatomic) NSString * branchNo;
@property (retain, nonatomic) NSString * name;
@property (retain, nonatomic) NSString * street;
@property (retain, nonatomic) NSString * district;
@property (retain, nonatomic) NSString * province;
@property (retain, nonatomic) NSString * postCode;
@property (nonatomic) NSInteger subDistrictID;
@property (nonatomic) NSInteger districtID;
@property (nonatomic) NSInteger provinceID;
@property (nonatomic) NSInteger zipCodeID;
@property (retain, nonatomic) NSString * country;
@property (retain, nonatomic) NSString * map;
@property (retain, nonatomic) NSString * phoneNo;
@property (nonatomic) NSInteger tableNum;
@property (nonatomic) NSInteger customerNumMax;
@property (nonatomic) NSInteger employeePermanentNum;
@property (nonatomic) NSInteger status;
@property (nonatomic) NSInteger takeAwayFee;
@property (nonatomic) float serviceChargePercent;
@property (nonatomic) float percentVat;
@property (nonatomic) NSInteger priceIncludeVat;
@property (nonatomic) NSInteger customerApp;
@property (retain, nonatomic) NSString * imageUrl;
@property (retain, nonatomic) NSDate * startDate;
@property (retain, nonatomic) NSString * remark;
@property (retain, nonatomic) NSString * deviceTokenReceiveOrder;
@property (retain, nonatomic) NSString * urlNoti;
@property (nonatomic) NSInteger alarmShop;
@property (nonatomic) NSInteger ledStatus;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;



-(Branch *)initWithDbName:(NSString *)dbName mainBranchID:(NSInteger)mainBranchID branchNo:(NSString *)branchNo name:(NSString *)name street:(NSString *)street district:(NSString *)district province:(NSString *)province postCode:(NSString *)postCode subDistrictID:(NSInteger)subDistrictID districtID:(NSInteger)districtID provinceID:(NSInteger)provinceID zipCodeID:(NSInteger)zipCodeID country:(NSString *)country map:(NSString *)map phoneNo:(NSString *)phoneNo tableNum:(NSInteger)tableNum customerNumMax:(NSInteger)customerNumMax employeePermanentNum:(NSInteger)employeePermanentNum status:(NSInteger)status takeAwayFee:(NSInteger)takeAwayFee serviceChargePercent:(float)serviceChargePercent percentVat:(float)percentVat priceIncludeVat:(NSInteger)priceIncludeVat customerApp:(NSInteger)customerApp imageUrl:(NSString *)imageUrl startDate:(NSDate *)startDate remark:(NSString *)remark deviceTokenReceiveOrder:(NSString *)deviceTokenReceiveOrder urlNoti:(NSString *)urlNoti alarmShop:(NSInteger)alarmShop ledStatus:(NSInteger)ledStatus;


+(NSInteger)getNextID;
+(void)addObject:(Branch *)branch;
+(void)removeObject:(Branch *)branch;
+(void)addList:(NSMutableArray *)branchList;
+(void)removeList:(NSMutableArray *)branchList;
+(Branch *)getBranch:(NSInteger)branchID;
-(BOOL)editBranch:(Branch *)editingBranch;
+(Branch *)copyFrom:(Branch *)fromBranch to:(Branch *)toBranch;
+(NSMutableArray *)getBranchList;
+(NSString *)getAddress:(Branch *)branch;
+(NSMutableArray *)sortList:(NSMutableArray *)branchList;

@end
