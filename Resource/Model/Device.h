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
@property (retain, nonatomic) NSString * remark;
@property (retain, nonatomic) NSDate * modifiedDate;
@property (retain, nonatomic) NSString * modifiedUser;//ใช้ตอน delete row ที่ duplicate key
//ใช้เฉพาะตอน push type = 'd'
//ใช้ตอน update or delete

@end
