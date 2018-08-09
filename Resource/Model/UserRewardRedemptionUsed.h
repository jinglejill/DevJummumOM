//
//  UserRewardRedemptionUsed.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 6/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserRewardRedemptionUsed : NSObject
@property (nonatomic) NSInteger userRewardRedemptionUsedID;
@property (nonatomic) NSInteger userAccountID;
@property (nonatomic) NSInteger rewardRedemptionID;
@property (nonatomic) NSInteger receiptID;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;



-(UserRewardRedemptionUsed *)initWithUserAccountID:(NSInteger)userAccountID rewardRedemptionID:(NSInteger)rewardRedemptionID receiptID:(NSInteger)receiptID;
+(NSInteger)getNextID;
+(void)addObject:(UserRewardRedemptionUsed *)userRewardRedemptionUsed;
+(void)removeObject:(UserRewardRedemptionUsed *)userRewardRedemptionUsed;
+(void)addList:(NSMutableArray *)userRewardRedemptionUsedList;
+(void)removeList:(NSMutableArray *)userRewardRedemptionUsedList;
+(UserRewardRedemptionUsed *)getUserRewardRedemptionUsed:(NSInteger)userRewardRedemptionUsedID;
-(BOOL)editUserRewardRedemptionUsed:(UserRewardRedemptionUsed *)editingUserRewardRedemptionUsed;
+(UserRewardRedemptionUsed *)copyFrom:(UserRewardRedemptionUsed *)fromUserRewardRedemptionUsed to:(UserRewardRedemptionUsed *)toUserRewardRedemptionUsed;


@end
