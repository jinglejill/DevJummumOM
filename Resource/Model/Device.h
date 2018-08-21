//
//  Device.h
//  SAIM_TEST
//
//  Created by Thidaporn Kijkamjai on 2/2/2560 BE.
//  Copyright © 2560 Thidaporn Kijkamjai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Device : NSObject

@property (nonatomic) NSInteger deviceID;
@property (retain, nonatomic) NSString * deviceToken;
@property (retain, nonatomic) NSString * model;
@property (retain, nonatomic) NSString * remark;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;

-(Device *)initWithDeviceToken:(NSString *)deviceToken model:(NSString *)model remark:(NSString *)remark;
+(NSInteger)getNextID;
+(void)addObject:(Device *)device;
+(void)removeObject:(Device *)device;
+(void)addList:(NSMutableArray *)deviceList;
+(void)removeList:(NSMutableArray *)deviceList;
+(Device *)getDevice:(NSInteger)deviceID;
-(BOOL)editDevice:(Device *)editingDevice;
+(Device *)copyFrom:(Device *)fromDevice to:(Device *)toDevice;


@end
