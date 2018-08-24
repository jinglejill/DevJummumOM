//
//  PrinterSettingViewController.m
//  DevJummumOM
//
//  Created by Thidaporn Kijkamjai on 24/8/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "PrinterSettingViewController.h"
#import "Setting.h"
#import "AppDelegate.h"
#import "PrinterSetting.h"
#import <StarIO/SMPort.h>


@interface PrinterSettingViewController ()
@property (nonatomic) NSMutableArray *statusCellArray;

@property (nonatomic) NSMutableArray *firmwareInfoCellArray;

@end

@implementation PrinterSettingViewController
@synthesize lblNavTitle;
@synthesize tbvData;
@synthesize topViewHeight;


-(IBAction)unwindToPrinterSetting:(UIStoryboardSegue *)segue
{
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    
    
    float topPadding = window.safeAreaInsets.top;
    topViewHeight.constant = topPadding == 0?20:topPadding;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSString *title = [Setting getValue:@"0104t" example:@"ตั้งค่าเครื่องพิมพ์"];
    lblNavTitle.text = title;
    tbvData.scrollEnabled = NO;
    tbvData.dataSource = self;
    tbvData.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    _statusCellArray = [[NSMutableArray alloc] init];
    
    _firmwareInfoCellArray = [[NSMutableArray alloc] init];
    
    [self refreshDeviceStatus];
    
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToMe" sender:self];
}

