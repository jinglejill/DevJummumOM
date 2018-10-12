//
//  RunningReceiptViewController.h
//  DevJummumOM
//
//  Created by Thidaporn Kijkamjai on 8/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "CustomViewController.h"
#import "Receipt.h"

@interface RunningReceiptViewController : CustomViewController<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tbvData;
@property (strong, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (strong, nonatomic) IBOutlet UIButton *btnShowPrintButton;
@property (strong, nonatomic) Receipt *selectedReceipt;
//@property (nonatomic) BOOL showEndedTab;

- (IBAction)showPrintButton:(id)sender;
- (IBAction)refresh:(id)sender;
-(void)reloadTableView;
-(IBAction)unwindToRunningReceipt:(UIStoryboardSegue *)segue;

@end
