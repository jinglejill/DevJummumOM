//
//  RegisterNowViewController.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 2/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"

@interface RegisterNowViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tbvData;
@property (strong, nonatomic) IBOutlet UIDatePicker *dtPicker;
- (IBAction)datePickerChanged:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnCreateAccount;
- (IBAction)createAccount:(id)sender;
- (IBAction)goBack:(id)sender;

@end
