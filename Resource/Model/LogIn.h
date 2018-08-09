//
//  Login.h
//  SAIM_UPDATING
//
//  Created by Thidaporn Kijkamjai on 5/2/2559 BE.
//  Copyright © 2559 Thidaporn Kijkamjai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogIn : NSObject
@property (nonatomic) NSInteger logInID;
@property (retain, nonatomic) NSString * username;
@property (nonatomic) NSInteger status;
@property (retain, nonatomic) NSString * deviceToken;
@property (retain, nonatomic) NSString * modifiedUser;//ใช้ตอน delete row ที่ duplicate key
@property (retain, nonatomic) NSDate * modifiedDate;


//ใช้เฉพาะตอน push type = 'd'
//ใช้ตอน update or delete


-(LogIn *)initWithUsername:(NSString *)username status:(NSInteger)status deviceToken:(NSString *)deviceToken;
+(NSInteger)getNextID;
+(void)addObject:(LogIn *)logIn;

@end
