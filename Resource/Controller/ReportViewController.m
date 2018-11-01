//
//  ReportViewController.m
//  DevJummumOM
//
//  Created by Thidaporn Kijkamjai on 14/9/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "ReportViewController.h"
#import "ReportDetailsByDayViewController.h"
#import "CustomTableViewCellMonthYear.h"
#import "CustomTableViewCellReportDailyHeader.h"
#import "CustomTableViewCellReportDaily.h"
#import "CustomTableViewCellReportSummaryByDay.h"
#import "CustomTableViewCellButtonDetail.h"
#import "Setting.h"
#import "Branch.h"
#import "ReportDaily.h"


@interface ReportViewController ()
{
    NSMutableArray *_reportDailyList;
    NSString *_strSelectedMonthYear;
    NTMonthYearPicker *picker;
    ReportDaily *_selectedReportDaily;
    BOOL _viewDidAppear;
}
@end

@implementation ReportViewController
static NSString * const reuseIdentifierMonthYear = @"CustomTableViewCellMonthYear";
static NSString * const reuseIdentifierReportDailyHeader = @"CustomTableViewCellReportDailyHeader";
static NSString * const reuseIdentifierReportDaily = @"CustomTableViewCellReportDaily";
static NSString * const reuseIdentifierReportSummaryByDay = @"CustomTableViewCellReportSummaryByDay";
static NSString * const reuseIdentifierButtonDetail = @"CustomTableViewCellButtonDetail";


@synthesize lblNavTitle;
@synthesize tbvData;
@synthesize topViewHeight;
@synthesize ntMonthYearPicker;


-(IBAction)unwindToReport:(UIStoryboardSegue *)segue
{
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.tag == 1)
    {
        NSString *strDate = textField.text;
        if([strDate isEqualToString:@""])
        {
            [picker setDate:[Utility currentDateTime]];
        }
        else
        {
            NSDate *datePeriod = [Utility stringToDate:strDate fromFormat:@"MMM yyyy"];
            [picker setDate:datePeriod];
        }
    }
}

- (void)onDatePicked:(UITapGestureRecognizer *)gestureRecognizer
{
    UITextField *textField = (UITextField *)[self.view viewWithTag:1];
    if([textField isFirstResponder])
    {
        NSDate *selectedDate = [Utility addMonth:picker.date numberOfMonth:1];
        textField.text = [Utility dateToString:selectedDate toFormat:@"MMM yyyy"];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.tag == 1)
    {
        _strSelectedMonthYear = textField.text;
        NSString *strMonthYear = [Utility formatDate:textField.text fromFormat:@"MMM yyyy" toFormat:@"yyyy-MM"];
        [self downloadReport:strMonthYear];
        [picker removeFromSuperview];
    }
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
    
    
    NSString *title = [Setting getValue:@"107t" example:@"รายงาน"];
    lblNavTitle.text = title;
    tbvData.dataSource = self;
    tbvData.delegate = self;
    tbvData.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
//    [picker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [picker removeFromSuperview];
    
    
    
    // Initialize the picker
    picker = [[NTMonthYearPicker alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 216)];
    [picker addTarget:self action:@selector(onDatePicked:) forControlEvents:UIControlEventValueChanged];



    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierMonthYear bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierMonthYear];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierReportDailyHeader bundle:nil];
        [tbvData registerNib:nib forHeaderFooterViewReuseIdentifier:reuseIdentifierReportDailyHeader];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierReportDaily bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierReportDaily];
    }
    

    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture setCancelsTouchesInView:NO];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(!_viewDidAppear)
    {
        _viewDidAppear = YES;
        NSDate *currentDate = [Utility currentDateTime];
        NSString *strMonthYear = [Utility dateToString:currentDate toFormat:@"yyyy-MM"];
        _strSelectedMonthYear = [Utility dateToString:currentDate toFormat:@"MMM yyyy"];
        [self downloadReport:strMonthYear];
    }
    
}

-(void)downloadReport:(NSString *)strMonthYear
{
    [self loadingOverlayView];
    Branch *branch = [Branch getCurrentBranch];
    [self.homeModel downloadItems:dbReportDaily withData:@[branch,strMonthYear]];
}

