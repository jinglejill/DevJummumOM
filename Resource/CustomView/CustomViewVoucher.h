//
//  CustomViewVoucher.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 19/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomViewVoucher : UIView

@property (strong, nonatomic) IBOutlet UILabel *lblVoucherCode;
@property (strong, nonatomic) IBOutlet UIButton *btnDelete;
@property (strong, nonatomic) IBOutlet UILabel *lblDiscountAmount;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblVoucherCodeWidthConstant;
@end
