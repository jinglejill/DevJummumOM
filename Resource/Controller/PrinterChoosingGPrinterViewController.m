//
//  PrinterChoosingGPrinterViewController.m
//  DevJummumOM
//
//  Created by Thidaporn Kijkamjai on 2/1/2562 BE.
//  Copyright © 2562 Jummum Tech. All rights reserved.
//

#import "PrinterChoosingGPrinterViewController.h"
#import "CustomTableViewCellLabelText.h"
#import "CustomTableViewCellButton.h"
#import "GprinterReceiptCommand.h"
#import "AppDelegate.h"


@interface PrinterChoosingGPrinterViewController ()
{
    GprinterReceiptCommand *connection;
    NSString *_portName;
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

@implementation PrinterChoosingGPrinterViewController
static NSString * const reuseIdentifierLabelText = @"CustomTableViewCellLabelText";
static NSString * const reuseIdentifierButton = @"CustomTableViewCellButton";
@synthesize lblNavTitle;
@synthesize tbvData;
@synthesize topViewHeight;
@synthesize printer;
@synthesize selectedPrinterIndex;


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    _portName = textField.text;
}

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
    
    
    NSString *title = @"ระบุเครื่องพิมพ์";
    lblNavTitle.text = title;

    tbvData.dataSource = self;
    tbvData.delegate = self;
    tbvData.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelText bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelText];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierButton bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierButton];
    }


    _selectedIndexPath = nil;
    
    _paperSizeIndex = PaperSizeIndexNone;
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    PrinterSetting *printerSetting =  _appDelegate.settingManager.settings[selectedPrinterIndex];
    _portName = printerSetting.portName;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [printerList count];
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if(section == 0)
    {
        CustomTableViewCellLabelText *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelText];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.lblTitle.text = @"ระบุ IP เครื่องพิมพ์";
        cell.txtValue.text = _portName;
        cell.txtValue.placeholder = @"x.x.x.x";
        cell.lblRemark.text = @"";
        cell.txtValue.delegate = self;
        
        return cell;
    }
    else if(section == 1)
    {
        CustomTableViewCellButton *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierButton];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.btnValue setTitle:@"ทดสอบพิมพ์" forState:UIControlStateNormal];
        [cell.btnValue addTarget:self action:@selector(printTest:) forControlEvents:UIControlEventTouchUpInside];
        [self setButtonDesign:cell.btnValue];
        cell.indicator.hidden = YES;
        
        return cell;
    }
    return  nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if(section == 0)
    {
        return 78;
    }
    
    return 44;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.separatorInset = UIEdgeInsetsMake(0.0f, self.view.bounds.size.width, 0.0f, CGFLOAT_MAX);
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
        NSString *printerBrand = @"3";
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

- (IBAction)connectPrinter:(id)sender
{
    printer.printerStatus = 2;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    CustomTableViewCellLabelText *cell = [tbvData cellForRowAtIndexPath:indexPath];
    NSString *ipAddress = cell.txtValue.text;
    NSString *deviceName = @"GPrinter";
    NSString *macAddress = @"";
    
    
    BOOL isCashDrawerOpenActiveHigh = NO;
    [self saveParamsWithPortName:ipAddress
                    portSettings:_portSettings
                       modelName:deviceName
                      macAddress:macAddress
                       emulation:_emulation
        cashDrawerOpenActiveHigh:isCashDrawerOpenActiveHigh
                      modelIndex:_selectedModelIndex
                  paperSizeIndex:_paperSizeIndex];
    
    [self performSegueWithIdentifier:@"segUnwindToPrinterSetting" sender:self];
}

-(void)printTest:(id)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    CustomTableViewCellLabelText *cell = [tbvData cellForRowAtIndexPath:indexPath];


    //GPrinter
    connection = [[GprinterReceiptCommand alloc]init];
    connection = [connection OpenPort:cell.txtValue.text port:9100 timeout:100];
    [connection basicSetting];

    
    [connection addText:@"GPrinter test"];
    [connection addCut];
    [connection SendToThePrinter];
}
@end
