//
//  CustomTableViewCellLabel.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 30/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellLabel : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTextLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblTextLabelHeight;
@property (strong, nonatomic) IBOutlet UIButton *btnValue;

@end
