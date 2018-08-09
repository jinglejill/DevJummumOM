//
//  HotDealViewController.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 23/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"

@interface HotDealViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tbvData;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@end
