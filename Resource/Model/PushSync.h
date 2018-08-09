//
//  PushSync.h
//  SAIM_UPDATING
//
//  Created by Thidaporn Kijkamjai on 5/3/2559 BE.
//  Copyright © 2559 Thidaporn Kijkamjai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushSync : NSObject
@property (nonatomic) NSInteger pushSyncID;
@property (retain, nonatomic) NSString * deviceToken;
@property (retain, nonatomic) NSString * tableName;
@property (retain, nonatomic) NSString * action;
@property (retain, nonatomic) NSString * data;
@property (retain, nonatomic) NSString * timeSync;
@property (retain, nonatomic) NSString * timeSynced;
@property (retain, nonatomic) NSString * queryTime;
@property (retain, nonatomic) NSString * status;
@property (retain, nonatomic) NSString * modifiedDate;
@property (retain, nonatomic) NSString * modifiedUser;//ใช้ตอน delete row ที่ duplicate key
//ใช้เฉพาะตอน push type = 'd'
//ใช้ตอน update or delete

-(PushSync *)initWithPushSyncID:(NSInteger)pushSyncID;
+(void)addObject:(PushSync *)pushSync;
+ (BOOL)alreadySynced:(NSInteger)pushSyncID;
@end
