//
//  PrinterBrandViewController.h
//  DevJummumOM
//
//  Created by Thidaporn Kijkamjai on 28/12/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "CustomViewController.h"
#import "Printer.h"
NS_ASSUME_NONNULL_BEGIN

@interface PrinterBrandViewController : CustomViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *lblNavTitle;
@property (strong, nonatomic) IBOutlet UITableView *tbvData;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (nonatomic) NSInteger selectedPrinterIndex;
@property (nonatomic) Printer *printer;
- (IBAction)goBack:(id)sender;
-(IBAction)unwindToPrinterBrand:(UIStoryboardSegue *)segue;


@end

NS_ASSUME_NONNULL_END
