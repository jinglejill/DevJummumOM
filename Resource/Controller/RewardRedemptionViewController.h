//
//  RewardRedemptionViewController.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 1/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "RewardPoint.h"
#import "RewardRedemption.h"
#import "PromoCode.h"


@interface RewardRedemptionViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tbvData;
@property (strong, nonatomic) IBOutlet UILabel *lblCountDown;
@property (strong, nonatomic) RewardPoint *rewardPoint;
@property (strong, nonatomic) RewardPoint *rewardPointSpent;
@property (strong, nonatomic) RewardRedemption *rewardRedemption;
@property (strong, nonatomic) PromoCode *promoCode;
@property (nonatomic) NSInteger fromMenuMyReward;

- (IBAction)goBack:(id)sender;
@end
