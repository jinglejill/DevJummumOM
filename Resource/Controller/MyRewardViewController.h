//
//  MyRewardViewController.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 3/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "RewardPoint.h"


@interface MyRewardViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UISegmentedControl *segConValue;
@property (strong, nonatomic) IBOutlet UITableView *tbvData;
@property (strong, nonatomic) RewardPoint *rewardPoint;


-(IBAction)unwindToMyReward:(UIStoryboardSegue *)segue;
- (IBAction)goBack:(id)sender;
- (IBAction)segmentControlChanged:(id)sender;
@end
