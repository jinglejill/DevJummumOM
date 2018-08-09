//
//  CustomTableViewCellTotal.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 25/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellTotal : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblAmount;
@property (strong, nonatomic) IBOutlet UIView *vwTopBorder;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblTitleTop;

@end
