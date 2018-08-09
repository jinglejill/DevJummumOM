//
//  RewardViewController.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 4/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"

@interface RewardViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tbvData;

- (IBAction)goBack:(id)sender;
-(IBAction)unwindToReward:(UIStoryboardSegue *)segue;
@end
