//
//  LogInViewController.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 17/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomViewController.h"
#import "CredentialsDb.h"


@interface LogInViewController : CustomViewController

@property (strong, nonatomic) IBOutlet UIImageView *imgVwLogoText;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnRememberMe;
@property (strong, nonatomic) IBOutlet UIButton *btnLogIn;
@property (strong, nonatomic) IBOutlet UIButton *btnRegisterNow;
@property (strong, nonatomic) IBOutlet UIButton *btnForgotPassword;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imgVwValueHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblLogInTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblOrBottom;

- (IBAction)rememberMe:(id)sender;
- (IBAction)logIn:(id)sender;
- (IBAction)registerNow:(id)sender;
- (IBAction)forgotPassword:(id)sender;

-(IBAction)unwindToLogIn:(UIStoryboardSegue *)segue;
@end
