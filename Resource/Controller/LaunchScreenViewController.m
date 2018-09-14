//
//  LaunchScreenViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 21/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "LaunchScreenViewController.h"
#import "LogInViewController.h"
#import "NewVersionUpdateViewController.h"
#import "CredentialsDb.h"
#import "Credentials.h"
#import "Device.h"
#import "Message.h"
#import "Setting.h"
#import <sys/utsname.h>


@interface LaunchScreenViewController ()
{
    BOOL _redirectToLogin;
    NSString *_appStoreVersion;
}
@end

@implementation LaunchScreenViewController
@synthesize lblTitle;
@synthesize lblMessage;
@synthesize imgVwLogoTop;


-(IBAction)unwindToLaunchScreen:(UIStoryboardSegue *)segue
{    
    if([segue.sourceViewController isKindOfClass:[NewVersionUpdateViewController class]])
    {
        NSString *strKey = [NSString stringWithFormat:@"UpdateVersion%@",_appStoreVersion];
        NSString *strUpdateVersion = [Setting getSettingValueWithKeyName:strKey];
        if(!strUpdateVersion || ![strUpdateVersion integerValue])
        {
            _redirectToLogin = YES;
        }
    }
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
    
    
    NSString *title = [Setting getValue:@"054t" example:@"Welcome"];
    NSString *message = [Setting getValue:@"054m" example:@"Pay for your order, earn and track rewards, ckeck your balance and more, all from your mobile device"];
    lblTitle.text = title;
    lblMessage.text = message;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    if(_redirectToLogin)
    {
        _redirectToLogin = 0;        
        [self performSegueWithIdentifier:@"segLogIn" sender:self];
    }
    else
    {
        if([self needsUpdate])
        {
            NSString *key = [NSString stringWithFormat:@"dismiss verion:%@",_appStoreVersion];
            NSNumber *dismissVersion = [[NSUserDefaults standardUserDefaults] valueForKey:key];
            if([dismissVersion integerValue])
            {
                [self performSegueWithIdentifier:@"segLogIn" sender:self];
            }
            else
            {
                NSString *strKey = [NSString stringWithFormat:@"UpdateVersion%@",_appStoreVersion];
                Setting *setting = [[Setting alloc]initWithKeyName:strKey value:@"" type:0 remark:@""];
                self.homeModel = [[HomeModel alloc]init];
                self.homeModel.delegate = self;
                [self.homeModel downloadItems:dbSettingWithKey withData:setting];
            }
        }
        else
        {
            [self performSegueWithIdentifier:@"segLogIn" sender:self];
        }
    }
}

- (void)itemsDownloaded:(NSArray *)items
{
    [Utility updateSharedObject:items];
    [self performSegueWithIdentifier:@"segNewVersionUpdate" sender:self];
}

-(BOOL) needsUpdate
{
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString* appID = infoDictionary[@"CFBundleIdentifier"];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@", appID]];
    NSData* data = [NSData dataWithContentsOfURL:url];
    NSDictionary* lookup = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if ([lookup[@"resultCount"] integerValue] == 1)
    {
        NSString* appStoreVersion = lookup[@"results"][0][@"version"];
        NSString* currentVersion = infoDictionary[@"CFBundleShortVersionString"];
        _appStoreVersion = appStoreVersion;
        if (![appStoreVersion isEqualToString:currentVersion]){
            NSLog(@"Need to update [%@ != %@]", appStoreVersion, currentVersion);
            return YES;
        }
    }
    else
    {
        NSString *strAppVersion = @"appVersion no resultCount";
        [[NSUserDefaults standardUserDefaults] setValue:strAppVersion forKey:@"appVersion"];
    }
    return NO;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"segNewVersionUpdate"])
    {
        NewVersionUpdateViewController *vc = segue.destinationViewController;
        vc.appStoreVersion = _appStoreVersion;
    }
}

- (void)connectionFail
{
    [self removeOverlayViews];
    NSString *title = [Utility subjectNoConnection];
    NSString *message = [Utility detailNoConnection];
    [self showAlert:title message:message method:@selector(refresh)];
}

-(void)refresh
{
    [self viewDidAppear:NO];
}
@end
