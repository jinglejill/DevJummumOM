//
//  Branch.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "Branch.h"
#import "SharedBranch.h"
#import "Utility.h"
#import "SharedCurrentBranch.h"


@implementation Branch

-(Branch *)initWithDbName:(NSString *)dbName mainBranchID:(NSInteger)mainBranchID branchNo:(NSString *)branchNo name:(NSString *)name street:(NSString *)street district:(NSString *)district province:(NSString *)province postCode:(NSString *)postCode subDistrictID:(NSInteger)subDistrictID districtID:(NSInteger)districtID provinceID:(NSInteger)provinceID zipCodeID:(NSInteger)zipCodeID country:(NSString *)country map:(NSString *)map phoneNo:(NSString *)phoneNo tableNum:(NSInteger)tableNum customerNumMax:(NSInteger)customerNumMax employeePermanentNum:(NSInteger)employeePermanentNum status:(NSInteger)status takeAwayFee:(NSInteger)takeAwayFee serviceChargePercent:(float)serviceChargePercent percentVat:(float)percentVat priceIncludeVat:(NSInteger)priceIncludeVat customerApp:(NSInteger)customerApp imageUrl:(NSString *)imageUrl startDate:(NSDate *)startDate remark:(NSString *)remark deviceTokenReceiveOrder:(NSString *)deviceTokenReceiveOrder urlNoti:(NSString *)urlNoti alarmShop:(NSInteger)alarmShop ledStatus:(NSInteger)ledStatus
{
    self = [super init];
    if(self)
    {
        self.branchID = [Branch getNextID];
        self.dbName = dbName;
        self.mainBranchID = mainBranchID;
        self.branchNo = branchNo;
        self.name = name;
        self.street = street;
        self.district = district;
        self.province = province;
        self.postCode = postCode;
        self.subDistrictID = subDistrictID;
        self.districtID = districtID;
        self.provinceID = provinceID;
        self.zipCodeID = zipCodeID;
        self.country = country;
        self.map = map;
        self.phoneNo = phoneNo;
        self.tableNum = tableNum;
        self.customerNumMax = customerNumMax;
        self.employeePermanentNum = employeePermanentNum;
        self.status = status;
        self.takeAwayFee = takeAwayFee;
        self.serviceChargePercent = serviceChargePercent;
        self.percentVat = percentVat;
        self.priceIncludeVat = priceIncludeVat;
        self.customerApp = customerApp;
        self.imageUrl = imageUrl;
        self.startDate = startDate;
        self.remark = remark;
        self.deviceTokenReceiveOrder = deviceTokenReceiveOrder;
        self.urlNoti = urlNoti;
        self.alarmShop = alarmShop;
        self.ledStatus = ledStatus;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"branchID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedBranch sharedBranch].branchList;
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:propertyName ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [dataList sortedArrayUsingDescriptors:sortDescriptors];
    dataList = [sortArray mutableCopy];
    
    if([dataList count] == 0)
    {
        return -1;
    }
    else
    {
        id value = [dataList[0] valueForKey:primaryKeyName];
        if([value integerValue]>0)
        {
            return -1;
        }
        else
        {
            return [value integerValue]-1;
        }
    }
}

+(void)addObject:(Branch *)branch
{
    NSMutableArray *dataList = [SharedBranch sharedBranch].branchList;
    [dataList addObject:branch];
}

+(void)removeObject:(Branch *)branch
{
    NSMutableArray *dataList = [SharedBranch sharedBranch].branchList;
    [dataList removeObject:branch];
}

+(void)addList:(NSMutableArray *)branchList
{
    NSMutableArray *dataList = [SharedBranch sharedBranch].branchList;
    [dataList addObjectsFromArray:branchList];
}

+(void)removeList:(NSMutableArray *)branchList
{
    NSMutableArray *dataList = [SharedBranch sharedBranch].branchList;
    [dataList removeObjectsInArray:branchList];
}

+(Branch *)getBranch:(NSInteger)branchID
{
    NSMutableArray *dataList = [SharedBranch sharedBranch].branchList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_branchID = %ld",branchID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

-(id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        ((Branch *)copy).branchID = self.branchID;
        [copy setDbName:self.dbName];
        ((Branch *)copy).mainBranchID = self.mainBranchID;
        [copy setBranchNo:self.branchNo];
        [copy setName:self.name];
        [copy setStreet:self.street];
        [copy setDistrict:self.district];
        [copy setProvince:self.province];
        [copy setPostCode:self.postCode];
        ((Branch *)copy).subDistrictID = self.subDistrictID;
        ((Branch *)copy).districtID = self.districtID;
        ((Branch *)copy).provinceID = self.provinceID;
        ((Branch *)copy).zipCodeID = self.zipCodeID;
        [copy setCountry:self.country];
        [copy setMap:self.map];
        [copy setPhoneNo:self.phoneNo];
        ((Branch *)copy).tableNum = self.tableNum;
        ((Branch *)copy).customerNumMax = self.customerNumMax;
        ((Branch *)copy).employeePermanentNum = self.employeePermanentNum;
        ((Branch *)copy).status = self.status;
        ((Branch *)copy).takeAwayFee = self.takeAwayFee;
        ((Branch *)copy).serviceChargePercent = self.serviceChargePercent;
        ((Branch *)copy).percentVat = self.percentVat;
        ((Branch *)copy).priceIncludeVat = self.priceIncludeVat;
        ((Branch *)copy).customerApp = self.customerApp;
        [copy setImageUrl:self.imageUrl];
        [copy setStartDate:self.startDate];
        [copy setRemark:self.remark];
        [copy setDeviceTokenReceiveOrder:self.deviceTokenReceiveOrder];
        [copy setUrlNoti:self.urlNoti];
        ((Branch *)copy).alarmShop = self.alarmShop;
        ((Branch *)copy).ledStatus = self.ledStatus;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        
        
    }
    
    return copy;
}

-(BOOL)editBranch:(Branch *)editingBranch
{
    if(self.branchID == editingBranch.branchID
       && [self.dbName isEqualToString:editingBranch.dbName]
       && self.mainBranchID == editingBranch.mainBranchID
       && [self.branchNo isEqualToString:editingBranch.branchNo]
       && [self.name isEqualToString:editingBranch.name]
       && [self.street isEqualToString:editingBranch.street]
       && [self.district isEqualToString:editingBranch.district]
       && [self.province isEqualToString:editingBranch.province]
       && [self.postCode isEqualToString:editingBranch.postCode]
       && self.subDistrictID == editingBranch.subDistrictID
       && self.districtID == editingBranch.districtID
       && self.provinceID == editingBranch.provinceID
       && self.zipCodeID == editingBranch.zipCodeID
       && [self.country isEqualToString:editingBranch.country]
       && [self.map isEqualToString:editingBranch.map]
       && [self.phoneNo isEqualToString:editingBranch.phoneNo]
       && self.tableNum == editingBranch.tableNum
       && self.customerNumMax == editingBranch.customerNumMax
       && self.employeePermanentNum == editingBranch.employeePermanentNum
       && self.status == editingBranch.status
       && self.takeAwayFee == editingBranch.takeAwayFee
       && self.serviceChargePercent == editingBranch.serviceChargePercent
       && self.percentVat == editingBranch.percentVat
       && self.priceIncludeVat == editingBranch.priceIncludeVat
       && self.customerApp == editingBranch.customerApp
       && [self.imageUrl isEqualToString:editingBranch.imageUrl]
       && [self.startDate isEqual:editingBranch.startDate]
       && [self.remark isEqualToString:editingBranch.remark]
       && [self.deviceTokenReceiveOrder isEqualToString:editingBranch.deviceTokenReceiveOrder]
       && [self.urlNoti isEqualToString:editingBranch.urlNoti]
       && self.alarmShop == editingBranch.alarmShop
       && self.ledStatus == editingBranch.ledStatus
       )
    {
        return NO;
    }
    return YES;
}

+(Branch *)copyFrom:(Branch *)fromBranch to:(Branch *)toBranch
{
    toBranch.branchID = fromBranch.branchID;
    toBranch.dbName = fromBranch.dbName;
    toBranch.mainBranchID = fromBranch.mainBranchID;
    toBranch.branchNo = fromBranch.branchNo;
    toBranch.name = fromBranch.name;
    toBranch.street = fromBranch.street;
    toBranch.district = fromBranch.district;
    toBranch.province = fromBranch.province;
    toBranch.postCode = fromBranch.postCode;
    toBranch.subDistrictID = fromBranch.subDistrictID;
    toBranch.districtID = fromBranch.districtID;
    toBranch.provinceID = fromBranch.provinceID;
    toBranch.zipCodeID = fromBranch.zipCodeID;
    toBranch.country = fromBranch.country;
    toBranch.map = fromBranch.map;
    toBranch.phoneNo = fromBranch.phoneNo;
    toBranch.tableNum = fromBranch.tableNum;
    toBranch.customerNumMax = fromBranch.customerNumMax;
    toBranch.employeePermanentNum = fromBranch.employeePermanentNum;
    toBranch.status = fromBranch.status;
    toBranch.takeAwayFee = fromBranch.takeAwayFee;
    toBranch.serviceChargePercent = fromBranch.serviceChargePercent;
    toBranch.percentVat = fromBranch.percentVat;
    toBranch.priceIncludeVat = fromBranch.priceIncludeVat;
    toBranch.customerApp = fromBranch.customerApp;
    toBranch.imageUrl = fromBranch.imageUrl;
    toBranch.startDate = fromBranch.startDate;
    toBranch.remark = fromBranch.remark;
    toBranch.deviceTokenReceiveOrder = fromBranch.deviceTokenReceiveOrder;
    toBranch.urlNoti = fromBranch.urlNoti;
    toBranch.alarmShop = fromBranch.alarmShop;
    toBranch.ledStatus = fromBranch.ledStatus;
    toBranch.modifiedUser = [Utility modifiedUser];
    toBranch.modifiedDate = [Utility currentDateTime];
    
    return toBranch;
}


+(NSMutableArray *)getBranchList
{
    return [SharedBranch sharedBranch].branchList;
}

+(NSString *)getAddress:(Branch *)branch
{
    NSString *strStreet = branch.street;
    NSString *strDistrict = ![Utility isStringEmpty:branch.district]?[NSString stringWithFormat:@" เขต%@",branch.district]:@"";
    NSString *strProvince = ![Utility isStringEmpty:branch.province]?[NSString stringWithFormat:@" %@",branch.province]:@"";
    NSString *strPostCode = ![Utility isStringEmpty:branch.postCode]?[NSString stringWithFormat:@" %@",branch.postCode]:@"";
    NSString *strCountry = ![Utility isStringEmpty:branch.country]?[NSString stringWithFormat:@" %@",branch.country]:@"";
    NSString *strAddress = [NSString stringWithFormat:@"%@%@%@%@%@",strStreet,strDistrict,strProvince,strPostCode,strCountry];
    return strAddress;
}

+(NSMutableArray *)sortList:(NSMutableArray *)branchList
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [branchList sortedArrayUsingDescriptors:sortDescriptors];
    
    return [sortArray mutableCopy];    
}

+(void)setCurrentBranch:(Branch *)branch
{
    [SharedCurrentBranch sharedCurrentBranch].branch = branch;
}

+(Branch *)getCurrentBranch
{
    return [SharedCurrentBranch sharedCurrentBranch].branch;
}
@end
