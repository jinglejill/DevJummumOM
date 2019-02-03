//
//  PrinterChoosingViewController.m
//  DevJummumOM
//
//  Created by Thidaporn Kijkamjai on 24/8/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "PrinterChoosingViewController.h"
#import "AppDelegate.h"

#import "ModelCapability.h"

#import <StarIO/SMPort.h>

typedef NS_ENUM(NSInteger, CellParamIndex) {
    CellParamIndexPortName = 0,
    CellParamIndexModelName,
    CellParamIndexMacAddress
};


@interface PrinterChoosingViewController ()
@property (nonatomic) NSMutableArray *cellArray;

@property (nonatomic) NSIndexPath *selectedIndexPath;

@property (nonatomic) BOOL didAppear;

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

@implementation PrinterChoosingViewController
@synthesize lblNavTitle;
@synthesize tbvData;
@synthesize topViewHeight;
@synthesize printer;


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
    
    
    _cellArray = [[NSMutableArray alloc] init];
    
    _selectedIndexPath = nil;
    
    _paperSizeIndex = PaperSizeIndexNone;
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    _didAppear = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_didAppear == NO)
    {
        [self refreshPortInfo];
        
        _didAppear = YES;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"UITableViewCellStyleSubtitle";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if (cell != nil) {
        NSArray *cellParam = _cellArray[indexPath.row];
        
        cell.textLabel.text = cellParam[CellParamIndexModelName];
        
        if ([cellParam[CellParamIndexMacAddress] isEqualToString:@""]) {
            cell.detailTextLabel.text = cellParam[CellParamIndexPortName];
        }
        else {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)", cellParam[CellParamIndexPortName], cellParam[CellParamIndexMacAddress]];
        }
        
        cell.      textLabel.textColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if (_selectedIndexPath != nil) {
            if ([indexPath compare:_selectedIndexPath] == NSOrderedSame) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"List";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //  [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
    
    NSArray *cellParam = _cellArray[_selectedIndexPath.row];
    
    NSString *modelName  = cellParam[CellParamIndexModelName];
    
    ModelIndex modelIndex = [ModelCapability modelIndexAtModelName:modelName];
    
    //skip choosing model
    [self didConfirmModelWithButtonIndex:1];
}

- (void)refreshPortInfo {
    [self skipSelectInterface];
}

- (void)didConfirmModelWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {     // YES!!!
        NSArray *cellParam = _cellArray[_selectedIndexPath.row];
        
        _portName   = cellParam[CellParamIndexPortName];
        _modelName  = cellParam[CellParamIndexModelName];
        _macAddress = cellParam[CellParamIndexMacAddress];
        
        ModelIndex modelIndex = [ModelCapability modelIndexAtModelName:_modelName];
        
        _portSettings = [ModelCapability portSettingsAtModelIndex:modelIndex];
        _emulation    = [ModelCapability emulationAtModelIndex   :modelIndex];
        _selectedModelIndex = modelIndex;
        
        switch (_emulation) {
            case StarIoExtEmulationStarDotImpact:
            _paperSizeIndex = PaperSizeIndexDotImpactThreeInch;
            break;
            case StarIoExtEmulationEscPos:
            _paperSizeIndex = PaperSizeIndexEscPosThreeInch;
            break;
            default:
            _paperSizeIndex = PaperSizeIndexNone;
            break;
        }
        
        if (self.selectedPrinterIndex > 0) {
            _paperSizeIndex = self->_appDelegate.settingManager.settings[0].selectedPaperSize;
        }
        
        //skip choosing paper
        buttonIndex = 1;//3" 576dots
        [self didSelectPaperSizeWithButtonIndex:buttonIndex];
    }
}

- (void)didSelectPaperSizeWithButtonIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        _paperSizeIndex = PaperSizeIndexTwoInch;
        break;
        case 1:
        _paperSizeIndex = PaperSizeIndexThreeInch;
        break;
        case 2:
        _paperSizeIndex = PaperSizeIndexFourInch;
        break;
    }
    
    if (_selectedModelIndex == ModelIndexNone) {
        NSAssert(NO, nil);
    }
    
    //skip choosing cashDrawer Open Status
    buttonIndex = 0;
    [self didSelectCashDrawerOpenActiveHighWithButtonIndex:buttonIndex];
}

