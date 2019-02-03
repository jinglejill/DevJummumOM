//
//  PrinterBrandViewController.m
//  DevJummumOM
//
//  Created by Thidaporn Kijkamjai on 28/12/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "PrinterBrandViewController.h"
#import "PrinterChoosingViewController.h"
#import "PrinterChoosingEpsonViewController.h"
#import "PrinterChoosingGPrinterViewController.h"


@interface PrinterBrandViewController ()
{
    NSArray *_printerBrandList;
}
@end

@implementation PrinterBrandViewController
@synthesize lblNavTitle;
@synthesize tbvData;
@synthesize topViewHeight;
@synthesize printer;
@synthesize selectedPrinterIndex;


-(IBAction)unwindToPrinterBrand:(UIStoryboardSegue *)segue
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
    
    
    NSString *title = @"เลือกยี่ห้อเครื่องพิมพ์";
    lblNavTitle.text = title;
    tbvData.scrollEnabled = NO;
    tbvData.dataSource = self;
    tbvData.delegate = self;
    
    
    
//    [self loadingOverlayView];
//    self.homeModel = [[HomeModel alloc]init];
//    self.homeModel.delegate = self;
    
    
    _printerBrandList = @[@"Star Micronics",@"EPSON",@"GPrinter"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToPrinterSetting" sender:self];
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return [_printerBrandList count];
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

    
    NSString *printerBrand = _printerBrandList[item];
    cell.textLabel.text = printerBrand;
    cell.textLabel.textColor = cSystem4;
    cell.textLabel.font = [UIFont fontWithName:@"Prompt-Regular" size:15.0f];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;


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
    NSInteger item = indexPath.item;
    switch (item)
    {
        case 0:
        {
            dispatch_async(dispatch_get_main_queue(),^ {
                [self performSegueWithIdentifier:@"segPrinterChoosing" sender:self];
            } );
        }
        break;
        case 1:
        {
            dispatch_async(dispatch_get_main_queue(),^ {
                [self performSegueWithIdentifier:@"segPrinterChoosingEpson" sender:self];
            } );
        }
        break;
        case 2:
        {
            dispatch_async(dispatch_get_main_queue(),^ {
                [self performSegueWithIdentifier:@"segPrinterChoosingGPrinter" sender:self];
            } );
        }
        break;
        default:
        break;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"segPrinterChoosing"])
    {
        PrinterChoosingViewController *vc = segue.destinationViewController;
        vc.selectedPrinterIndex = selectedPrinterIndex;
        vc.printer = printer;
    }
    else if([segue.identifier isEqualToString:@"segPrinterChoosingEpson"])
    {
        PrinterChoosingEpsonViewController *vc = segue.destinationViewController;
        vc.selectedPrinterIndex = selectedPrinterIndex;
        vc.printer = printer;
    }
    else if([segue.identifier isEqualToString:@"segPrinterChoosingGPrinter"])
    {
        PrinterChoosingGPrinterViewController *vc = segue.destinationViewController;
        vc.selectedPrinterIndex = selectedPrinterIndex;
        vc.printer = printer;
    }
}

@end
