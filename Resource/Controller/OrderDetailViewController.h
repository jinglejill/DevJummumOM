//
//  OrderDetailViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 16/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "Receipt.h"
#import "CredentialsDb.h"



@interface OrderDetailViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (strong, nonatomic) IBOutlet UITableView *tbvData;
@property (strong, nonatomic) Receipt *receipt;
@property (strong, nonatomic) CredentialsDb *credentialsDb;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;


-(IBAction)unwindToOrderDetail:(UIStoryboardSegue *)segue;
- (IBAction)goBack:(id)sender;
-(void)reloadTableView;
- (IBAction)refresh:(id)sender;
@end
