//
//  Setting.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/28/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Setting : NSObject
@property (nonatomic) NSInteger settingID;
@property (retain, nonatomic) NSString * keyName;
@property (retain, nonatomic) NSString * value;
@property (nonatomic) NSInteger type;
@property (retain, nonatomic) NSString * remark;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;




-(Setting *)initWithKeyName:(NSString *)keyName value:(NSString *)value type:(NSInteger)type remark:(NSString *)remark;
+(NSInteger)getNextID;
+(void)addObject:(Setting *)setting;
+(void)removeObject:(Setting *)setting;
+(void)addList:(NSMutableArray *)settingList;
+(void)removeList:(NSMutableArray *)settingList;
+(Setting *)getSetting:(NSInteger)settingID;
+(NSString *)getSettingValueWithKeyName:(NSString *)keyName;
+(Setting *)getSettingWithKeyName:(NSString *)keyName;
+(BOOL)isDeleteOrderPasswordValid:(NSString *)password;
+(NSString *)getValue:(NSString *)keyName example:(NSString *)example;
@end
