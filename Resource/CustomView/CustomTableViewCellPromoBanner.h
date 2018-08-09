//
//  CustomTableViewCellPromoBanner.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 23/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellPromoBanner : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblHeader;
@property (strong, nonatomic) IBOutlet UILabel *lblSubTitle;
@property (strong, nonatomic) IBOutlet UIImageView *imgVwValue;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblHeaderHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblSubTitleHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imgVwValueHeight;
@end
