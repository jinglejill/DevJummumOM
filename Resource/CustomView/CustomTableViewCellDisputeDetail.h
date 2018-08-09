//
//  CustomTableViewCellDisputeDetail.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 17/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellDisputeDetail : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblRemark;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblRemarkHeight;
@property (strong, nonatomic) IBOutlet UILabel *lblReason;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblReasonHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblReasonTop;
@property (strong, nonatomic) IBOutlet UILabel *lblAmount;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblAmountTop;
@property (strong, nonatomic) IBOutlet UILabel *lblReasonDetail;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblReasonDetailHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblReasonDetailTop;
@property (strong, nonatomic) IBOutlet UILabel *lblPhoneNo;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblPhoneNoHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblPhoneNoTop;
@end
