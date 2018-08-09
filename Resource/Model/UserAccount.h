//
//  UserAccount.h
//  SaleAndInventoryManagement
//
//  Created by Thidaporn Kijkamjai on 7/10/2558 BE.
//  Copyright (c) 2558 Thidaporn Kijkamjai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeychainWrapper.h"


@interface UserAccount : NSObject
@property (nonatomic) NSInteger userAccountID;
@property (retain, nonatomic) NSString * username;
@property (retain, nonatomic) NSString * password;
@property (retain, nonatomic) NSString * deviceToken;
@property (retain, nonatomic) NSString * fullName;
@property (retain, nonatomic) NSString * nickName;
@property (retain, nonatomic) NSDate * birthDate;
@property (retain, nonatomic) NSString * email;
@property (retain, nonatomic) NSString * phoneNo;
@property (retain, nonatomic) NSString * lineID;
@property (nonatomic) NSInteger roleID;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;



-(UserAccount *)initWithUsername:(NSString *)username password:(NSString *)password deviceToken:(NSString *)deviceToken fullName:(NSString *)fullName nickName:(NSString *)nickName birthDate:(NSDate *)birthDate email:(NSString *)email phoneNo:(NSString *)phoneNo lineID:(NSString *)lineID roleID:(NSInteger)roleID;
+(NSInteger)getNextID;
+(void)addObject:(UserAccount *)userAccount;
+(BOOL)usernameExist:(NSString *)username;
+(BOOL)isPasswordValidWithUsername:(NSString *)username password:(NSString *)password;
+(UserAccount *)getUserAccount:(NSInteger)userAccountID;
+(UserAccount *)getUserAccountWithUsername:(NSString *)username;
+(void)setCurrentUserAccount:(UserAccount *)userAccount;
+(UserAccount *)getCurrentUserAccount;
+(NSString *)getFirstNameWithFullName:(NSString *)fullName;
@end
