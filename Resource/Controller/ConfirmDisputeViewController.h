//
//  ConfirmDisputeViewController.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 10/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "Receipt.h"


@interface ConfirmDisputeViewController : CustomViewController

@property (strong, nonatomic) IBOutlet UILabel *lblDisputeMessage;
@property (strong, nonatomic) IBOutlet UIView *vwAlert;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *vwAlertHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblDisputeMessageHeight;
@property (strong, nonatomic) IBOutlet UIButton *btnConfirm;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;


@property (nonatomic) NSInteger fromType;
@property (strong, nonatomic) Receipt *receipt;



- (IBAction)yesDispute:(id)sender;
- (IBAction)noDispute:(id)sender;



@end
