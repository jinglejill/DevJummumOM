//
//  CredentialsDb.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 6/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CredentialsDb : NSObject
@property (nonatomic) NSInteger credentialsDbID;
@property (nonatomic) NSInteger credentialsID;
@property (retain, nonatomic) NSString * dbName;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;



@property (retain, nonatomic) NSString * name;
@property (nonatomic) NSInteger branchID;

+(NSString *)getNameWithDbName:(NSString *)dbName credentialsDbList:(NSMutableArray *)credentialsDbList;
+(NSInteger)getSelectedIndexWithDbName:(NSString *)dbName credentialsDbList:(NSMutableArray *)credentialsDbList;
+(void)setCurrentCredentialsDb:(CredentialsDb *)credentialsDb;
+(CredentialsDb *)getCurrentCredentialsDb;
@end
