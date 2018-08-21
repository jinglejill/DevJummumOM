//
//  Device.m
//  SAIM_TEST
//
//  Created by Thidaporn Kijkamjai on 2/2/2560 BE.
//  Copyright © 2560 Thidaporn Kijkamjai. All rights reserved.
//

#import "Device.h"
#import "SharedDevice.h"
#import "Utility.h"


@implementation Device
-(Device *)initWithDeviceToken:(NSString *)deviceToken model:(NSString *)model remark:(NSString *)remark
{
    self = [super init];
    if(self)
    {
        self.deviceID = [Device getNextID];
        self.deviceToken = deviceToken;
        self.model = model;
        self.remark = remark;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"deviceID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedDevice sharedDevice].deviceList;
    
    
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

+(void)addObject:(Device *)device
{
    NSMutableArray *dataList = [SharedDevice sharedDevice].deviceList;
    [dataList addObject:device];
}

+(void)removeObject:(Device *)device
{
    NSMutableArray *dataList = [SharedDevice sharedDevice].deviceList;
    [dataList removeObject:device];
}

+(void)addList:(NSMutableArray *)deviceList
{
    NSMutableArray *dataList = [SharedDevice sharedDevice].deviceList;
    [dataList addObjectsFromArray:deviceList];
}

+(void)removeList:(NSMutableArray *)deviceList
{
    NSMutableArray *dataList = [SharedDevice sharedDevice].deviceList;
    [dataList removeObjectsInArray:deviceList];
}

+(Device *)getDevice:(NSInteger)deviceID
{
    NSMutableArray *dataList = [SharedDevice sharedDevice].deviceList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_deviceID = %ld",deviceID];
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
        ((Device *)copy).deviceID = self.deviceID;
        [copy setDeviceToken:self.deviceToken];
        [copy setModel:self.model];
        [copy setRemark:self.remark];
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
    }
    
    return copy;
}

-(BOOL)editDevice:(Device *)editingDevice
{
    if(self.deviceID == editingDevice.deviceID
       && [self.deviceToken isEqualToString:editingDevice.deviceToken]
       && [self.model isEqualToString:editingDevice.model]
       && [self.remark isEqualToString:editingDevice.remark]
       )
    {
        return NO;
    }
    return YES;
}

+(Device *)copyFrom:(Device *)fromDevice to:(Device *)toDevice
{
    toDevice.deviceID = fromDevice.deviceID;
    toDevice.deviceToken = fromDevice.deviceToken;
    toDevice.model = fromDevice.model;
    toDevice.remark = fromDevice.remark;
    toDevice.modifiedUser = [Utility modifiedUser];
    toDevice.modifiedDate = [Utility currentDateTime];
    
    return toDevice;
}
@end
