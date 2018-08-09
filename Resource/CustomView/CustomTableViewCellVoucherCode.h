//
//  CustomTableViewCellVoucherCode.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 18/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CustomViewVoucher.h"


@interface CustomTableViewCellVoucherCode : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextField *txtVoucherCode;
@property (strong, nonatomic) IBOutlet UIButton *btnConfirmVoucherCode;
//@property (strong, nonatomic) IBOutlet UILabel *lblAlertVoucher;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnConfirmVoucherCodeWidthConstant;
//@property (strong, nonatomic) IBOutlet CustomViewVoucher *voucherView;
//- (IBAction)confirmVoucherCode:(id)sender;
@end
