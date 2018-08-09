//
//  Credentials.h
//  SAIM_UPDATING
//
//  Created by Thidaporn Kijkamjai on 8/3/2559 BE.
//  Copyright © 2559 Thidaporn Kijkamjai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Credentials : NSObject
@property (retain, nonatomic) NSString * credentialsID;
@property (retain, nonatomic) NSString * username;
@property (retain, nonatomic) NSString * password;
@property (retain, nonatomic) NSString * noOfDeviceAllowed;
@property (retain, nonatomic) NSString * modifiedDate;
@property (retain, nonatomic) NSString * modifiedUser;//ใช้ตอน delete row ที่ duplicate key
//ใช้เฉพาะตอน push type = 'd'
//ใช้ตอน update or delete

@end
