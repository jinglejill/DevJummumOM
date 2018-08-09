//
//  CustomTableViewCellReceiptSummary.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 11/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellReceiptSummary : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblReceiptNo;
@property (strong, nonatomic) IBOutlet UILabel *lblBranchName;
@property (strong, nonatomic) IBOutlet UILabel *lblReceiptDate;
@property (strong, nonatomic) IBOutlet UITableView *tbvOrderDetail;
@property (strong, nonatomic) IBOutlet UIButton *btnOrderItAgain;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end
