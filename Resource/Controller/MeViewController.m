//
//  MeViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 11/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "MeViewController.h"
#import "TosAndPrivacyPolicyViewController.h"
#import "CustomTableViewCellImageText.h"
#import "CustomTableViewCellProfile.h"
#import "CustomTableViewCellLabelSwitch.h"
#import "Branch.h"
#import "Setting.h"


@interface MeViewController ()
{
    NSArray *_aboutUsList;
    NSArray *_aboutUsImageList;
    NSInteger _pageType;
    Branch *_branch;
}
@end

@implementation MeViewController
static NSString * const reuseIdentifierImageText = @"CustomTableViewCellImageText";
static NSString * const reuseIdentifierProfile = @"CustomTableViewCellProfile";
static NSString * const reuseIdentifierLabelSwitch = @"CustomTableViewCellLabelSwitch";


@synthesize tbvMe;
@synthesize topViewHeight;
@synthesize tbvMeTop;


-(IBAction)unwindToMe:(UIStoryboardSegue *)segue
{

}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    
    float topPadding = window.safeAreaInsets.top;
    topViewHeight.constant = topPadding == 0?20:topPadding;
}

-(void)loadView
{
    [super loadView];

    NSString *message = [Setting getValue:@"059m" example:@"ข้อกำหนดและเงื่อนไข"];
    NSString *message2 = [Setting getValue:@"060m" example:@"ตั้งค่าระบบการสั่งอาหารด้วยตนเอง"];
    NSString *message5 = [Setting getValue:@"104t" example:@"ตั้งค่าเครื่องพิมพ์"];
    NSString *message3 = [Setting getValue:@"101m" example:@"ติดต่อ JUMMUM"];
    NSString *message4 = [Setting getValue:@"061m" example:@"Log out"];
    _aboutUsList = @[message,message2,message5,message3,message4];
    _aboutUsImageList = @[@"termsOfService.png",@"selfService.png",@"printer.png",@"contactUs.png",@"logOut.png"];
    tbvMe.delegate = self;
    tbvMe.dataSource = self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierImageText bundle:nil];
        [tbvMe registerNib:nib forCellReuseIdentifier:reuseIdentifierImageText];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierProfile bundle:nil];
        [tbvMe registerNib:nib forCellReuseIdentifier:reuseIdentifierProfile];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelSwitch bundle:nil];
        [tbvMe registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelSwitch];
    }
    
    
    
    //------
    CustomTableViewCellProfile *cell = [tbvMe dequeueReusableCellWithIdentifier:reuseIdentifierProfile];
    
    
    cell.imgValue.layer.cornerRadius = 35;
    cell.imgValue.layer.masksToBounds = YES;
    cell.imgValue.layer.borderWidth = 0;
    UserAccount *userAccount = [UserAccount getCurrentUserAccount];
    cell.lblEmail.text = userAccount.email;
    
    
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    float topPadding = window.safeAreaInsets.top;
    CGRect frame = cell.frame;
    frame.origin.x = 0;
    frame.origin.y = topPadding == 0?20:topPadding;
    frame.size.width = self.view.frame.size.width;
    frame.size.height = 90;
    cell.frame = frame;
    [self.view addSubview:cell];
    
    
    
    [cell.singleTapGestureRecognizer addTarget:self action:@selector(handleSingleTap:)];
    [cell.vwContent addGestureRecognizer:cell.singleTapGestureRecognizer];
    cell.singleTapGestureRecognizer.numberOfTapsRequired = 1;
    
    
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if([tableView isEqual:tbvMe])
    {
        return [_aboutUsList count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    if([tableView isEqual:tbvMe])
    {
        CustomTableViewCellImageText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierImageText];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.imgVwIcon.image = [UIImage imageNamed:_aboutUsImageList[item]];
        cell.lblText.text = _aboutUsList[item];
        cell.lblText.textColor = cSystem4;
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:tbvMe])
    {
        return 44;
    }
    
    return 0;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
    [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([tableView isEqual:tbvMe])
    {
        switch (indexPath.item)
        {
            case 0:
            {
                _pageType = 1;
                [self performSegueWithIdentifier:@"segTosAndPrivacyPolicy" sender:self];
            }
                break;
            case 1:
            {
                [self performSegueWithIdentifier:@"segOpeningTime" sender:self];
            }
                break;
            case 2:
            {
                [self performSegueWithIdentifier:@"segPrinterSetting" sender:self];
            }
            break;
            case 3:
            {
                _pageType = 2;
                [self performSegueWithIdentifier:@"segTosAndPrivacyPolicy" sender:self];
            }
                break;
            case 4:
            {
                [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"logInSession"];
                [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"rememberMe"];
                [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"rememberEmail"];
                [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"rememberPassword"];
                
                
                NSString *message = [Setting getValue:@"062m" example:@"ออกจากระบบสำเร็จ"];
                [self showAlert:@"" message:message method:@selector(unwindToLogIn)];
            }
                break;
            default:
                break;
        }
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 8;//CGFLOAT_MIN;
    }
    return tableView.sectionHeaderHeight;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segTosAndPrivacyPolicy"])
    {
        TosAndPrivacyPolicyViewController *vc = segue.destinationViewController;
        vc.pageType = _pageType;
    }
}

-(void)unwindToLogIn
{
    [self performSegueWithIdentifier:@"segUnwindToLogIn" sender:self];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    [self performSegueWithIdentifier:@"segPersonalData" sender:self];
}
@end
