//
//  CustomTableViewCellReportDaily.h
//  DevJummumOM
//
//  Created by Thidaporn Kijkamjai on 17/9/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellReportDaily : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblReceiptDate;
@property (strong, nonatomic) IBOutlet UILabel *lblBalance;
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;
@property (strong, nonatomic) IBOutlet UITableView *tbvSummaryByDay;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblReceiptDateWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblStatusWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblStatusLeading;

@end
