//
//  PrinterSettingViewController.m
//  DevJummumOM
//
//  Created by Thidaporn Kijkamjai on 24/8/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "PrinterSettingViewController.h"
#import "PrinterChoosingViewController.h"
#import "Setting.h"
#import "AppDelegate.h"
#import "PrinterSetting.h"
#import "Printer.h"
#import "Branch.h"
#import <StarIO/SMPort.h>


@interface PrinterSettingViewController ()
{
    NSMutableArray *_printerList;
    NSInteger _selectedPrinterIndex;
    BOOL _firstLoad;
    
}
@property (nonatomic) NSMutableArray *statusCellArray;

@property (nonatomic) NSMutableArray *firmwareInfoCellArray;

@end

@implementation PrinterSettingViewController
@synthesize lblNavTitle;
@synthesize tbvData;
@synthesize topViewHeight;


-(IBAction)unwindToPrinterSetting:(UIStoryboardSegue *)segue
{
//    [self loadingOverlayView];
    _firstLoad = NO;
    [tbvData reloadData];
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
    _printerList = [[NSMutableArray alloc]init];
    _firstLoad = YES;
    
    
    [self loadingOverlayView];
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    
    Branch *branch = [Branch getCurrentBranch];
    [self.homeModel downloadItems:dbPrinter withData:branch];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _statusCellArray = [[NSMutableArray alloc] init];
    
    _firmwareInfoCellArray = [[NSMutableArray alloc] init];
    
    if(_firstLoad)
    {
        [self refreshDeviceStatus];
    }
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToMe" sender:self];
}

- (IBAction)refresh:(id)sender
{
    [self loadingOverlayView];
    
    [self refreshDeviceStatus];
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return [_printerList count];
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
            
            PrinterSetting *printerSetting;
            NSString *strPortNameAndMacAddress;
            BOOL printerAlreadySet = NO;
            AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            NSMutableArray *printerSettingList = appDelegate.settingManager.settings;
            if(indexPath.section+1 <= [printerSettingList count])
            {
                printerSetting = appDelegate.settingManager.settings[indexPath.section];
                strPortNameAndMacAddress = [NSString stringWithFormat:@"%@ (%@)",printerSetting.portName,printerSetting.macAddress];
                
                if(printerSetting.modelName)
                {
                    printerAlreadySet = YES;
                }
            }
            
            if(printerAlreadySet)
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
            
            
            Printer *printer = _printerList[indexPath.section];
            if(printer.printerStatus == 1)
            {
                cell.textLabel.text = @"สถานะ";
                cell.textLabel.textColor = cSystem4;
                cell.textLabel.font = [UIFont fontWithName:@"Prompt-Regular" size:15.0f];
                cell.detailTextLabel.text = @"Online";
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
        _selectedPrinterIndex = indexPath.section;
        dispatch_async(dispatch_get_main_queue(),^ {
            [self performSegueWithIdentifier:@"segPrinterChoosing" sender:self];            
        } );
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, tableView.frame.size.width, 22)];
    [label setFont:[UIFont fontWithName:@"Prompt-SemiBold" size:15]];
    Printer *printer = _printerList[section];
    NSString *string = printer.name;
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor clearColor]]; //your background color...
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (void)refreshDeviceStatus {
    BOOL result = NO;
    
    
    [_statusCellArray       removeAllObjects];
    [_firmwareInfoCellArray removeAllObjects];
    
    for(int i=0; i<[_printerList count]; i++)
    {
        SMPort *port = nil;
    
        @try {
            while (YES)
            {
                AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
                NSMutableArray *printerSettingList = appDelegate.settingManager.settings;
                if(i+1 > [printerSettingList count])
                {
                    break;
                }
                PrinterSetting *printerSetting = printerSettingList[i];
                NSString *portName = printerSetting.portName;
                port = [SMPort getPort:portName :printerSetting.portSettings :10000];     // 10000mS!!!
                
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
                
                Printer *printer = _printerList[i];
                if (printerStatus.offline == SM_TRUE)
                {
                    printer.printerStatus = 0;
                    [_statusCellArray addObject:@[@"Online", @"Offline", [UIColor redColor]]];
                }
                else
                {
                    printer.printerStatus = 1;
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
    }
    
    if (result == NO) {
        [self showAlert:@"Fail to Open Port" message:@""];
    }
    
    [tbvData reloadData];
    [self removeOverlayViews];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"segPrinterChoosing"])
    {
        PrinterChoosingViewController *vc = segue.destinationViewController;
        vc.selectedPrinterIndex = _selectedPrinterIndex;
        vc.printer = _printerList[_selectedPrinterIndex];
    }
}

-(void)itemsDownloaded:(NSArray *)items manager:(NSObject *)objHomeModel
{
//    [self removeOverlayViews];
    _printerList = items[0];
    [tbvData reloadData];
}
@end
