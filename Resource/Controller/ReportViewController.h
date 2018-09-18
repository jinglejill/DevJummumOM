//
//  ReportViewController.h
//  DevJummumOM
//
//  Created by Thidaporn Kijkamjai on 14/9/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "CustomViewController.h"
#import "NTMonthYearPicker.h"

@interface ReportViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (strong, nonatomic) IBOutlet UITableView *tbvData;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (strong, nonatomic) IBOutlet NTMonthYearPicker *ntMonthYearPicker;

- (IBAction)goBack:(id)sender;
-(IBAction)unwindToReport:(UIStoryboardSegue *)segue;
@end
