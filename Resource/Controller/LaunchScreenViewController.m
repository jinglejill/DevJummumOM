//
//  LaunchScreenViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 21/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "LaunchScreenViewController.h"
#import "LogInViewController.h"
#import "CredentialsDb.h"
#import "Credentials.h"
#import "Device.h"
#import "Message.h"
#import "Setting.h"
#import <sys/utsname.h>


@interface LaunchScreenViewController ()
{
    NSMutableArray *_credentialsDbList;
    CredentialsDb *_credentialsDb;
}
@end

@implementation LaunchScreenViewController
@synthesize progressBar;
@synthesize lblTitle;
@synthesize lblMessage;
@synthesize imgVwLogoTop;


//----------
- (void)presentAlertViewForPassword
{
    
    // 1
    BOOL hasPin = [[NSUserDefaults standardUserDefaults] boolForKey:PIN_SAVED];
    
    // 2
    if (hasPin)
    {
        //download branch
        self.homeModel = [[HomeModel alloc]init];
        self.homeModel.delegate = self;
        [self.homeModel downloadItems:dbCredentialsDb withData:[[NSUserDefaults standardUserDefaults] stringForKey:USERNAME]];
    }
    else
    {

        
        NSString *message = [Setting getValue:@"049m" example:@"Setup Credentials"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil];
        // 6
        NSString *message2 = [Setting getValue:@"050m" example:@"Name"];
        NSString *message3 = [Setting getValue:@"051m" example:@"Password"];
        alert.delegate = self;
        [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
        alert.tag = kAlertTypeSetup;

        UITextField *nameField = [alert textFieldAtIndex:0];
        nameField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        nameField.placeholder = message2; // Replace the standard placeholder text with something more applicable
        nameField.delegate = self;
        nameField.tag = kTextFieldName;
        UITextField *passwordField = [alert textFieldAtIndex:1]; // Capture the Password text field since there are 2 fields
        passwordField.placeholder = message3;
        passwordField.delegate = self;
        passwordField.tag = kTextFieldPassword;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == kAlertTypeSetup)
    {
        if (buttonIndex == 1)
        { // User selected "Done"
            [self credentialsValidated];
        }
        else
        { // User selected "Cancel"
            [self presentAlertViewForPassword];
        }
    }
}

#pragma mark - Text Field + Alert View Methods
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // 1
    switch (textField.tag) {
        case kTextFieldName: // 1st part of the Setup flow.
            NSLog(@"User entered name");
            if ([textField.text length] > 0)
            {
                [[NSUserDefaults standardUserDefaults] setValue:[textField.text uppercaseString] forKey:USERNAME];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            break;
        case kTextFieldPassword: // 2nd half of the Setup flow.
            NSLog(@"User entered PIN");
            if ([textField.text length] > 0)
            {
                [[NSUserDefaults standardUserDefaults] setValue:textField.text forKey:PASSWORD];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            break;
        default:
            break;
    }
}

// Helper method to congregate the Name and PIN fields for validation.
- (void)credentialsValidated
{
    [self loadingOverlayView];
    
    NSString *name = [[NSUserDefaults standardUserDefaults] stringForKey:USERNAME];
    NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:PASSWORD];
    
    Credentials *credentials = [[Credentials alloc]init];
    credentials.username = name;
    credentials.password = password;

    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    [self.homeModel insertItems:dbCredentials withData:credentials actionScreen:@"Validate credential"];
}

- (void)loadView
{
    [super loadView];

//    [self presentAlertViewForPassword];
}

- (void)applicationExpired
{
    NSString *title = [Setting getValue:@"052t" example:@"Warning"];
    NSString *message = [Setting getValue:@"052m" example:@"Application is expired"];
    [self showAlert:title message:message];
}

- (void)downloadProgress:(float)percent
{
    progressBar.progress = percent;
}

-(void)itemsInsertedWithManager:(NSObject *)objHomeModel items:(NSArray *)items
{
    HomeModel *homeModel = (HomeModel *)objHomeModel;
    if(homeModel.propCurrentDBInsert == dbCredentials)
    {
        [self removeOverlayViews];
        if([items count] == 0)
        {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:PIN_SAVED];
            [self presentAlertViewForPassword];
        }
        else
        {
            NSMutableArray *messageList = items[0];
            Message *message = messageList[0];
            [self showAlert:@"" message:message.text method:@selector(presentAlertViewForPassword)];            
        }
    }
    else if(homeModel.propCurrentDBInsert == dbDevice)
    {
        [self downloadData];
    }
}

