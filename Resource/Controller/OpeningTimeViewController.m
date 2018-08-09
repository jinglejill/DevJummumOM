//
//  OpeningTimeViewController.m
//  JummumShop
//
//  Created by Thidaporn Kijkamjai on 23/7/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "OpeningTimeViewController.h"
#import "CustomTableViewCellLabelRemark.h"
#import "Message.h"
#import "Setting.h"


@interface OpeningTimeViewController ()
{
    NSString *_strOpeningTime;
    NSInteger _customerOrderStatus;
    NSInteger _customerOrderStatusOld;
}
@end

@implementation OpeningTimeViewController
static NSString * const reuseIdentifierLabelRemark = @"CustomTableViewCellLabelRemark";


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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSString *title = [Setting getValue:@"095t" example:@"ตั้งค่าระบบการสั่งอาหารด้วยตนเอง"];
    lblNavTitle.text = title;
    tbvData.scrollEnabled = NO;
    tbvData.dataSource = self;
    tbvData.delegate = self;
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelRemark bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelRemark];
    }
    
    _customerOrderStatusOld = [[Setting getSettingValueWithKeyName:@"customerOrderStatus"] integerValue];
    _customerOrderStatus = [[Setting getSettingValueWithKeyName:@"customerOrderStatus"] integerValue];
    [self.homeModel downloadItems:dbOpeningTimeText];
}

- (IBAction)goBack:(id)sender
{
    if(_customerOrderStatusOld != _customerOrderStatus)
    {
        [self loadingOverlayView];
        Setting *settingOld = [Setting getSettingWithKeyName:@"customerOrderStatus"];
        Setting *setting = [settingOld copy];
        setting.value = [NSString stringWithFormat:@"%ld",_customerOrderStatus];
        setting.modifiedUser = [Utility modifiedUser];
        setting.modifiedDate = [Utility currentDateTime];
        self.homeModel = [[HomeModel alloc]init];
        self.homeModel.delegate = self;
        [self.homeModel updateItems:dbSetting withData:setting actionScreen:@"update setting CustomerOrderStatus"];
    }
    else
    {
        [self unwindToMe];
    }
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    switch (item)
    {
        case 0:
        {
            NSString *message = [Setting getValue:@"096m" example:@"เปิด"];
            cell.textLabel.text = message;
            cell.textLabel.textColor = cSystem4;
            cell.textLabel.font = [UIFont fontWithName:@"Prompt-Regular" size:15.0f];
            cell.accessoryType = _customerOrderStatus == 1?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
            
        }
            break;
        case 1:
        {
            NSString *message = [Setting getValue:@"097m" example:@"ปิด"];
            cell.textLabel.text = message;
            cell.textLabel.textColor = cSystem4;
            cell.textLabel.font = [UIFont fontWithName:@"Prompt-Regular" size:15.0f];
            cell.accessoryType = _customerOrderStatus == 2?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
        }
            break;
        case 2:
        {
            NSString *message = [Setting getValue:@"098m" example:@"ตามที่ตั้งค่าไว้"];
            cell.textLabel.text = message;
            cell.textLabel.textColor = cSystem4;
            cell.textLabel.font = [UIFont fontWithName:@"Prompt-Regular" size:15.0f];
            cell.accessoryType = _customerOrderStatus == 3?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
        }
            break;
        case 3:
        {
            CustomTableViewCellLabelRemark *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelRemark];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            cell.lblText.text = _strOpeningTime;
            [cell.lblText sizeToFit];
            cell.lblTextHeight.constant = cell.lblText.frame.size.height;
            cell.lblText.font = [UIFont fontWithName:@"Prompt-Regular" size:15.0f];
            cell.lblText.textColor = cSystem4;
            
            return cell;
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.item == 3)
    {
        CustomTableViewCellLabelRemark *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelRemark];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.lblText.text = _strOpeningTime;
        [cell.lblText sizeToFit];
        cell.lblTextHeight.constant = cell.lblText.frame.size.height;
        
        return 4+cell.lblTextHeight.constant+4;
    }
    return 44;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
    [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.item <= 2)
    {
        _customerOrderStatus = indexPath.item+1;
        [tbvData reloadData];
    }    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

-(void)itemsDownloaded:(NSArray *)items manager:(NSObject *)objHomeModel
{
    NSMutableArray *messageList = items[0];
    Message *message = messageList[0];
    _strOpeningTime = message.text;
    [tbvData reloadData];
}

-(void)itemsUpdatedWithManager:(NSObject *)objHomeModel items:(NSArray *)items
{
    [self removeOverlayViews];
    [Utility updateSharedObject:items];
    
    NSString *message = [Setting getValue:@"099m" example:@"ตั้งค่าสำเร็จ"];
    [self showAlert:@"" message:message method:@selector(unwindToMe)];
}

-(void)unwindToMe
{
    [self performSegueWithIdentifier:@"segUnwindToMe" sender:self];
}

-(void)reloadTableView
{
    _customerOrderStatusOld = [[Setting getSettingValueWithKeyName:@"customerOrderStatus"] integerValue];
    _customerOrderStatus = [[Setting getSettingValueWithKeyName:@"customerOrderStatus"] integerValue];
    [tbvData reloadData];
}
@end
