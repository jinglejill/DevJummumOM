//
//  LaunchScreenViewController.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 21/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "HomeModel.h"


@interface LaunchScreenViewController : CustomViewController<HomeModelProtocol,UITextFieldDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) UIProgressView *progressBar;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblMessage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imgVwLogoTop;
@end
