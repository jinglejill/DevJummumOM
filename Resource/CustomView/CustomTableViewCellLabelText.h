//
//  CustomTableViewCellLabelText.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 12/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellLabelText : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UITextField *txtValue;
@property (strong, nonatomic) IBOutlet UILabel *lblRemark;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblRemarkHeight;

@end
