//
//  PrinterChoosingViewController.h
//  DevJummumOM
//
//  Created by Thidaporn Kijkamjai on 24/8/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "CustomViewController.h"
#import "Printer.h"

@interface PrinterChoosingViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (strong, nonatomic) IBOutlet UITableView *tbvData;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (weak, nonatomic) IBOutlet UIView *blindView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic) NSInteger selectedPrinterIndex;
@property (nonatomic) Printer *printer;


@property (nonatomic) BOOL blind;
- (IBAction)goBack:(id)sender;
- (IBAction)refresh:(id)sender;

@end
