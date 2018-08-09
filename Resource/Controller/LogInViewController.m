//
//  LogInViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 17/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "LogInViewController.h"
#import "TermsOfServiceViewController.h"
#import "CustomerKitchenViewController.h"
#import "MainTabBarController.h"
#import "MeViewController.h"


#import "LogIn.h"
#import "UserAccount.h"
#import "Setting.h"
#import "Utility.h"
#import "FacebookComment.h"


@interface LogInViewController ()
{
    BOOL _faceBookLogIn;
    BOOL _appLogIn;
    BOOL _rememberMe;
    NSString *_username;
    NSMutableArray *allComments;
    CredentialsDb *_credentialsDb;
}
@end

@implementation LogInViewController
@synthesize txtEmail;
@synthesize txtPassword;
@synthesize btnRememberMe;
@synthesize btnLogIn;
//@synthesize credentialsDb;
@synthesize imgVwValueHeight;
@synthesize lblOrBottom;
@synthesize imgVwLogoText;
@synthesize lblLogInTop;


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    imgVwValueHeight.constant = self.view.frame.size.width/375*255;
    float bottom = imgVwValueHeight.constant+20+30+11;
    lblOrBottom.constant = bottom;
    
    
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    float bottomPadding = window.safeAreaInsets.bottom;    
    
    
    
    lblLogInTop.constant = 7 + bottomPadding;
    if(bottom+286+40>self.view.frame.size.height)
    {
        //hide jummum text
        imgVwLogoText.hidden = YES;
    }
}

- (IBAction)rememberMe:(id)sender
{
    _rememberMe = !_rememberMe;
    if(_rememberMe)
    {
        NSString *message = [Setting getValue:@"056m" example:@"◼︎ จำฉันไว้ในระบบ"];
        [btnRememberMe setTitle:message forState:UIControlStateNormal];
    }
    else
    {
        NSString *message = [Setting getValue:@"055m" example:@"◻︎ จำฉันไว้ในระบบ"];
        [btnRememberMe setTitle:message forState:UIControlStateNormal];
    }
}

- (IBAction)logIn:(id)sender
{

    txtEmail.text = [Utility trimString:txtEmail.text];
    txtPassword.text = [Utility trimString:txtPassword.text];
    [Utility setModifiedUser:txtEmail.text];
    
    
    UserAccount *userAccount = [[UserAccount alloc]init];
    userAccount.username = txtEmail.text;
    userAccount.password = [Utility hashTextSHA256:txtPassword.text];
    
    
    LogIn *logIn = [[LogIn alloc]initWithUsername:userAccount.username status:1 deviceToken:[Utility deviceToken]];
    [self.homeModel insertItems:dbUserAccountValidate withData:@[userAccount,logIn] actionScreen:@"validate userAccount"];
    [self loadingOverlayView];
    
}

- (IBAction)registerNow:(id)sender
{
    [self performSegueWithIdentifier:@"segRegisterNow" sender:self];
}

- (IBAction)forgotPassword:(id)sender
{
    [self performSegueWithIdentifier:@"segForgotPassword" sender:self];
}

-(IBAction)unwindToLogIn:(UIStoryboardSegue *)segue
{
    if([segue.sourceViewController isMemberOfClass:[MeViewController class]])
    {
        NSString *message = [Setting getValue:@"055m" example:@"◻︎ จำฉันไว้ในระบบ"];
        [btnRememberMe setTitle:message forState:UIControlStateNormal];
        _rememberMe = NO;
        
        
        txtEmail.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"rememberEmail"];
        txtPassword.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"rememberPassword"];
    }
    
    
    if(![[NSUserDefaults standardUserDefaults] integerForKey:@"logInSession"])
    {
        _appLogIn = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    [self setButtonDesign:btnLogIn];
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"rememberMe"])
    {
        NSString *message = [Setting getValue:@"056m" example:@"◼︎ จำฉันไว้ในระบบ"];
        [btnRememberMe setTitle:message forState:UIControlStateNormal];
        _rememberMe = YES;
        
        
        txtEmail.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"rememberEmail"];
        txtPassword.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"rememberPassword"];
        
    }
    else
    {
        NSString *message = [Setting getValue:@"055m" example:@"◻︎ จำฉันไว้ในระบบ"];
        [btnRememberMe setTitle:message forState:UIControlStateNormal];
        _rememberMe = NO;
    }
    
    
    
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture setCancelsTouchesInView:NO];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_faceBookLogIn)
    {
        [self insertUserLoginAndUserAccount];
    }
    else if(_appLogIn)
    {
        [self logIn:btnLogIn];
    }
}

//facebook
-(void)insertUserLoginAndUserAccount
{
    NSLog(@"insert user log in");
}

//app logIn
-(void)itemsInsertedWithReturnData:(NSArray *)items;
{
    [self removeOverlayViews];
    if(self.homeModel.propCurrentDBInsert == dbUserAccountValidate)
    {
        if([items count] > 0 && [items[0] count] == 0)
        {
            NSString *message = [Setting getValue:@"058m" example:@"อีเมล/พาสเวิร์ด ไม่ถูกต้อง"];
            [self showAlert:@"" message:message];
        }
        else
        {
            [Utility updateSharedObject:items];
            
            
            NSMutableArray *userAccountList = items[0];
            [UserAccount setCurrentUserAccount:userAccountList[0]];
            
            
            NSMutableArray *credentialsDbList = items[[items count]-1];
            _credentialsDb = credentialsDbList[0];
            [CredentialsDb setCurrentCredentialsDb:_credentialsDb];
            [Utility setBranchID:_credentialsDb.branchID];
            [[NSUserDefaults standardUserDefaults] setValue:_credentialsDb.dbName forKey:BRANCH];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //-----------**********
            
            
            
            
            
            
            
            //credential
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"logInSession"];
            [[NSUserDefaults standardUserDefaults] setInteger:_rememberMe forKey:@"rememberMe"];
            if(_rememberMe)
            {
                [[NSUserDefaults standardUserDefaults] setValue:txtEmail.text forKey:@"rememberEmail"];
                [[NSUserDefaults standardUserDefaults] setValue:txtPassword.text forKey:@"rememberPassword"];
            }
            
            
            
            //show terms of service
            NSDictionary *dicTosAgree = [[NSUserDefaults standardUserDefaults] valueForKey:@"tosAgree"];
            if(dicTosAgree)
            {
                NSString *username;
                {
                    username = txtEmail.text;
                    NSNumber *tosAgree = [dicTosAgree objectForKey:username];
                    if(!tosAgree)
                    {
                        [self performSegueWithIdentifier:@"segTermsOfService" sender:self];
                    }
                    else
                    {                        
                        [self performSegueWithIdentifier:@"segCustomerKitchen" sender:self];
                    }
                }
            }
            else
            {
                [self performSegueWithIdentifier:@"segTermsOfService" sender:self];
            }
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segTermsOfService"])
    {
        TermsOfServiceViewController *vc = segue.destinationViewController;
        vc.credentialsDb = _credentialsDb;
        vc.username = txtEmail.text;
    }
    else if([segue.identifier isEqualToString:@"segCustomerKitchen"])
    {
        MainTabBarController *vc = segue.destinationViewController;
        vc.credentialsDb = _credentialsDb;
    }
}


@end

