//
//  ReportDetailsByDayViewController.m
//  DevJummumOM
//
//  Created by Thidaporn Kijkamjai on 17/9/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "ReportDetailsByDayViewController.h"
#import "CustomTableViewCellReportDailyHeader.h"
#import "CustomTableViewCellReportDaily.h"
#import "CustomTableViewCellReportSummaryByDay.h"
#import "CustomTableViewCellButtonDetail.h"
#import "CustomTableViewCellMonthYearBalance.h"
#import "Setting.h"
#import "Branch.h"
#import "ReportDaily.h"
#import "ReportDetailsByOrder.h"


@interface ReportDetailsByDayViewController ()
{
    NSMutableArray *_reportDailyList;
    NSMutableArray *_reportDetailsByOrderList;

}
@end

@implementation ReportDetailsByDayViewController
static NSString * const reuseIdentifierReportDailyHeader = @"CustomTableViewCellReportDailyHeader";
static NSString * const reuseIdentifierReportDaily = @"CustomTableViewCellReportDaily";
static NSString * const reuseIdentifierReportSummaryByDay = @"CustomTableViewCellReportSummaryByDay";
static NSString * const reuseIdentifierButtonDetail = @"CustomTableViewCellButtonDetail";
static NSString * const reuseIdentifierMonthYearBalance = @"CustomTableViewCellMonthYearBalance";


@synthesize lblNavTitle;
@synthesize tbvData;
@synthesize topViewHeight;
@synthesize selectedReportDaily;


-(IBAction)unwindToReport:(UIStoryboardSegue *)segue
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
    
    
    NSString *title = [Setting getValue:@"108t" example:@"รายละเอียดรายวัน"];
    lblNavTitle.text = title;
    tbvData.dataSource = self;
    tbvData.delegate = self;
    tbvData.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    

    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierMonthYearBalance bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierMonthYearBalance];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierReportDailyHeader bundle:nil];
        [tbvData registerNib:nib forHeaderFooterViewReuseIdentifier:reuseIdentifierReportDailyHeader];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierReportDaily bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierReportDaily];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierReportSummaryByDay bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierReportSummaryByDay];
    }
    
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture setCancelsTouchesInView:NO];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    NSString *strReceiptDate = [Utility dateToString:selectedReportDaily.receiptDate toFormat:@"yyyy-MM-dd"];
    [self downloadReport:strReceiptDate];
}

