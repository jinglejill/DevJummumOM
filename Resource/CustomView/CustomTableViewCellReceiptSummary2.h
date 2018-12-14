//
//  CustomTableViewCellReceiptSummary2.h
//  DevJummumOM
//
//  Created by Thidaporn Kijkamjai on 24/8/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellReceiptSummary2 : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblReceiptNo;
@property (strong, nonatomic) IBOutlet UILabel *lblBranchName;
@property (strong, nonatomic) IBOutlet UILabel *lblReceiptDate;
@property (strong, nonatomic) IBOutlet UITableView *tbvOrderDetail;
@property (strong, nonatomic) IBOutlet UILabel *lblPrinterName;
@end