- (IBAction)refresh:(id)sender
{
    [self refreshDeviceStatus];
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    
    
    
    switch (item)
    {
        case 0:
        {
            UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            
            AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            PrinterSetting *printerSetting = appDelegate.settingManager.settings[0];
            NSString *strPortNameAndMacAddress = [NSString stringWithFormat:@"%@ (%@)",
                                                  printerSetting.portName,
                                                  printerSetting.macAddress];
            
            
            if(printerSetting.modelName)
            {
                cell.textLabel.text = printerSetting.modelName;
                cell.textLabel.textColor = cSystem4;
                cell.textLabel.font = [UIFont fontWithName:@"Prompt-Regular" size:15.0f];
                cell.detailTextLabel.text = strPortNameAndMacAddress;
                cell.detailTextLabel.textColor = cSystem4;
                cell.detailTextLabel.font = [UIFont fontWithName:@"Prompt-Regular" size:13.0f];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            else
            {
                cell.textLabel.text = @"เลือกเครื่องพิมพ์";
                cell.textLabel.textColor = cPlaceHolder;
                cell.textLabel.font = [UIFont fontWithName:@"Prompt-Regular" size:15.0f];
                cell.detailTextLabel.text = @"";
                cell.detailTextLabel.textColor = cSystem4;
                cell.detailTextLabel.font = [UIFont fontWithName:@"Prompt-Regular" size:13.0f];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            return cell;
        }
        break;
        case 1:
        {
            UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            if(_statusCellArray && [_statusCellArray count]>0)
            {
                cell.textLabel.text = @"สถานะ";
                cell.textLabel.textColor = cSystem4;
                cell.textLabel.font = [UIFont fontWithName:@"Prompt-Regular" size:15.0f];
                cell.detailTextLabel.text = _statusCellArray[0][1];
                cell.detailTextLabel.textColor = cSystem4_50;
                cell.detailTextLabel.font = [UIFont fontWithName:@"Prompt-Regular" size:15.0f];
            }
            else
            {
                cell.textLabel.text = @"สถานะ";
                cell.textLabel.textColor = cSystem4;
                cell.textLabel.font = [UIFont fontWithName:@"Prompt-Regular" size:15.0f];
                cell.detailTextLabel.text = @"Offline";
                cell.detailTextLabel.textColor = cSystem4_50;
                cell.detailTextLabel.font = [UIFont fontWithName:@"Prompt-Regular" size:15.0f];
            }
            
            return cell;
        }
        break;
        default:
        break;
    }
    
    return nil;
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
    if(indexPath.item == 0)
    {
        dispatch_async(dispatch_get_main_queue(),^ {
            [self performSegueWithIdentifier:@"segPrinterChoosing" sender:self];            
        } );
    }
}

- (void)refreshDeviceStatus {
    BOOL result = NO;
    
    [self loadingOverlayView];
    
    [_statusCellArray       removeAllObjects];
    [_firmwareInfoCellArray removeAllObjects];
    
    SMPort *port = nil;
    
    @try {
        while (YES) {
            NSString *portName = [AppDelegate getPortName];
            port = [SMPort getPort:portName :[AppDelegate getPortSettings] :10000];     // 10000mS!!!
            
            if (port == nil) {
                break;
            }
            
            // Sleep to avoid a problem which sometimes cannot communicate with Bluetooth.
            // (Refer Readme for details)
            NSOperatingSystemVersion version = {11, 0, 0};
            BOOL isOSVer11OrLater = [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:version];
            if ((isOSVer11OrLater) && ([portName.uppercaseString hasPrefix:@"BT:"])) {
                [NSThread sleepForTimeInterval:0.2];
            }
            
            StarPrinterStatus_2 printerStatus;
            
            [port getParsedStatus:&printerStatus :2];
            
            if (printerStatus.offline == SM_TRUE) {
                [_statusCellArray addObject:@[@"Online", @"Offline", [UIColor redColor]]];
            }
            else {
                [_statusCellArray addObject:@[@"Online", @"Online",  [UIColor blueColor]]];
            }
            
            if (printerStatus.coverOpen == SM_TRUE) {
                [_statusCellArray addObject:@[@"Cover", @"Open",   [UIColor redColor]]];
            }
            else {
                [_statusCellArray addObject:@[@"Cover", @"Closed", [UIColor blueColor]]];
            }
            
            if (printerStatus.receiptPaperEmpty == SM_TRUE) {
                [_statusCellArray addObject:@[@"Paper", @"Empty", [UIColor redColor]]];
            }
            else if (printerStatus.receiptPaperNearEmptyInner == SM_TRUE ||
                     printerStatus.receiptPaperNearEmptyOuter == SM_TRUE) {
                [_statusCellArray addObject:@[@"Paper", @"Near Empty", [UIColor orangeColor]]];
            }
            else {
                [_statusCellArray addObject:@[@"Paper", @"Ready",      [UIColor blueColor]]];
            }
            
            if ([AppDelegate getCashDrawerOpenActiveHigh] == YES) {
                if (printerStatus.compulsionSwitch == SM_TRUE) {
                    [_statusCellArray addObject:@[@"Cash Drawer", @"Open",   [UIColor redColor]]];
                }
                else {
                    [_statusCellArray addObject:@[@"Cash Drawer", @"Closed", [UIColor blueColor]]];
                }
            }
            else {
                if (printerStatus.compulsionSwitch == SM_TRUE) {
                    [_statusCellArray addObject:@[@"Cash Drawer", @"Closed", [UIColor blueColor]]];
                }
                else {
                    [_statusCellArray addObject:@[@"Cash Drawer", @"Open",   [UIColor redColor]]];
                }
            }
            
            if (printerStatus.overTemp == SM_TRUE) {
                [_statusCellArray addObject:@[@"Head Temperature", @"High",   [UIColor redColor]]];
            }
            else {
                [_statusCellArray addObject:@[@"Head Temperature", @"Normal", [UIColor blueColor]]];
            }
            
            if (printerStatus.unrecoverableError == SM_TRUE) {
                [_statusCellArray addObject:@[@"Non Recoverable Error", @"Occurs", [UIColor redColor]]];
            }
            else {
                [_statusCellArray addObject:@[@"Non Recoverable Error", @"Ready",  [UIColor blueColor]]];
            }
            
            if (printerStatus.cutterError == SM_TRUE) {
                [_statusCellArray addObject:@[@"Paper Cutter", @"Error", [UIColor redColor]]];
            }
            else {
                [_statusCellArray addObject:@[@"Paper Cutter", @"Ready", [UIColor blueColor]]];
            }
            
            if (printerStatus.headThermistorError == SM_TRUE) {
                [_statusCellArray addObject:@[@"Head Thermistor", @"Error",  [UIColor redColor]]];
            }
            else {
                [_statusCellArray addObject:@[@"Head Thermistor", @"Normal", [UIColor blueColor]]];
            }
            
            if (printerStatus.voltageError == SM_TRUE) {
                [_statusCellArray addObject:@[@"Voltage", @"Error",  [UIColor redColor]]];
            }
            else {
                [_statusCellArray addObject:@[@"Voltage", @"Normal", [UIColor blueColor]]];
            }
            
            if (printerStatus.etbAvailable == SM_TRUE) {
                [_statusCellArray addObject:@[@"ETB Counter", [NSString stringWithFormat:@"%d", printerStatus.etbCounter], [UIColor blueColor]]];
            }
            
            if (printerStatus.offline == SM_TRUE) {
                [_firmwareInfoCellArray addObject:@[@"Unable to get F/W info. from an error.", @"", [UIColor redColor]]];
                
                result = YES;
                break;
            }
            else {
                NSDictionary *firmwareInformation = [port getFirmwareInformation];
                
                if (firmwareInformation == nil) {
                    break;
                }
                
                [_firmwareInfoCellArray addObject:@[@"Model Name",       [firmwareInformation objectForKey:@"ModelName"],       [UIColor blueColor]]];
                
                [_firmwareInfoCellArray addObject:@[@"Firmware Version", [firmwareInformation objectForKey:@"FirmwareVersion"], [UIColor blueColor]]];
                
                result = YES;
                break;
            }
        }
    }
    @catch (PortException *exc) {
    }
    @finally {
        if (port != nil) {
            [SMPort releasePort:port];
            
            port = nil;
        }
    }
    
    if (result == NO) {
        [self showAlert:@"Fail to Open Port" message:@""];
    }
    
    
    [tbvData reloadData];
    [self removeOverlayViews];
}
@end
