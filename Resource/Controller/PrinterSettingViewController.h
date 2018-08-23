//
//  PrinterSettingViewController.h
//  DevJummumOM
//
//  Created by Thidaporn Kijkamjai on 24/8/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "CustomViewController.h"


@interface PrinterSettingViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (strong, nonatomic) IBOutlet UITableView *tbvData;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
- (IBAction)goBack:(id)sender;
- (IBAction)refresh:(id)sender;
-(IBAction)unwindToPrinterSetting:(UIStoryboardSegue *)segue;

@end