-(void)downloadReport:(NSString *)strReceiptDate
{
    [self loadingOverlayView];
    Branch *branch = [Branch getCurrentBranch];
    [self.homeModel downloadItems:dbReportDetailsByDay withData:@[branch,strReceiptDate]];
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToReport" sender:self];
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
        return 2;
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
        if(section == 0)
        {
            NSInteger reportItem = tableView.tag;
            ReportDaily *reportDaily = _reportDailyList[reportItem];
            if(reportDaily.expand)
            {
                NSMutableArray *reportDetailsByOrderList = [self getOrderWithReceiptID:reportDaily.receiptID];
                return [reportDetailsByOrderList count];
            }
            else
            {
                return 0;
            }
        }
        else if(section == 1)
        {
            return 8;
        }
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
            CustomTableViewCellMonthYearBalance *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierMonthYearBalance];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            cell.lblMonthYear.text = [Utility dateToString:selectedReportDaily.receiptDate toFormat:@"d MMM yyyy"];
            cell.lblBalance.text = [Utility formatDecimal:selectedReportDaily.balance withMinFraction:2 andMaxFraction:2];
            
            
            return cell;
        }
        else
        {
            CustomTableViewCellReportDaily *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierReportDaily];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            
            ReportDaily *reportDaily = _reportDailyList[item];
            UIFont *font = [UIFont fontWithName:@"Prompt-SemiBold" size:14];
            NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:reportDaily.receiptNoID                                                                                               attributes:attribute];
            
            

            cell.lblReceiptDate.textColor = cSystem1;
            cell.lblReceiptDate.attributedText = attrString;
            [cell.lblReceiptDate sizeToFit];
            cell.lblReceiptDateWidth.constant = cell.lblReceiptDate.frame.size.width;
            cell.lblBalance.font = [UIFont fontWithName:@"Prompt-SemiBold" size:14];
            cell.lblBalance.text = [Utility formatDecimal:reportDaily.balance withMinFraction:2 andMaxFraction:2];
            cell.lblStatusWidth.constant = 0;
            cell.lblStatusLeading.constant = 0;
            cell.lblStatus.hidden = YES;
            
            
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
        if(section == 0)
        {
            CustomTableViewCellReportSummaryByDay *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierReportSummaryByDay];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.lblTitle.textColor = cSystem4;
            cell.lblValue.textColor = cSystem4;
            
            
            NSInteger reportItem = tableView.tag;
            ReportDaily *reportDaily = _reportDailyList[reportItem];
            
            
            NSMutableArray *reportDetailsByOrderList = [self getOrderWithReceiptID:reportDaily.receiptID];
            ReportDetailsByOrder *reportDetailsByOrder = reportDetailsByOrderList[item];
            
            
            cell.lblTitleLeading.constant = 0;
            cell.lblTitle.font = [UIFont fontWithName:@"Prompt-Regular" size:14.0f];
            cell.lblTitle.text = reportDetailsByOrder.titleThai;
            cell.lblValue.text = [Utility formatDecimal:reportDetailsByOrder.total withMinFraction:2 andMaxFraction:2];
            
            
            float lblValueWidth = 80;
            cell.lblTitleWidth.constant = self.view.frame.size.width - 16 - lblValueWidth - 8;
            [cell.lblTitle sizeToFit];            
            cell.lblTitleHeight.constant = cell.lblTitle.frame.size.height;
            
            return cell;
            
        }
        else if(section == 1)
        {
            CustomTableViewCellReportSummaryByDay *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierReportSummaryByDay];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.lblTitle.textColor = cSystem4;
            cell.lblValue.textColor = cSystem4;
            cell.hidden = NO;
            cell.lblTitle.font = [UIFont fontWithName:@"Prompt-SemiBold" size:14.0f];
            cell.lblTitleLeading.constant = 32;
            cell.lblTitleHeight.constant = 22;
            
            
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
                    cell.lblValue.text = [Utility encloseWithBracket:[Utility formatDecimal:reportDaily.discountValue withMinFraction:2 andMaxFraction:2]];
                }
                    break;
                case 2:
                {
                    cell.lblTitle.text = @"ยอดขายหลังส่วนลด";
                    cell.lblValue.text = [Utility formatDecimal:reportDaily.afterDiscount withMinFraction:2 andMaxFraction:2];
                }
                    break;
                case 3:
                {
                    cell.lblTitle.text = @"Service charge";
                    cell.lblValue.text = [Utility formatDecimal:reportDaily.serviceChargeValue withMinFraction:2 andMaxFraction:2];
                    cell.hidden = branch.serviceChargePercent == 0;
                }
                    break;
                case 4:
                {
                    cell.lblTitle.text = @"VAT";
                    cell.lblValue.text = [Utility formatDecimal:reportDaily.vatValue withMinFraction:2 andMaxFraction:2];
                    cell.hidden = branch.percentVat == 0;
                }
                    break;
                case 5:
                {
                    cell.lblTitle.text = @"ยอดรวมทั้งสิ้น";
                    cell.lblValue.text = [Utility formatDecimal:reportDaily.netTotal withMinFraction:2 andMaxFraction:2];
                    cell.hidden = branch.serviceChargePercent + branch.percentVat == 0;
                }
                    break;
                case 6:
                {
                    cell.lblTitle.text = @"ค่า transaction";
                    cell.lblValue.text = [Utility encloseWithBracket:[Utility formatDecimal:reportDaily.transactionFeeValue withMinFraction:2 andMaxFraction:2]];
                }
                    break;
                case 7:
                {
                    cell.lblTitle.text = @"เงินคืนพิเศษจาก JUMMUM";
                    cell.lblValue.text = [Utility formatDecimal:reportDaily.jummumPayValue withMinFraction:2 andMaxFraction:2];
                    cell.lblTitle.textColor = cSystem1;
                    cell.lblValue.textColor = cSystem1;
                }
                    break;
                default:
                    break;
            }
            float lblValueWidth = 80;
            cell.lblTitleWidth.constant = self.view.frame.size.width - 16 - lblValueWidth - 8 - 32;
            [cell.lblTitle sizeToFit];
            
            
            return cell;
        }
        
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
            Branch *branch = [Branch getCurrentBranch];
            NSInteger countServiceCharge = branch.serviceChargePercent == 0?0:1;
            NSInteger countVat = branch.percentVat == 0?0:1;
            NSInteger countNetTotal = countServiceCharge + countVat == 0?0:1;
            NSInteger countRow = 5 + countServiceCharge + countVat + countNetTotal;
            
            
            float section0Height = 0;
            ReportDaily *reportDaily = _reportDailyList[item];
            if(reportDaily.expand)
            {
                NSMutableArray *reportDetailsByOrderList = [self getOrderWithReceiptID:reportDaily.receiptID];
                for(int i=0; i<[reportDetailsByOrderList count]; i++)
                {
                    CustomTableViewCellReportSummaryByDay *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierReportSummaryByDay];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                    ReportDaily *reportDaily = _reportDailyList[item];
                    
                    
                    NSMutableArray *reportDetailsByOrderList = [self getOrderWithReceiptID:reportDaily.receiptID];
                    ReportDetailsByOrder *reportDetailsByOrder = reportDetailsByOrderList[i];
                    
                    
                    cell.lblTitleLeading.constant = 0;
                    cell.lblTitle.font = [UIFont fontWithName:@"Prompt-Regular" size:14.0f];
                    cell.lblTitle.text = reportDetailsByOrder.titleThai;
                    cell.lblValue.text = [Utility formatDecimal:reportDetailsByOrder.total withMinFraction:2 andMaxFraction:2];
                    
                    
                    float lblValueWidth = 80;
                    cell.lblTitleWidth.constant = self.view.frame.size.width - 16 - lblValueWidth - 8;
                    [cell.lblTitle sizeToFit];
                    cell.lblTitleHeight.constant = cell.lblTitle.frame.size.height;
                    
                    NSInteger rowHeight = cell.lblTitleHeight.constant<44?44:cell.lblTitleHeight.constant;
                    section0Height += rowHeight;
                }
            }
            
            return 44+section0Height+countRow*44;
        }
    }
    else
    {
        if(section == 0)
        {
            CustomTableViewCellReportSummaryByDay *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierReportSummaryByDay];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            NSInteger reportItem = tableView.tag;
            ReportDaily *reportDaily = _reportDailyList[reportItem];
            
            
            NSMutableArray *reportDetailsByOrderList = [self getOrderWithReceiptID:reportDaily.receiptID];
            ReportDetailsByOrder *reportDetailsByOrder = reportDetailsByOrderList[item];
            
            
            cell.lblTitleLeading.constant = 0;
            cell.lblTitle.font = [UIFont fontWithName:@"Prompt-Regular" size:14.0f];
            cell.lblTitle.text = reportDetailsByOrder.titleThai;
            cell.lblValue.text = [Utility formatDecimal:reportDetailsByOrder.total withMinFraction:2 andMaxFraction:2];
            
            
            float lblValueWidth = 80;
            cell.lblTitleWidth.constant = self.view.frame.size.width - 16 - lblValueWidth - 8;
            [cell.lblTitle sizeToFit];
            cell.lblTitleHeight.constant = cell.lblTitle.frame.size.height;
            
            NSInteger rowHeight = cell.lblTitleHeight.constant<44?44:cell.lblTitleHeight.constant;
            return rowHeight;
        }
        else if(section == 1)
        {
            Branch *branch = [Branch getCurrentBranch];
            
            switch (item) {
                case 0:
                case 1:
                case 2:
                case 6:
                case 7:
//                case 8:
                    return 44;
                case 3:
                    return branch.serviceChargePercent == 0?0:44;
                case 4:
                    return branch.percentVat == 0?0:44;
                case 5:
                    return branch.serviceChargePercent + branch.percentVat == 0?0:44;
                default:
                    break;
            }
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
            cell.backgroundColor = cSystem4_10;
            
            
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
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if([tableView isEqual:tbvData])
    {
        if(section == 1)
        {
            CustomTableViewCellReportDailyHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifierReportDailyHeader];
            headerView.lblDate.text = @"Order no.";
            headerView.lblDate.textAlignment = NSTextAlignmentLeft;
            [headerView.lblDate sizeToFit];
            headerView.lblStatusWidth.constant = 0;
            headerView.lblStatusLeading.constant = 0;
            headerView.lblStatus.hidden = NO;
//            headerView.layer.backgroundColor = cSystem1.CGColor;
            
            
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

-(void)itemsDownloaded:(NSArray *)items manager:(NSObject *)objHomeModel
{
    [self removeOverlayViews];
    HomeModel *homeModel = (HomeModel *)objHomeModel;
    if(homeModel.propCurrentDB == dbReportDetailsByDay)
    {
        _reportDailyList = items[0];
        _reportDetailsByOrderList = items[1];
        
        [tbvData reloadData];
    }
}

-(void)unwindToMe
{
    [self performSegueWithIdentifier:@"segUnwindToMe" sender:self];
}

-(void)showDetail:(id)sender
{
    UIButton *btnShowDetail = sender;
    NSInteger reportItem = btnShowDetail.tag;
    ReportDaily *reportDaily = _reportDailyList[reportItem];

    
    if(!reportDaily.expand)
    {
        [btnShowDetail setTitle:@"ซ่อนรายละเอียด" forState:UIControlStateNormal];
    }
    else
    {
        [btnShowDetail setTitle:@"แสดงรายละเอียด" forState:UIControlStateNormal];
    }
    reportDaily.expand = !reportDaily.expand;
    [tbvData reloadData];
}

-(NSMutableArray *)getOrderWithReceiptID:(NSInteger)receiptID
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_receiptID = %ld",receiptID];
    NSArray *filterArray = [_reportDetailsByOrderList filteredArrayUsingPredicate:predicate];
    
    return [filterArray mutableCopy];
}
@end
