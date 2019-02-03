//
//  PrinterChoosingEpsonViewController.m
//  DevJummumOM
//
//  Created by Thidaporn Kijkamjai on 28/12/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "PrinterChoosingEpsonViewController.h"
#import "AppDelegate.h"
#import "ePOS2.h"


@interface PrinterChoosingEpsonViewController ()
{
    NSMutableArray *printerList;
    Epos2FilterOption *filterOption;
    
    
    Epos2Printer *epsonPrinter;
    enum Epos2PrinterSeries valuePrinterSeries;
    enum Epos2ModelLang valuePrinterModel;
}

@property (nonatomic) NSIndexPath *selectedIndexPath;

@property (nonatomic) NSString *portName;
@property (nonatomic) NSString *portSettings;
@property (nonatomic) NSString *modelName;
@property (nonatomic) NSString *macAddress;

@property (nonatomic) StarIoExtEmulation emulation;

@property (nonatomic) ModelIndex selectedModelIndex;

@property (nonatomic) PaperSizeIndex paperSizeIndex;

@property (nonatomic) AppDelegate *appDelegate;

- (void)refreshPortInfo;

@end

@implementation PrinterChoosingEpsonViewController
@synthesize lblNavTitle;
@synthesize tbvData;
@synthesize topViewHeight;
@synthesize printer;
@synthesize selectedPrinterIndex;


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    
    
    float topPadding = window.safeAreaInsets.top;
    topViewHeight.constant = topPadding == 0?20:topPadding;
    
    
    tbvData.layer.zPosition = 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSString *title = [Setting getValue:@"0105t" example:@"เลือกเครื่องพิมพ์"];
    lblNavTitle.text = title;

    tbvData.dataSource = self;
    tbvData.delegate = self;
    
    
    printerList = [[NSMutableArray alloc]init];
    filterOption = [[Epos2FilterOption alloc]init];
    
    
    valuePrinterSeries = EPOS2_TM_M10;
    valuePrinterModel = EPOS2_MODEL_ANK;
    
    
    _selectedIndexPath = nil;
    
    _paperSizeIndex = PaperSizeIndexNone;
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    filterOption.deviceType = 1;
    enum Epos2ErrorStatus result = [Epos2Discovery start:filterOption delegate:self];
    [tbvData reloadData];
}

-(void) onDiscovery:(Epos2DeviceInfo *)deviceInfo
{
    [printerList addObject:deviceInfo];
    [tbvData reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [printerList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCellStyleSubtitle";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Epos2DeviceInfo *deviceInfo = printerList[indexPath.item];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [NSString stringWithFormat:@"%@",deviceInfo.deviceName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@(%@)",deviceInfo.ipAddress,deviceInfo.macAddress];
    cell.      textLabel.textColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (_selectedIndexPath != nil) {
        if ([indexPath compare:_selectedIndexPath] == NSOrderedSame) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"List";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger item = indexPath.item;
    printer.printerStatus = 1;
    UITableViewCell *cell;
    
    if (_selectedIndexPath != nil) {
        cell = [tableView cellForRowAtIndexPath:_selectedIndexPath];
        
        if (cell != nil) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    _selectedIndexPath = indexPath;
    
    
    Epos2DeviceInfo *deviceInfo = printerList[item];
    NSString *portName = [NSString stringWithFormat:@"TCP:%@",deviceInfo.ipAddress];
    
    BOOL isCashDrawerOpenActiveHigh = NO;
    [self saveParamsWithPortName:portName
                    portSettings:_portSettings
                       modelName:deviceInfo.deviceName
                      macAddress:deviceInfo.macAddress
                       emulation:_emulation
        cashDrawerOpenActiveHigh:isCashDrawerOpenActiveHigh
                      modelIndex:_selectedModelIndex
                  paperSizeIndex:_paperSizeIndex];
    
    [self performSegueWithIdentifier:@"segUnwindToPrinterSetting" sender:self];
}

- (void)refreshPortInfo
{
    // Do any additional setup after loading the view, typically from a nib.
    enum Epos2ErrorStatus result = EPOS2_SUCCESS;
    
    while (YES)
    {
        result = [Epos2Discovery stop];
        
        if (result != EPOS2_ERR_PROCESSING)
        {
            if (result == EPOS2_SUCCESS)
            {
                break;
            }
            else
            {
                NSLog(@"stop: %d",result);
//                    MessageView.showErrorEpos(result, method:"stop")
                return;
            }
        }
    }
    
    
    [printerList removeAllObjects];
    [tbvData reloadData];
    
    filterOption.deviceType = 1;
    result = [Epos2Discovery start:filterOption delegate:self];
    if (result != EPOS2_SUCCESS)
    {
        NSLog(@"start: %d",result);
//        MessageView.showErrorEpos(result, method:"start")
    }
}

- (void)saveParamsWithPortName:(NSString *)portName
                  portSettings:(NSString *)portSettings
                     modelName:(NSString *)modelName
                    macAddress:(NSString *)macAddress
                     emulation:(StarIoExtEmulation)emulation
      cashDrawerOpenActiveHigh:(BOOL)cashDrawerOpenActiveHigh
                    modelIndex:(ModelIndex)modelIndex
                paperSizeIndex:(PaperSizeIndex)paperSizeIndex
{
        NSInteger currentAllReceiptsSetting = 0;
    
        NSString *printerBrand = @"2";
        PrinterSetting *printerSetting = [[PrinterSetting alloc] initWithPortName:portName
             portSettings:portSettings
                modelName:modelName
               macAddress:macAddress
               printerBrand:printerBrand
                emulation:emulation
 cashDrawerOpenActiveHigh:cashDrawerOpenActiveHigh
      allReceiptsSettings:currentAllReceiptsSetting
        selectedPaperSize:paperSizeIndex
       selectedModelIndex:modelIndex];
    
        _appDelegate.settingManager.settings[selectedPrinterIndex] = printerSetting;
        [_appDelegate.settingManager save];
    
    }

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToPrinterSetting" sender:self];
}

- (IBAction)refresh:(id)sender
{
    [self refreshPortInfo];
}

@end
