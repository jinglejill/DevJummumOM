//
//  PrinterChoosingEpsonViewController.h
//  DevJummumOM
//
//  Created by Thidaporn Kijkamjai on 28/12/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "CustomViewController.h"
#import "Printer.h"
#import "ePOS2.h"


NS_ASSUME_NONNULL_BEGIN

@interface PrinterChoosingEpsonViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource,Epos2DiscoveryDelegate>
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

NS_ASSUME_NONNULL_END
