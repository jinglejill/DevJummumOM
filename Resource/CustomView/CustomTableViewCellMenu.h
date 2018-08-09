//
//  CustomTableViewCellMenu.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 19/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellMenu : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgMenuPic;
@property (strong, nonatomic) IBOutlet UILabel *lblMenuName;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imgMenuPicWidthConstant;
@property (strong, nonatomic) IBOutlet UILabel *lblQuantity;
@property (strong, nonatomic) IBOutlet UIImageView *imgTriangle;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblPriceWidthConstant;

@property (strong, nonatomic) IBOutlet UILabel *lblSpecialPrice;

@end
