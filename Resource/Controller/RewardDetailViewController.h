//
//  RewardDetailViewController.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 30/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "RewardPoint.h"
#import "RewardRedemption.h"


@interface RewardDetailViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tbvData;
@property (strong, nonatomic) IBOutlet UIButton *btnRedeem;
@property (strong, nonatomic) RewardPoint *rewardPoint;
@property (strong, nonatomic) RewardRedemption *rewardRedemption;

-(IBAction)unwindToRewardDetail:(UIStoryboardSegue *)segue;
- (IBAction)redeemReward:(id)sender;
- (IBAction)goBack:(id)sender;

@end
