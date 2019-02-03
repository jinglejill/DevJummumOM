//
//  PrinterChoosingGPrinterViewController.h
//  DevJummumOM
//
//  Created by Thidaporn Kijkamjai on 2/1/2562 BE.
//  Copyright © 2562 Jummum Tech. All rights reserved.
//

#import "CustomViewController.h"
#import "Printer.h"

NS_ASSUME_NONNULL_BEGIN

@interface PrinterChoosingGPrinterViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (strong, nonatomic) IBOutlet UITableView *tbvData;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
//@property (weak, nonatomic) IBOutlet UIView *blindView;
//@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic) NSInteger selectedPrinterIndex;
@property (nonatomic) Printer *printer;


//@property (nonatomic) BOOL blind;
- (IBAction)goBack:(id)sender;
- (IBAction)connectPrinter:(id)sender;

@end

NS_ASSUME_NONNULL_END