- (void)didSelectCashDrawerOpenActiveHighWithButtonIndex:(NSInteger)buttonIndex {
    BOOL isCashDrawerOpenActiveHigh = NO;
    if (buttonIndex == 0) {     // High when Open
        isCashDrawerOpenActiveHigh = YES;
    }
    else if (buttonIndex == 1) {     // Low when Open
        isCashDrawerOpenActiveHigh = NO;
    } else {
        NSAssert(NO, nil);
    }
    
    [self saveParamsWithPortName:_portName
                    portSettings:_portSettings
                       modelName:_modelName
                      macAddress:_macAddress
                       emulation:_emulation
        cashDrawerOpenActiveHigh:isCashDrawerOpenActiveHigh
                      modelIndex:_selectedModelIndex
                  paperSizeIndex:_paperSizeIndex];
    
    //segBackToPreviousVC
    [self performSegueWithIdentifier:@"segUnwindToPrinterSetting" sender:self];
    //    [self.navigationController popViewControllerAnimated:YES];
}


-(void)skipSelectInterface
{
    self.blind = YES;
    [self loadingOverlayView];
    
    [_cellArray removeAllObjects];
    
    _selectedIndexPath = nil;
    
    NSArray *portInfoArray;
    portInfoArray = [SMPort searchPrinter:@"TCP:"];
    
    
    NSString *portName = @"";
    NSString *modelName = @"";
    NSString *macAddress = @"";
    NSMutableArray *printerSettingList = self->_appDelegate.settingManager.settings;
    if(self->_selectedPrinterIndex+1 <= [printerSettingList count])
    {
        PrinterSetting *currentSetting = printerSettingList[self->_selectedPrinterIndex];
        portName   = currentSetting.portName;
        modelName  = currentSetting.modelName;
        macAddress = currentSetting.macAddress;
    }

    int row = 0;
    
    for (PortInfo *portInfo in portInfoArray) {
        [_cellArray addObject:@[portInfo.portName, portInfo.modelName, portInfo.macAddress]];
        
        if ([portInfo.portName   isEqualToString:portName]   == YES &&
            [portInfo.modelName  isEqualToString:modelName]  == YES &&
            [portInfo.macAddress isEqualToString:macAddress] == YES) {
            _selectedIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
        }
        
        row++;
    }
    
    [tbvData reloadData];
    
    [self removeOverlayViews];
    self.blind = NO;
    
}

- (void)saveParamsWithPortName:(NSString *)portName
                  portSettings:(NSString *)portSettings
                     modelName:(NSString *)modelName
                    macAddress:(NSString *)macAddress
                     emulation:(StarIoExtEmulation)emulation
      cashDrawerOpenActiveHigh:(BOOL)cashDrawerOpenActiveHigh
                    modelIndex:(ModelIndex)modelIndex
                paperSizeIndex:(PaperSizeIndex)paperSizeIndex {
    if (_selectedModelIndex != ModelIndexNone &&
        _paperSizeIndex != PaperSizeIndexNone)
        {
        NSInteger currentAllReceiptsSetting = 0;
        
        NSString *printerBrand = @"1";
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
        
        _appDelegate.settingManager.settings[_selectedPrinterIndex] = printerSetting;
        [_appDelegate.settingManager save];
        
    } else {
        NSAssert(NO, nil);
    }
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToPrinterSetting" sender:self];
}

- (IBAction)refresh:(id)sender
{
    [self refreshPortInfo];
}

- (void)setBlind:(BOOL)blind {
    if (blind == YES) {
        self.navigationItem.hidesBackButton = YES;
        
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        _blindView            .hidden = NO;
        _activityIndicatorView.hidden = NO;
        
        [_activityIndicatorView startAnimating];
        
        [NSRunLoop.currentRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];     // Update View
    }
    else {
        [_activityIndicatorView stopAnimating];
        
        _blindView            .hidden = YES;
        _activityIndicatorView.hidden = YES;
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
        self.navigationItem.hidesBackButton = NO;
        
        //      [NSRunLoop.currentRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];     // Update View(No need)
    }
}
@end
