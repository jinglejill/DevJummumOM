//
//  CustomTableViewCellRedemption.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 1/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellRedemption : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblHeader;
@property (strong, nonatomic) IBOutlet UILabel *lblSubTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblRemark;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblHeaderHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblSubTitleHeight;
@property (strong, nonatomic) IBOutlet UILabel *lblRedeemDate;
@property (strong, nonatomic) IBOutlet UIImageView *imgQrCode;
@property (strong, nonatomic) IBOutlet UILabel *lblPromoCode;
@end
