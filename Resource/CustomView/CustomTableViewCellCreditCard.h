//
//  CustomTableViewCellCreditCard.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 9/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellCreditCard : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextField *txtFirstName;
@property (strong, nonatomic) IBOutlet UITextField *txtLastName;
@property (strong, nonatomic) IBOutlet UITextField *txtCardNo;
@property (strong, nonatomic) IBOutlet UITextField *txtMonth;
@property (strong, nonatomic) IBOutlet UITextField *txtYear;

@property (strong, nonatomic) IBOutlet UITextField *txtCCV;
@property (strong, nonatomic) IBOutlet UIImageView *imgCreditCardBrand;
@property (strong, nonatomic) IBOutlet UISwitch *swtSave;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *txtFirstNameWidthConstant;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *txtMonthWidthConstant;
@property (strong, nonatomic) IBOutlet UILabel *lblErrorMsg;
@property (strong, nonatomic) IBOutlet UIView *vwFirstName;
@property (strong, nonatomic) IBOutlet UIView *vwLastName;
@property (strong, nonatomic) IBOutlet UIView *vwCardNo;
@property (strong, nonatomic) IBOutlet UIView *vwYear;
@property (strong, nonatomic) IBOutlet UIView *vwMonth;
@property (strong, nonatomic) IBOutlet UIView *vwCCV;
@end
