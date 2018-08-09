//
//  PersonalDataViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 21/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "PersonalDataViewController.h"
#import "CustomTableViewCellLabelLabel.h"
#import "UserAccount.h"
#import "CredentialsDb.h"
#import "Setting.h"


@interface PersonalDataViewController ()
{
    
}
@end

@implementation PersonalDataViewController
static NSString * const reuseIdentifierLabelLabel = @"CustomTableViewCellLabelLabel";


@synthesize lblNavTitle;
@synthesize tbvData;
@synthesize topViewHeight;
@synthesize bottomViewHeight;


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    bottomViewHeight.constant = window.safeAreaInsets.bottom;
    
    float topPadding = window.safeAreaInsets.top;
    topViewHeight.constant = topPadding == 0?20:topPadding;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSString *title = [Setting getValue:@"089t" example:@"ข้อมูลส่วนตัว"];
    lblNavTitle.text = title;
    tbvData.dataSource = self;
    tbvData.delegate = self;
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelLabel bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelLabel];
    }
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToMe" sender:self];
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    CustomTableViewCellLabelLabel *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelLabel];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    switch (item)
    {
        case 0:
        {
            NSString *message = [Setting getValue:@"090m" example:@"ชื่อร้าน"];
            cell.lblText.text = message;
            cell.lblText.textColor = cSystem1;
            [cell.lblText sizeToFit];
            cell.lblTextWidthConstant.constant = cell.lblText.frame.size.width;
            cell.lblValue.text = [CredentialsDb getCurrentCredentialsDb].name;
            cell.lblValue.textColor = cSystem4;
        }
            break;
        case 1:
        {
            NSString *message = [Setting getValue:@"091m" example:@"อีเมล"];
            UserAccount *userAccount = [UserAccount getCurrentUserAccount];
            cell.lblText.text = message;
            cell.lblText.textColor = cSystem1;
            [cell.lblText sizeToFit];
            cell.lblTextWidthConstant.constant = cell.lblText.frame.size.width;
            cell.lblValue.text = userAccount.email;
            cell.lblValue.textColor = cSystem4;
        }
            break;
        case 2:
        {
            NSString *message = [Setting getValue:@"092m" example:@"ชื่อ"];
            UserAccount *userAccount = [UserAccount getCurrentUserAccount];
            cell.lblText.text = message;
            cell.lblText.textColor = cSystem1;
            [cell.lblText sizeToFit];
            cell.lblTextWidthConstant.constant = cell.lblText.frame.size.width;
            cell.lblValue.text = userAccount.fullName;
            cell.lblValue.textColor = cSystem4;
        }
            break;
        
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
    [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}
@end
