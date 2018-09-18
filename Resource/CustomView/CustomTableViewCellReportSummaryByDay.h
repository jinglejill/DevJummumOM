//
//  CustomTableViewCellReportSummaryByDay.h
//  DevJummumOM
//
//  Created by Thidaporn Kijkamjai on 17/9/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellReportSummaryByDay : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblValue;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblTitleLeading;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblTitleWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblTitleHeight;

@end
