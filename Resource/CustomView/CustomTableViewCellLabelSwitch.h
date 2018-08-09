//
//  CustomTableViewCellLabelSwitch.h
//  JummumShop
//
//  Created by Thidaporn Kijkamjai on 14/7/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellLabelSwitch : UITableViewCell
@property (strong, nonatomic) IBOutlet UISwitch *swtValue;
@property (strong, nonatomic) IBOutlet UILabel *lblText;
@property (strong, nonatomic) IBOutlet UIImageView *imgVwValue;

@end
