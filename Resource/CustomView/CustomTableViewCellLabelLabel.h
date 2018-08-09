//
//  CustomTableViewCellLabelLabel.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 21/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellLabelLabel : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblText;
@property (strong, nonatomic) IBOutlet UILabel *lblValue;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblTextWidthConstant;

@end
