//
//  CustomTableViewCellReportDailyHeader.h
//  DevJummumOM
//
//  Created by Thidaporn Kijkamjai on 17/9/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellReportDailyHeader : UITableViewHeaderFooterView

@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblBalance;
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblStatusWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblStatusLeading;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblDateWidth;
@end