- (void)downloadData
{
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    [self.homeModel downloadItems:dbMasterWithProgressBar];
}

- (void)itemsDownloaded:(NSArray *)items manager:(NSObject *)objHomeModel
{
    HomeModel *homeModel = (HomeModel *)objHomeModel;
    if(homeModel.propCurrentDB == dbCredentialsDb)
    {
        [self removeOverlayViews];
        _credentialsDbList = items[0];
        
        
        if([_credentialsDbList count]==1)
        {        
            _credentialsDb = _credentialsDbList[0];
            [CredentialsDb setCurrentCredentialsDb:_credentialsDb];
            [Utility setBranchID:_credentialsDb.branchID];
            [[NSUserDefaults standardUserDefaults] setValue:_credentialsDb.dbName forKey:BRANCH];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            
            //insert device for pushNotification to update data in the same branch, so delete deviceToken that stay in other db(เพราะได้ switch มาใช้ branch นี้แล้ว)
            Device *device = [[Device alloc]init];
            device.deviceToken = [Utility deviceToken];
            device.remark = [self deviceName];
            device.modifiedUser = [Utility deviceToken];
            device.modifiedDate = [Utility currentDateTime];
            
            self.homeModel = [[HomeModel alloc]init];
            self.homeModel.delegate = self;
            [self.homeModel insertItems:dbDevice withData:device actionScreen:@"Add device in branchSelect screen"];
            
        }
        else
        {
            [self performSegueWithIdentifier:@"segBranchSelect" sender:self];
        }
    }
    else if(homeModel.propCurrentDB == dbMasterWithProgressBar)
    {
        if([items count] == 0)
        {
            NSString *title = [Setting getValue:@"053t" example:@"Warning"];
            NSString *message = [Setting getValue:@"053m" example:@"Memory fail"];
            [self showAlert:title message:message];
            return;
        }
        

        
        
        [Utility itemsDownloaded:items];
        [self performSegueWithIdentifier:@"segLogIn" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
//    if([[segue identifier] isEqualToString:@"segBranchSelect"])
//    {
//        BranchSelectViewController *vc = segue.destinationViewController;
//        vc.credentialsDbList = _credentialsDbList;
//    }
//    else if([[segue identifier] isEqualToString:@"segLogIn"])
//    {
//        LogInViewController *vc = segue.destinationViewController;
//        vc.credentialsDb = _credentialsDb;
//    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    imgVwLogoTop.constant = (self.view.frame.size.height - (542-94))/2;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
  
//    progressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
//    progressBar.trackTintColor = [UIColor whiteColor];
//    progressBar.progressTintColor = cSystem2;
//    {
//        CGRect frame = progressBar.frame;
//        frame.origin.y = self.view.frame.size.height-20;
//        frame.size.width = self.view.frame.size.width - 40;
//        frame.origin.x = 20;
//        progressBar.frame = frame;
//    }
//
//    [self.view addSubview:progressBar];
    
    
    
    
    
    NSString *title = [Setting getValue:@"054t" example:@"Welcome"];
    NSString *message = [Setting getValue:@"054m" example:@"Pay for your order, earn and track rewards, ckeck your balance and more, all from your mobile device"];
    lblTitle.text = title;
    lblMessage.text = message;
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    [self performSegueWithIdentifier:@"segLogIn" sender:self];
}

-(NSString*) deviceName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    
    NSString *iOSDeviceModelsPath = [[NSBundle mainBundle] pathForResource:@"iOSDeviceModelMapping" ofType:@"plist"];
    NSDictionary *iOSDevices = [NSDictionary dictionaryWithContentsOfFile:iOSDeviceModelsPath];
    
    NSString* deviceModel = [NSString stringWithCString:systemInfo.machine
                                               encoding:NSUTF8StringEncoding];
    
    return [iOSDevices valueForKey:deviceModel];
}
//-------

- (void) connectionFail
{
    NSString *title = [Utility subjectNoConnection];
    NSString *message = [Utility detailNoConnection];
    [self showAlert:title message:message method:@selector(tryDownloadAgain)];
}

-(void)tryDownloadAgain
{
    progressBar.progress = 0;
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    [self.homeModel downloadItems:dbMasterWithProgressBar];
}
@end