- (IBAction)goBack:(id)sender
{
    [self unwindToMe];
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if([tableView isEqual:tbvData])
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if([tableView isEqual:tbvData])
    {
        if(section == 0)
        {
            return 1;
        }
        else if(section == 1)
        {
            return [_reportDailyList count];
        }
    }
    else
    {
        return 11;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    

    if([tableView isEqual:tbvData])
    {
        if(section == 0)
        {
            CustomTableViewCellMonthYear *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierMonthYear];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.txtMonthYear.tag = 1;
            cell.txtMonthYear.delegate = self;
            cell.txtMonthYear.inputView = picker;
            [cell.txtMonthYear setInputAccessoryView:self.toolBar];
            cell.txtMonthYear.text = _strSelectedMonthYear;
            
            return cell;
        }
        else
        {
            CustomTableViewCellReportDaily *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierReportDaily];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            
            ReportDaily *reportDaily = _reportDailyList[item];
            cell.lblReceiptDate.text = [Utility dateToString:reportDaily.receiptDate toFormat:@"dd/MM/yy"];
            cell.lblBalance.text = [Utility formatDecimal:reportDaily.balance withMinFraction:2 andMaxFraction:2];
            cell.lblStatus.text = reportDaily.status == 0?@"กำลังสรุปยอด":@"โอนเรียบร้อย";
            
            
            cell.tbvSummaryByDay.tag = item;
            cell.tbvSummaryByDay.delegate = self;
            cell.tbvSummaryByDay.dataSource = self;
            cell.tbvSummaryByDay.scrollEnabled = NO;
            {
                UINib *nib = [UINib nibWithNibName:reuseIdentifierReportSummaryByDay bundle:nil];
                [cell.tbvSummaryByDay registerNib:nib forCellReuseIdentifier:reuseIdentifierReportSummaryByDay];
            }
            {
                UINib *nib = [UINib nibWithNibName:reuseIdentifierButtonDetail bundle:nil];
                [cell.tbvSummaryByDay registerNib:nib forCellReuseIdentifier:reuseIdentifierButtonDetail];
            }
            [cell.tbvSummaryByDay reloadData];
            
            
            return cell;
        }
    }
    else
    {
        CustomTableViewCellReportSummaryByDay *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierReportSummaryByDay];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lblTitle.textColor = cSystem4;
        cell.lblValue.textColor = cSystem4;
        cell.hidden = NO;
        
        
        Branch *branch = [Branch getCurrentBranch];
        NSInteger reportItem = tableView.tag;
        ReportDaily *reportDaily = _reportDailyList[reportItem];
        switch (item)
        {
            case 0:
            {
                cell.lblTitle.text = @"ยอดขายก่อนส่วนลด";
                cell.lblValue.text = [Utility formatDecimal:reportDaily.totalAmount withMinFraction:2 andMaxFraction:2];
            }
                break;
            case 1:
            {
                cell.lblTitle.text = @"ส่วนลด";
                cell.lblValue.text = [Utility encloseWithBracket:[Utility formatDecimal:reportDaily.specialPriceDiscount withMinFraction:2 andMaxFraction:2]];
            }
                break;
            case 2:
            {
                cell.lblTitle.text = @"ส่วนลดจาก Voucher";
                cell.lblValue.text = [Utility encloseWithBracket:[Utility formatDecimal:reportDaily.discountValue withMinFraction:2 andMaxFraction:2]];
            }
                break;
            case 3:
            {
                cell.lblTitle.text = @"ยอดขายหลังส่วนลด";
                cell.lblValue.text = [Utility formatDecimal:reportDaily.afterDiscount withMinFraction:2 andMaxFraction:2];
            }
                break;
            case 4:
            {
                cell.lblTitle.text = @"Service charge";
                cell.lblValue.text = [Utility formatDecimal:reportDaily.serviceChargeValue withMinFraction:2 andMaxFraction:2];
                cell.hidden = branch.serviceChargePercent == 0;
            }
                break;
            case 5:
            {
                cell.lblTitle.text = @"VAT";
                cell.lblValue.text = [Utility formatDecimal:reportDaily.vatValue withMinFraction:2 andMaxFraction:2];
                cell.hidden = branch.percentVat == 0;
            }
                break;
            case 6:
            {
                cell.lblTitle.text = @"ยอดรวมทั้งสิ้น";
                cell.lblValue.text = [Utility formatDecimal:reportDaily.netTotal withMinFraction:2 andMaxFraction:2];
                cell.hidden = branch.serviceChargePercent + branch.percentVat == 0;
            }
                break;
            case 7:
            {
                cell.lblTitle.text = @"ยอดรวมก่อน VAT";
                cell.lblValue.text = [Utility formatDecimal:reportDaily.beforeVat withMinFraction:2 andMaxFraction:2];
                cell.hidden = !((branch.serviceChargePercent>0 && branch.percentVat>0) || (branch.serviceChargePercent == 0 && branch.percentVat>0 && branch.priceIncludeVat));
            }
                break;
            case 8:
            {
                cell.lblTitle.text = @"ค่า transaction";
                cell.lblValue.text = [Utility encloseWithBracket:[Utility formatDecimal:reportDaily.transactionFeeValue withMinFraction:2 andMaxFraction:2]];
            }
                break;
            case 9:
            {
                cell.lblTitle.text = @"เงินคืนพิเศษจาก JUMMUM";
                cell.lblValue.text = [Utility formatDecimal:reportDaily.jummumPayValue withMinFraction:2 andMaxFraction:2];
                cell.lblTitle.textColor = cSystem1;
                cell.lblValue.textColor = cSystem1;
            }
                break;
            case 10:
            {
                CustomTableViewCellButtonDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierButtonDetail];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                cell.btnShowDetail.tag = reportItem;
                [self setButtonDesign:cell.btnShowDetail];
                [cell.btnShowDetail addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
                
                return cell;
            }
            default:
                break;
        }

        
        return cell;
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;

    if([tableView isEqual:tbvData])
    {
        if(section == 0)
        {
            return 44;
        }
        else if(section == 1)
        {
            ReportDaily *reportDaily = _reportDailyList[item];
            if(reportDaily.expand)
            {
                Branch *branch = [Branch getCurrentBranch];
                NSInteger countServiceCharge = branch.serviceChargePercent == 0?0:1;
                NSInteger countVat = branch.percentVat == 0?0:1;
                NSInteger countNetTotal = countServiceCharge + countVat == 0?0:1;
                NSInteger countBeforeVat = (branch.serviceChargePercent>0 && branch.percentVat>0) || (branch.serviceChargePercent == 0 && branch.percentVat>0 && branch.priceIncludeVat)?1:0;
                NSInteger countRow = 6 + countServiceCharge + countVat + countNetTotal + countBeforeVat + 1;
                
                return 44+countRow*44;
            }
            else
            {
                return 44;
            }
        }
    }
    else
    {
        Branch *branch = [Branch getCurrentBranch];
    
        switch (item)
        {
            case 0:
            case 1:
            case 2:
            case 3:
            case 8:
            case 9:
            case 10:
                return 44;
            case 4:
                return branch.serviceChargePercent == 0?0:44;
            case 5:
                return branch.percentVat == 0?0:44;
            case 6:
                return branch.serviceChargePercent + branch.percentVat == 0?0:44;
            case 7:
                return (branch.serviceChargePercent>0 && branch.percentVat>0) || (branch.serviceChargePercent == 0 && branch.percentVat>0 && branch.priceIncludeVat)?44:0;
            default:
                break;
        }
        return 0;
    }
    
    return 0;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
    
    
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    if([tableView isEqual:tbvData])
    {
        if(section == 1)
        {
            ReportDaily *reportDaily = _reportDailyList[item];
            cell.backgroundColor = cSystem4_10;
            if([Utility isWeekend:reportDaily.receiptDate])
            {
                cell.backgroundColor = cSystem1_10;
            }
            
            
            cell.separatorInset = UIEdgeInsetsMake(0.0f, self.view.bounds.size.width, 0.0f, CGFLOAT_MAX);
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    if([tableView isEqual:tbvData])
    {
        if(section == 1)
        {
            ReportDaily *reportDaily = _reportDailyList[item];
            
            reportDaily.expand = !reportDaily.expand;
            [tbvData reloadData];
        }
    }
    else
    {
        NSInteger reportItem = tableView.tag;
        ReportDaily *reportDaily = _reportDailyList[reportItem];
        
        reportDaily.expand = !reportDaily.expand;
        [tbvData reloadData];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if([tableView isEqual:tbvData])
    {
        if(section == 1)
        {
            CustomTableViewCellReportDailyHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifierReportDailyHeader];
            
            
            //corner
            CAShapeLayer * maskLayer = [CAShapeLayer layer];
            maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: headerView.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: (CGSize){14.0}].CGPath;
            maskLayer.fillColor = cSystem1.CGColor;
            [headerView.layer insertSublayer:maskLayer atIndex:0];

            
            //shadow
            headerView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
            headerView.layer.shadowOpacity = 0.8;
            headerView.layer.shadowRadius = 3;
            headerView.layer.shadowOffset = CGSizeMake(0, 1);
            headerView.layer.masksToBounds = NO;

            
            return headerView;
        }
    }
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if([tableView isEqual:tbvData])
    {
        if(section == 1)
        {
            return 44;
        }
    }
    return 0;
}

-(void)itemsDownloaded:(NSArray *)items
{
    [self removeOverlayViews];
    _reportDailyList = items[0];
    [tbvData reloadData];
}

-(void)unwindToMe
{
    [self performSegueWithIdentifier:@"segUnwindToMe" sender:self];
}

-(void)showDetail:(id)sender
{
    UIButton *btnShowDetail = sender;
    _selectedReportDaily = _reportDailyList[btnShowDetail.tag];
    
    [self performSegueWithIdentifier:@"segReportDetailsByDay" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segReportDetailsByDay"])
    {
        ReportDetailsByDayViewController *vc = segue.destinationViewController;
        vc.selectedReportDaily = _selectedReportDaily;
    }
}
@end
