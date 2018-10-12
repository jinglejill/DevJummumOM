//
//  CustomerKitchenViewController.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 15/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"


@interface CustomerKitchenViewController : CustomViewController<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>



@property (strong, nonatomic) IBOutlet UITableView *tbvData;
@property (strong, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (strong, nonatomic) IBOutlet UIButton *btnShowPrintButton;
- (IBAction)showPrintButton:(id)sender;
- (IBAction)refresh:(id)sender;

-(IBAction)unwindToCustomerKitchen:(UIStoryboardSegue *)segue;

-(void)setReceiptList;
-(void)reloadTableView;
-(void)reloadTableViewNewOrderTab;
-(void)reloadTableViewIssueTab;
-(void)reloadTableViewProcessingTab;
-(void)reloadTableViewDeliveredTab;
-(void)reloadTableViewClearTab;



@end
