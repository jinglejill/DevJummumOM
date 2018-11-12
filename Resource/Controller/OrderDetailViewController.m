//
//  OrderDetailViewController.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 10/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "ConfirmDisputeViewController.h"
#import "CustomTableViewCellReceiptSummary.h"
#import "CustomTableViewCellOrderSummary.h"
#import "CustomTableViewCellTotal.h"
#import "CustomTableViewCellLabelLabel.h"
#import "CustomTableViewCellButton.h"
#import "CustomTableViewCellDisputeDetail.h"
#import "CustomTableViewCellLabelRemark.h"
#import "Receipt.h"
#import "UserAccount.h"
#import "Branch.h"
#import "OrderTaking.h"
#import "Menu.h"
#import "OrderNote.h"
#import "Dispute.h"
#import "DisputeReason.h"
#import "CustomerTable.h"
#import "Message.h"
#import "Setting.h"
#import "QuartzCore/QuartzCore.h"

#import "AppDelegate.h"
#import "Communication.h"
#import "GlobalQueueManager.h"

@interface OrderDetailViewController ()
{
    Branch *_receiptBranch;
    NSInteger _fromType;//1=cancel,2=dispute
    float _accumHeight;
}
@end

@implementation OrderDetailViewController
static NSString * const reuseIdentifierReceiptSummary = @"CustomTableViewCellReceiptSummary";
static NSString * const reuseIdentifierOrderSummary = @"CustomTableViewCellOrderSummary";
static NSString * const reuseIdentifierTotal = @"CustomTableViewCellTotal";
static NSString * const reuseIdentifierLabelLabel = @"CustomTableViewCellLabelLabel";
static NSString * const reuseIdentifierButton = @"CustomTableViewCellButton";
static NSString * const reuseIdentifierDisputeDetail = @"CustomTableViewCellDisputeDetail";
static NSString * const reuseIdentifierLabelRemark = @"CustomTableViewCellLabelRemark";



@synthesize tbvData;
@synthesize receipt;
@synthesize topViewHeight;
@synthesize bottomViewHeight;
@synthesize lblNavTitle;
@synthesize btnShowPrintButton;


- (IBAction)showPrintButton:(id)sender
{
    if([Utility showPrintButton])
    {
        [btnShowPrintButton setBackgroundImage:[UIImage imageNamed:@"printerGreenNo.png"] forState:UIControlStateNormal];
        [Utility setShowPrintButton:NO];
    }
    else
    {
        [btnShowPrintButton setBackgroundImage:[UIImage imageNamed:@"printerGreen.png"] forState:UIControlStateNormal];
        [Utility setShowPrintButton:YES];
    }
    [tbvData reloadData];
}

-(IBAction)unwindToOrderDetail:(UIStoryboardSegue *)segue
{
    NSIndexPath *indexPathSummary = [NSIndexPath indexPathForRow:0 inSection:0];
    CustomTableViewCellReceiptSummary *cellSummary = [tbvData cellForRowAtIndexPath:indexPathSummary];
    
    
    NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receipt.receiptID branchID:[Branch getCurrentBranch].branchID];
    orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[orderTakingList count]+2 inSection:0];
    CustomTableViewCellButton *cell = [cellSummary.tbvOrderDetail cellForRowAtIndexPath:indexPath];
    cell.btnValue.enabled = YES;
    

}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    bottomViewHeight.constant = window.safeAreaInsets.bottom;
    
    float topPadding = window.safeAreaInsets.top;
    topViewHeight.constant = topPadding == 0?20:topPadding;
}

-(void)loadView
{
    [super loadView];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    NSDate *maxReceiptModifiedDate = [Receipt getMaxModifiedDateWithBranchID:[Branch getCurrentBranch].branchID];
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    [self.homeModel downloadItems:dbReceiptMaxModifiedDate withData:@[[Branch getCurrentBranch], maxReceiptModifiedDate]];

    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSString *title = [Setting getValue:@"063t" example:@"รายละเอียดการสั่งอาหาร"];
    lblNavTitle.text = title;
    tbvData.delegate = self;
    tbvData.dataSource = self;
    tbvData.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierReceiptSummary bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierReceiptSummary];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierTotal bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierTotal];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelLabel bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelLabel];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierButton bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierButton];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierDisputeDetail bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierDisputeDetail];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelRemark bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelRemark];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierOrderSummary bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierOrderSummary];
    }
    
    
    
    if([Utility showPrintButton])
    {
        [btnShowPrintButton setBackgroundImage:[UIImage imageNamed:@"printerGreen.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btnShowPrintButton setBackgroundImage:[UIImage imageNamed:@"printerGreenNo.png"] forState:UIControlStateNormal];
    }
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if([tableView isEqual:tbvData])
    {
        return 4;
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
            return 10;//remark,total items,specialPriceDiscount,discount,after discount,service charge,vat,net total,before vat,pay by
        }
        else if(section == 2)
        {
            if(receipt.status == 2 || receipt.status == 5 || receipt.status == 6)
            {
                return 2;
            }
            else if(receipt.status == 7)
            {
                return 1+3;
            }
            else if(receipt.status == 8)
            {
                return 1+4;
            }
            else if(receipt.status == 9 || receipt.status == 10 || receipt.status == 11)
            {
                return 1+1;
            }
            else if(receipt.status == 12)
            {
                return 1+1;
            }
            else if(receipt.status == 13)
            {
                return 1+4;
            }
            else if(receipt.status == 14)
            {
                return 1+1;
            }
        }
        else if(section == 3)
        {
            return 1;
        }
    }
    else
    {
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receipt.receiptID branchID:[Branch getCurrentBranch].branchID];
        orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
        
        
        
        return [orderTakingList count];
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
            CustomTableViewCellReceiptSummary *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierReceiptSummary];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            UIColor *color = cSystem4;
            NSDictionary *attribute = @{NSForegroundColorAttributeName:color};
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Order no. #%@",receipt.receiptNoID] attributes:attribute];
            
            
            UIColor *color2 = cSystem2;
            NSDictionary *attribute2 = @{NSForegroundColorAttributeName:color2};
            NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:@" (Buffet)" attributes:attribute2];
            if(receipt.buffetReceiptID)
            {
                [attrString appendAttributedString:attrString2];
            }
            

            NSString *message2 = [Setting getValue:@"007m" example:@"Table: %@"];
            CustomerTable *customerTable = [CustomerTable getCustomerTable:receipt.customerTableID];
            cell.lblReceiptNo.attributedText = attrString;
            cell.lblReceiptDate.text = [Utility dateToString:receipt.modifiedDate toFormat:@"d MMM yy HH:mm"];
            cell.lblBranchName.text = [NSString stringWithFormat:message2,customerTable.tableName];
            cell.lblBranchName.textColor = cSystem1;
            
            
            
            
            {
                UINib *nib = [UINib nibWithNibName:reuseIdentifierOrderSummary bundle:nil];
                [cell.tbvOrderDetail registerNib:nib forCellReuseIdentifier:reuseIdentifierOrderSummary];
            }
            
            
            cell.tbvOrderDetail.separatorColor = [UIColor clearColor];
            cell.tbvOrderDetail.scrollEnabled = NO;
            cell.tbvOrderDetail.delegate = self;
            cell.tbvOrderDetail.dataSource = self;
            cell.tbvOrderDetail.tag = receipt.receiptID;
            [cell.tbvOrderDetail reloadData];
            
            
            
            
            if(receipt.toBeProcessing)
            {
                cell.indicator.alpha = 1;
                [cell.indicator startAnimating];
                cell.indicator.hidden = NO;
            }
            else
            {
                cell.indicator.alpha = 0;
                [cell.indicator stopAnimating];
                cell.indicator.hidden = YES;
            }
            
            cell.btnOrderItAgain.backgroundColor = cSystem2;
            if(receipt.status == 2)
            {
                NSString *message = [Setting getValue:@"008m" example:@"ส่งเข้าครัว"];
                cell.btnOrderItAgain.hidden = NO;
                [cell.btnOrderItAgain removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
                [cell.btnOrderItAgain addTarget:self action:@selector(sendToKitchen:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnOrderItAgain setTitle:message forState:UIControlStateNormal];
                [self setButtonDesign:cell.btnOrderItAgain];
            }
            else if(receipt.status == 5)
            {
                NSString *message = [Setting getValue:@"009m" example:@"เสิร์ฟ"];
                cell.btnOrderItAgain.hidden = NO;
                [cell.btnOrderItAgain removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
                [cell.btnOrderItAgain addTarget:self action:@selector(deliver:) forControlEvents:UIControlEventTouchUpInside];
                [cell.btnOrderItAgain setTitle:message forState:UIControlStateNormal];
                [self setButtonDesign:cell.btnOrderItAgain];
            }
            else
            {
                cell.btnOrderItAgain.hidden = YES;
            }
            
            
            return cell;
        }
        else if(section == 1)
        {
            NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receipt.receiptID branchID:[Branch getCurrentBranch].branchID];
            
            if(item == 0)
            {
                CustomTableViewCellLabelRemark *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelRemark];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                if([Utility isStringEmpty:receipt.remark])
                {
                    cell.lblText.attributedText = [self setAttributedString:@"" text:receipt.remark];
                }
                else
                {
                    NSString *message = [Setting getValue:@"013m" example:@"หมายเหตุ: "];
                    cell.lblText.attributedText = [self setAttributedString:message text:receipt.remark];
                }
                [cell.lblText sizeToFit];
                cell.lblTextHeight.constant = cell.lblText.frame.size.height;
                
                return cell;
                
            }
            else
            {
                Branch *branch = [Branch getCurrentBranch];
                switch (item)
                {
                    case 1:
                    {
                        CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        NSString *message = [Setting getValue:@"064m" example:@"%ld รายการ"];
                        NSString *strTitle = [NSString stringWithFormat:message,[orderTakingList count]];
                        NSString *strTotal = [Utility formatDecimal:[OrderTaking getSumSpecialPrice:orderTakingList] withMinFraction:2 andMaxFraction:2];
                        strTotal = [Utility addPrefixBahtSymbol:strTotal];
                        cell.lblTitle.text = strTitle;
                        cell.lblAmount.text = strTotal;
                        cell.vwTopBorder.hidden = YES;
                        cell.lblTitle.textColor = cSystem4;
                        cell.lblTitle.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15.0f];
                        cell.lblAmount.textColor = cSystem1;
                        cell.lblAmount.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15.0f];
                        cell.hidden = NO;
                        
                        
                        return  cell;
                    }
                    break;
                    case 2:
                    {
                        //specialDiscount
                        CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
                        
                        NSString *strAmount = [Utility formatDecimal:receipt.specialPriceDiscount withMinFraction:2 andMaxFraction:2];
                        strAmount = [Utility addPrefixBahtSymbol:strAmount];
                        strAmount = [NSString stringWithFormat:@"-%@",strAmount];
                        
                        
                        cell.lblTitle.text = @"ส่วนลด";
                        cell.lblAmount.text = strAmount;
                        cell.vwTopBorder.hidden = YES;
                        cell.lblTitle.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                        cell.lblTitle.textColor = [UIColor darkGrayColor];
                        cell.lblAmount.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                        cell.lblAmount.textColor = cSystem2;
                        cell.hidden = receipt.discountAmount == 0;
                        
                        
                        return cell;
                    }
                    break;
                    case 3:
                    {
                        //discount
                        CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        NSString *message = [Setting getValue:@"068m" example:@"ส่วนลด %@%%"];
                        NSString *message2 = [Setting getValue:@"069m" example:@"ส่วนลด"];
                        NSString *strDiscount = [Utility formatDecimal:receipt.discountAmount withMinFraction:0 andMaxFraction:2];
                        strDiscount = [NSString stringWithFormat:message,strDiscount];
                        
                        NSString *strAmount = [Utility formatDecimal:receipt.discountValue withMinFraction:2 andMaxFraction:2];
                        strAmount = [Utility addPrefixBahtSymbol:strAmount];
                        strAmount = [NSString stringWithFormat:@"-%@",strAmount];
                        
                        
                        cell.lblTitle.text = receipt.discountType==1?message2:strDiscount;
                        cell.lblAmount.text = strAmount;
                        cell.vwTopBorder.hidden = YES;
                        cell.lblTitle.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                        cell.lblTitle.textColor = [UIColor darkGrayColor];
                        cell.lblAmount.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                        cell.lblAmount.textColor = cSystem2;
                        cell.hidden = receipt.discountAmount == 0;
                        
                        
                        return cell;
                    }
                    break;
                    case 4:
                    {
                        //after discount
                        CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        NSString *strTitle = branch.priceIncludeVat?@"ยอดรวม (รวม Vat)":@"ยอดรวม";
                        NSString *strTotal = [Utility formatDecimal:[OrderTaking getSumSpecialPrice:orderTakingList]-receipt.discountValue withMinFraction:2 andMaxFraction:2];
                        strTotal = [Utility addPrefixBahtSymbol:strTotal];
                        cell.lblTitle.text = strTitle;
                        cell.lblAmount.text = strTotal;
                        cell.vwTopBorder.hidden = YES;
                        cell.lblTitle.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                        cell.lblTitle.textColor = [UIColor darkGrayColor];
                        cell.lblAmount.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
                        cell.lblAmount.textColor = cSystem2;
                        cell.hidden = NO;
                        
                        
                        return  cell;
                    }
                    break;
                    case 5:
                    {
                        //service charge
                        CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        NSString *message = [Setting getValue:@"071m" example:@"Service charge %@%%"];
                        NSString *strServiceChargePercent = [Utility formatDecimal:receipt.serviceChargePercent withMinFraction:0 andMaxFraction:2];
                        strServiceChargePercent = [NSString stringWithFormat:message,strServiceChargePercent];
                        
                        NSString *strAmount = [Utility formatDecimal:receipt.serviceChargeValue withMinFraction:2 andMaxFraction:2];
                        strAmount = [Utility addPrefixBahtSymbol:strAmount];
                        
                        cell.lblTitle.text = strServiceChargePercent;
                        cell.lblAmount.text = strAmount;
                        cell.vwTopBorder.hidden = YES;
                        cell.lblTitle.textColor = cSystem4;
                        cell.lblTitle.font = [UIFont fontWithName:@"Prompt-Regular" size:15.0f];
                        cell.lblAmount.textColor = cSystem4;
                        cell.lblAmount.font = [UIFont fontWithName:@"Prompt-Regular" size:15.0f];
                        cell.hidden = branch.serviceChargePercent == 0;
                        
                        
                        return cell;
                    }
                    break;
                    case 6:
                    {
                        //vat
                        CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        NSString *message = [Setting getValue:@"065m" example:@"Vat %@%%"];
                        NSString *message2 = [Setting getValue:@"066m" example:@"Vat"];
                        NSString *strPercentVat = [Utility formatDecimal:receipt.vatPercent withMinFraction:0 andMaxFraction:2];
                        strPercentVat = [NSString stringWithFormat:message,strPercentVat];
                        
                        NSString *strAmount = [Utility formatDecimal:receipt.vatValue withMinFraction:2 andMaxFraction:2];
                        strAmount = [Utility addPrefixBahtSymbol:strAmount];
                        
                        cell.lblTitle.text = receipt.vatPercent==0?message2:strPercentVat;
                        cell.lblAmount.text = strAmount;
                        cell.vwTopBorder.hidden = YES;
                        cell.lblTitle.textColor = cSystem4;
                        cell.lblTitle.font = [UIFont fontWithName:@"Prompt-Regular" size:15.0f];
                        cell.lblAmount.textColor = cSystem4;
                        cell.lblAmount.font = [UIFont fontWithName:@"Prompt-Regular" size:15.0f];
                        cell.hidden = branch.percentVat == 0;
                        
                        
                        return cell;
                    }
                    break;
                    case 7:
                    {
                        //net total
                        CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        NSString *message = [Setting getValue:@"067m" example:@"ยอดรวมทั้งสิ้น"];
                        float netTotalAmount = receipt.cashAmount+receipt.creditCardAmount+receipt.transferAmount;
                        NSString *strAmount = [Utility formatDecimal:netTotalAmount withMinFraction:2 andMaxFraction:2];
                        strAmount = [Utility addPrefixBahtSymbol:strAmount];
                        cell.lblAmount.text = strAmount;
                        cell.lblAmount.textColor = cSystem1;
                        cell.lblAmount.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15.0f];
                        cell.lblTitle.text = message;
                        cell.lblTitle.textColor = cSystem4;
                        cell.lblTitle.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15.0f];
                        cell.vwTopBorder.hidden = YES;
                        cell.hidden = branch.serviceChargePercent+branch.percentVat == 0;
                        
                        
                        return cell;
                    }
                    break;
                    case 8:
                    {
                        //beforeVat
                        CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                       
                        NSString *strAmount = [Utility formatDecimal:receipt.beforeVat withMinFraction:2 andMaxFraction:2];
                        strAmount = [Utility addPrefixBahtSymbol:strAmount];
                        
                        cell.lblTitle.text = @"ราคารวมก่อน Vat";
                        cell.lblAmount.text = strAmount;
                        cell.vwTopBorder.hidden = YES;
                        cell.lblTitle.textColor = cSystem4;
                        cell.lblTitle.font = [UIFont fontWithName:@"Prompt-Regular" size:15.0f];
                        cell.lblAmount.textColor = cSystem4;
                        cell.lblAmount.font = [UIFont fontWithName:@"Prompt-Regular" size:15.0f];
                        cell.hidden = !((branch.serviceChargePercent>0 && branch.percentVat>0) || (branch.serviceChargePercent == 0 && branch.percentVat>0 && branch.priceIncludeVat));
                        
                        
                        return cell;
                    }
                    break;
                    case 9:
                    {
                        //pay by
                        CustomTableViewCellLabelLabel *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelLabel];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        UIColor *color = cSystem4;
                        UIFont *font = [UIFont fontWithName:@"Prompt-SemiBold" size:14.0f];
                        NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
                        NSMutableAttributedString *attrStringStatus = [[NSMutableAttributedString alloc] initWithString:[Receipt maskCreditCardNo:receipt] attributes:attribute];
                        
                        
                        UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:14.0f];
                        UIColor *color2 = cSystem4;
                        NSDictionary *attribute2 = @{NSForegroundColorAttributeName:color2 ,NSFontAttributeName: font2};
                        NSMutableAttributedString *attrStringStatusLabel = [[NSMutableAttributedString alloc] initWithString:@"Payment method " attributes:attribute2];
                        
                        
                        [attrStringStatusLabel appendAttributedString:attrStringStatus];
                        cell.lblText.attributedText = attrStringStatusLabel;
                        [cell.lblText sizeToFit];
                        cell.lblTextWidthConstant.constant = cell.lblText.frame.size.width;
                        
                        
                        cell.lblValue.text = @"";
                        

                        return cell;
                    }
                    break;
                }
            }
        }
        else if(section == 2)
        {
            if(item == 0)
            {
                CustomTableViewCellLabelLabel *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelLabel];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                NSString *strStatus = [Receipt getStrStatus:receipt];
                UIColor *color = cSystem2;
                
                
                
                UIFont *font = [UIFont fontWithName:@"Prompt-SemiBold" size:14.0f];
                NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
                NSMutableAttributedString *attrStringStatus = [[NSMutableAttributedString alloc] initWithString:strStatus attributes:attribute];
                
                
                UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:14.0f];
                UIColor *color2 = cSystem4;
                NSDictionary *attribute2 = @{NSForegroundColorAttributeName:color2 ,NSFontAttributeName: font2};
                NSMutableAttributedString *attrStringStatusLabel = [[NSMutableAttributedString alloc] initWithString:@"Status: " attributes:attribute2];
                
                
                [attrStringStatusLabel appendAttributedString:attrStringStatus];
                cell.lblValue.attributedText = attrStringStatusLabel;
                cell.lblText.text = @"";
                cell.lblTextWidthConstant.constant = 0;
                
                
                
                return cell;
            }
            else
            {
                if(receipt.status == 2 || receipt.status == 5 || receipt.status == 6)
                {
                    if(item == 1)
                    {
                        CustomTableViewCellButton *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierButton];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        

                        if(receipt.status == 2)
                        {
                            NSDate *endDate = [Utility addDay:receipt.receiptDate numberOfDay:7];
                            NSComparisonResult result = [[Utility currentDateTime] compare:endDate];
                            cell.btnValue.hidden = result != NSOrderedAscending;
                            
                            
                            NSString *title = [Setting getValue:@"018t" example:@"ยกเลิก & คืนเงิน"];
                            [cell.btnValue setTitle:title forState:UIControlStateNormal];
                            cell.btnValue.backgroundColor = cSystem2;
                            [cell.btnValue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            [cell.btnValue removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
                            [cell.btnValue addTarget:self action:@selector(moneyRefund:) forControlEvents:UIControlEventTouchUpInside];
                            [self setButtonDesign:cell.btnValue];
                        }
                        else if(receipt.status == 5 || receipt.status == 6)
                        {
                            NSDate *endDate = [Utility addDay:receipt.receiptDate numberOfDay:7];
                            NSComparisonResult result = [[Utility currentDateTime] compare:endDate];
                            cell.btnValue.hidden = result != NSOrderedAscending;
                            
                            
                            NSString *title = [Setting getValue:@"019t" example:@"ส่งคำร้อง & คืนเงิน"];
                            [cell.btnValue setTitle:title forState:UIControlStateNormal];
                            cell.btnValue.backgroundColor = cSystem2;
                            [cell.btnValue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            [cell.btnValue removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
                            [cell.btnValue addTarget:self action:@selector(moneyRefund:) forControlEvents:UIControlEventTouchUpInside];
                            [self setButtonDesign:cell.btnValue];
                        }
                        
                        
                        return cell;
                    }
                }
                else if(receipt.status == 7)
                {
                    if(item == 1)
                    {
                        CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        NSString *message = [Setting getValue:@"072m" example:@"ลูกค้าของคุณต้องการยกเลิกบิลนี้  ด้วยเหตุผลด้านล่างนี้ กรุณากด Confirm เพื่อ Refund เงินคืนลูกค้า"];
                        cell.lblRemark.textColor = cSystem1;
                        cell.lblRemark.text = message;
                        [cell.lblRemark sizeToFit];
                        cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                        
                        
                        
                        NSString *message2 = [Setting getValue:@"073m" example:@"เหตุผล: "];
                        Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:1];
                        DisputeReason *disputeReason = [DisputeReason getDisputeReason:dispute.disputeReasonID];
                        cell.lblReason.attributedText = [self setAttributedString:message2 text:disputeReason.text];
                        [cell.lblReason sizeToFit];
                        cell.lblReasonHeight.constant = cell.lblReason.frame.size.height;
                        
                        
                        
                        NSString *message3 = [Setting getValue:@"074m" example:@"จำนวนเงินที่ขอคืน: "];
                        float totalAmount = [Receipt getTotalAmount:receipt];
                        NSString *strTotalAmount = [Utility formatDecimal:totalAmount withMinFraction:2 andMaxFraction:2];
                        strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                        cell.lblAmount.attributedText = [self setAttributedString:message3 text:strTotalAmount];
                        
                        
                        cell.lblReasonDetailHeight.constant = 0;
                        cell.lblReasonDetailTop.constant = 0;
                        
                        
                        NSString *message4 = [Setting getValue:@"075m" example:@"เบอร์โทรติดต่อ: "];
                        cell.lblPhoneNo.attributedText = [self setAttributedString:message4 text:[Utility setPhoneNoFormat:dispute.phoneNo]];
                        [cell.lblPhoneNo sizeToFit];
                        cell.lblPhoneNoHeight.constant = cell.lblPhoneNo.frame.size.height;
                        
                        return cell;
                    }
                    else if(item == 2)
                    {
                        CustomTableViewCellButton *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierButton];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        NSString *title = [Setting getValue:@"076t" example:@"Confirm"];
                        cell.btnValue.hidden = NO;
                        [cell.btnValue setTitle:title forState:UIControlStateNormal];
                        cell.btnValue.backgroundColor = cSystem2;
                        [cell.btnValue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [cell.btnValue removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
                        [cell.btnValue addTarget:self action:@selector(confirmCancel:) forControlEvents:UIControlEventTouchUpInside];
                        [self setButtonDesign:cell.btnValue];
                        
                        
                        return cell;
                    }
                    else if(item == 3)
                    {
                        CustomTableViewCellButton *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierButton];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        NSString *title = [Setting getValue:@"077t" example:@"Cancel"];
                        cell.btnValue.hidden = NO;
                        [cell.btnValue setTitle:title forState:UIControlStateNormal];
                        cell.btnValue.backgroundColor = cSystem4_10;
                        [cell.btnValue setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                        [cell.btnValue removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
                        [cell.btnValue addTarget:self action:@selector(cancelCancel:) forControlEvents:UIControlEventTouchUpInside];
                        [self setButtonDesign:cell.btnValue];
                        
                        return cell;
                    }
                }
                else if(receipt.status == 8)
                {
                    if(item == 1)
                    {
                        CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        NSString *message = [Setting getValue:@"078m" example:@"ลูกค้าของคุณ Open dispute ด้วยเหตุผลด้านล่างนี้ กรุณากด Confirm เพื่อ Refund เงินคืนลูกค้า หรือหากต้องการแก้ไขรายการกรุณากด Negotiate"];
                        cell.lblRemark.textColor = cSystem1;
                        cell.lblRemark.text = message;
                        [cell.lblRemark sizeToFit];
                        cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                        
                        
                        
                        NSString *message2 = [Setting getValue:@"073m" example:@"เหตุผล: "];
                        Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:2];
                        DisputeReason *disputeReason = [DisputeReason getDisputeReason:dispute.disputeReasonID];
                        cell.lblReason.attributedText = [self setAttributedString:message2 text:disputeReason.text];
                        [cell.lblReason sizeToFit];
                        cell.lblReasonHeight.constant = cell.lblReason.frame.size.height;
                        
                        
                        
                        NSString *message3 = [Setting getValue:@"074m" example:@"จำนวนเงินที่ขอคืน: "];
                        NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                        strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                        cell.lblAmount.attributedText = [self setAttributedString:message3 text:strTotalAmount];
                        
                        
                        NSString *message4 = [Setting getValue:@"079m" example:@"รายละเอียดเหตุผล: "];
                        cell.lblReasonDetail.attributedText = [self setAttributedString:message4 text:dispute.detail];
                        [cell.lblReasonDetail sizeToFit];
                        cell.lblReasonDetailTop.constant = 8;
                        cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                        
                        
                        NSString *message5 = [Setting getValue:@"075m" example:@"เบอร์โทรติดต่อ: "];
                        cell.lblPhoneNo.attributedText = [self setAttributedString:message5 text:[Utility setPhoneNoFormat:dispute.phoneNo]];
                        [cell.lblPhoneNo sizeToFit];
                        cell.lblPhoneNoHeight.constant = cell.lblPhoneNo.frame.size.height;
                        
                        return cell;
                    }
                    else if(item == 2)
                    {
                        CustomTableViewCellButton *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierButton];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        NSString *title = [Setting getValue:@"076t" example:@"Confirm"];
                        cell.btnValue.hidden = NO;
                        [cell.btnValue setTitle:title forState:UIControlStateNormal];
                        cell.btnValue.backgroundColor = cSystem2;
                        [cell.btnValue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [cell.btnValue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [cell.btnValue removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
                        [cell.btnValue addTarget:self action:@selector(confirmDispute:) forControlEvents:UIControlEventTouchUpInside];
                        [self setButtonDesign:cell.btnValue];
                        
                        return cell;
                    }
                    else if(item == 3)
                    {
                        CustomTableViewCellButton *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierButton];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        NSString *title = [Setting getValue:@"080t" example:@"Negotiate"];
                        cell.btnValue.hidden = NO;
                        [cell.btnValue setTitle:title forState:UIControlStateNormal];
                        cell.btnValue.backgroundColor = cSystem2;
                        [cell.btnValue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [cell.btnValue removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
                        [cell.btnValue addTarget:self action:@selector(negotiate:) forControlEvents:UIControlEventTouchUpInside];
                        [self setButtonDesign:cell.btnValue];
                        
                        return cell;
                    }
                    else if(item == 4)
                    {
                        CustomTableViewCellButton *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierButton];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        NSString *title = [Setting getValue:@"077t" example:@"Cancel"];
                        cell.btnValue.hidden = NO;
                        [cell.btnValue setTitle:title forState:UIControlStateNormal];
                        cell.btnValue.backgroundColor = cSystem4_10;
                        [cell.btnValue setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                        [cell.btnValue removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
                        [cell.btnValue addTarget:self action:@selector(cancelDispute:) forControlEvents:UIControlEventTouchUpInside];
                        [self setButtonDesign:cell.btnValue];
                        
                        return cell;
                    }
                }
                else if(receipt.status == 9)
                {
                    CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                    
                    NSString *message = [Setting getValue:@"081m" example:@"คำร้องขอยกเลิกออเดอร์เสร็จสิ้น"];
                    cell.lblRemark.textColor = cSystem1;
                    cell.lblRemark.text = message;
                    [cell.lblRemark sizeToFit];
                    cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                    
                    
                    
                    NSString *message2 = [Setting getValue:@"073m" example:@"เหตุผล: "];
                    Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:1];
                    if(!dispute)
                    {
                        dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:3];
                    }
                    DisputeReason *disputeReason = [DisputeReason getDisputeReason:dispute.disputeReasonID];
                    cell.lblReason.attributedText = [self setAttributedString:message2 text:disputeReason.text];
                    [cell.lblReason sizeToFit];
                    cell.lblReasonHeight.constant = cell.lblReason.frame.size.height;
                    
                    
                    
                    NSString *message3 = [Setting getValue:@"074m" example:@"จำนวนเงินที่ขอคืน: "];
                    float totalAmount = [Receipt getTotalAmount:receipt];
                    NSString *strTotalAmount = [Utility formatDecimal:totalAmount withMinFraction:2 andMaxFraction:2];
                    strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                    cell.lblAmount.attributedText = [self setAttributedString:message3 text:strTotalAmount];
                    
                    
                    cell.lblReasonDetailHeight.constant = 0;
                    cell.lblReasonDetailTop.constant = 0;
                    
                    
                    NSString *message4 = [Setting getValue:@"075m" example:@"เบอร์โทรติดต่อ: "];
                    cell.lblPhoneNo.attributedText = [self setAttributedString:message4 text:[Utility setPhoneNoFormat:dispute.phoneNo]];
                    [cell.lblPhoneNo sizeToFit];
                    cell.lblPhoneNoHeight.constant = cell.lblPhoneNo.frame.size.height;
                    
                    return cell;
                }
                else if(receipt.status == 10)
                {
                    CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                    
                    NSString *message = [Setting getValue:@"082m" example:@"กระบวนการ Open dispute เสร็จสิ้น"];
                    cell.lblRemark.textColor = cSystem1;
                    cell.lblRemark.text = message;
                    [cell.lblRemark sizeToFit];
                    cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                    
                    
                    
                    NSString *message2 = [Setting getValue:@"073m" example:@"เหตุผล: "];
                    Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:2];
                    if(!dispute)
                    {
                        dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:4];
                    }
                    DisputeReason *disputeReason = [DisputeReason getDisputeReason:dispute.disputeReasonID];
                    cell.lblReason.attributedText = [self setAttributedString:message2 text:disputeReason.text];
                    [cell.lblReason sizeToFit];
                    cell.lblReasonHeight.constant = cell.lblReason.frame.size.height;
                    
                    
                    
                    NSString *message3 = [Setting getValue:@"074m" example:@"จำนวนเงินที่ขอคืน: "];
                    NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                    strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                    cell.lblAmount.attributedText = [self setAttributedString:message3 text:strTotalAmount];
                    
                    
                    NSString *message4 = [Setting getValue:@"079m" example:@"รายละเอียดเหตุผล: "];
                    cell.lblReasonDetail.attributedText = [self setAttributedString:message4 text:dispute.detail];
                    [cell.lblReasonDetail sizeToFit];
                    cell.lblReasonDetailTop.constant = 8;
                    cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                    
                    
                    NSString *message5 = [Setting getValue:@"075m" example:@"เบอร์โทรติดต่อ: "];
                    cell.lblPhoneNo.attributedText = [self setAttributedString:message5 text:[Utility setPhoneNoFormat:dispute.phoneNo]];
                    [cell.lblPhoneNo sizeToFit];
                    cell.lblPhoneNoHeight.constant = cell.lblPhoneNo.frame.size.height;
                    
                    return cell;
                }
                else if(receipt.status == 11)
                {
                    CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                
                    NSString *message = [Setting getValue:@"083m" example:@"Open dispute ที่ส่งไปกำลังดำเนินการอยู่ จะมีเจ้าหน้าที่ติดต่อกลับไปภายใน 24 ชม."];
                    cell.lblRemark.textColor = cSystem1;
                    cell.lblRemark.text = message;
                    [cell.lblRemark sizeToFit];
                    cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                    
                    
                    
                    NSString *message2 = [Setting getValue:@"073m" example:@"เหตุผล: "];
                    NSInteger statusBeforeLast = [Receipt getStateBeforeLast:receipt];
                    if(statusBeforeLast == 8)
                    {
                        Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:2];
                        DisputeReason *disputeReason = [DisputeReason getDisputeReason:dispute.disputeReasonID];
                        cell.lblReason.attributedText = [self setAttributedString:message2 text:disputeReason.text];
                        [cell.lblReason sizeToFit];
                        cell.lblReasonHeight.constant = cell.lblReason.frame.size.height;
                        
                        
                        
                        NSString *message3 = [Setting getValue:@"074m" example:@"จำนวนเงินที่ขอคืน: "];
                        NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                        strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                        cell.lblAmount.attributedText = [self setAttributedString:message3 text:strTotalAmount];
                        
                        
                        NSString *message4 = [Setting getValue:@"079m" example:@"รายละเอียดเหตุผล: "];
                        cell.lblReasonDetail.attributedText = [self setAttributedString:message4 text:dispute.detail];
                        [cell.lblReasonDetail sizeToFit];
                        cell.lblReasonDetailTop.constant = 8;
                        cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                        
                        
                        NSString *message5 = [Setting getValue:@"075m" example:@"เบอร์โทรติดต่อ: "];
                        cell.lblPhoneNo.attributedText = [self setAttributedString:message5 text:[Utility setPhoneNoFormat:dispute.phoneNo]];
                        [cell.lblPhoneNo sizeToFit];
                        cell.lblPhoneNoHeight.constant = cell.lblPhoneNo.frame.size.height;
                    }
                    else if(statusBeforeLast == 12 || statusBeforeLast == 13)
                    {
                        Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:5];
                        cell.lblReasonTop.constant = 0;
                        cell.lblReasonHeight.constant = 0;
                        
                        
                        
                        NSString *message = [Setting getValue:@"074m" example:@"จำนวนเงินที่ขอคืน: "];
                        NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                        strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                        cell.lblAmount.attributedText = [self setAttributedString:message text:strTotalAmount];
                        
                        
                        NSString *message2 = [Setting getValue:@"079m" example:@"รายละเอียดเหตุผล: "];
                        cell.lblReasonDetail.attributedText = [self setAttributedString:message2 text:dispute.detail];
                        [cell.lblReasonDetail sizeToFit];
                        cell.lblReasonDetailTop.constant = 8;
                        cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                        
                        
                        cell.lblPhoneNoTop.constant = 0;
                        cell.lblPhoneNoHeight.constant = 0;
                    }
                    
                    return cell;
                }
                else if(receipt.status == 12)
                {
                    CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                    NSString *message = [Setting getValue:@"083m" example:@"Open dispute ได้มีการแก้ไขตามด้านล่าง โปรดรอการยืนยันจากลูกค้าสักครู่"];
                    cell.lblRemark.textColor = cSystem1;
                    cell.lblRemark.text = message;
                    [cell.lblRemark sizeToFit];
                    cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                    
                    
                    
                    Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:5];
                    cell.lblReasonTop.constant = 0;
                    cell.lblReasonHeight.constant = 0;
                    
                    
                    NSString *message2 = [Setting getValue:@"074m" example:@"จำนวนเงินที่ขอคืน: "];
                    NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                    strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                    cell.lblAmount.attributedText = [self setAttributedString:message2 text:strTotalAmount];
                    
                    
                    NSString *message3 = [Setting getValue:@"079m" example:@"รายละเอียดเหตุผล: "];
                    cell.lblReasonDetail.attributedText = [self setAttributedString:message3 text:dispute.detail];
                    [cell.lblReasonDetail sizeToFit];
                    cell.lblReasonDetailTop.constant = 8;
                    cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                    
                    
                    
                    cell.lblPhoneNoTop.constant = 0;
                    cell.lblPhoneNoHeight.constant = 0;
                    
                    return cell;
                }
                else if(receipt.status == 13)
                {
                    if(item == 1)
                    {
                        CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        NSString *message = [Setting getValue:@"084m" example:@"หลังจากคุยกับเจ้าหน้าที่ Jummum แล้ว มีการแก้ไขจำนวนเงิน refund ใหม่ ตามด้านล่างนี้ กรุณากด Confirm เพื่อ Refund เงินคืนลูกค้า หรือหากต้องการแก้ไขรายการกรุณากด Negotiate"];
                        cell.lblRemark.textColor = cSystem1;
                        cell.lblRemark.text = message;
                        [cell.lblRemark sizeToFit];
                        cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                        
                        
                        
                        Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:5];
                        cell.lblReasonTop.constant = 0;
                        cell.lblReasonHeight.constant = 0;
                        
                        
                        
                        NSString *message2 = [Setting getValue:@"074m" example:@"จำนวนเงินที่ขอคืน: "];
                        NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                        strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                        cell.lblAmount.attributedText = [self setAttributedString:message2 text:strTotalAmount];
                        
                        
                        NSString *message3 = [Setting getValue:@"079m" example:@"รายละเอียดเหตุผล: "];
                        cell.lblReasonDetail.attributedText = [self setAttributedString:message3 text:dispute.detail];
                        [cell.lblReasonDetail sizeToFit];
                        cell.lblReasonDetailTop.constant = 8;
                        cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                        
                        
                        cell.lblPhoneNoTop.constant = 0;
                        cell.lblPhoneNoHeight.constant = 0;
                        
                        
                        return cell;
                    }
                    else if(item == 2)
                    {
                        CustomTableViewCellButton *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierButton];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        NSString *title = [Setting getValue:@"076t" example:@"Confirm"];
                        cell.btnValue.hidden = NO;
                        [cell.btnValue setTitle:title forState:UIControlStateNormal];
                        cell.btnValue.backgroundColor = cSystem2;
                        [cell.btnValue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [cell.btnValue removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
                        [cell.btnValue addTarget:self action:@selector(confirmNegotiate:) forControlEvents:UIControlEventTouchUpInside];
                        [self setButtonDesign:cell.btnValue];
                        
                        return cell;
                    }
                    else if(item == 3)
                    {
                        CustomTableViewCellButton *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierButton];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        NSString *title = [Setting getValue:@"080t" example:@"Negotiate"];
                        cell.btnValue.hidden = NO;
                        [cell.btnValue setTitle:title forState:UIControlStateNormal];
                        cell.btnValue.backgroundColor = cSystem2;
                        [cell.btnValue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [cell.btnValue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [cell.btnValue removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
                        [cell.btnValue addTarget:self action:@selector(negotiate:) forControlEvents:UIControlEventTouchUpInside];
                        [self setButtonDesign:cell.btnValue];
                        
                        return cell;
                    }
                    else if(item == 4)
                    {
                        CustomTableViewCellButton *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierButton];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                        
                        NSString *title = [Setting getValue:@"077t" example:@"Cancel"];
                        cell.btnValue.hidden = NO;
                        [cell.btnValue setTitle:title forState:UIControlStateNormal];
                        cell.btnValue.backgroundColor = cSystem4_10;
                        [cell.btnValue setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                        [cell.btnValue removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
                        [cell.btnValue addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
                        [self setButtonDesign:cell.btnValue];
                        
                        
                        return cell;
                    }
                }
                else if(receipt.status == 14)
                {
                    CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                    NSString *message = [Setting getValue:@"085m" example:@"กระบวนการ Open dispute ดำเนินการเสร็จสิ้นแล้ว"];
                    cell.lblRemark.textColor = cSystem1;
                    cell.lblRemark.text = message;
                    [cell.lblRemark sizeToFit];
                    cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                    
                    
                    
                    Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:5];
                    cell.lblReasonTop.constant = 0;
                    cell.lblReasonHeight.constant = 0;
                    
                    
                    
                    NSString *message2 = [Setting getValue:@"074m" example:@"จำนวนเงินที่ขอคืน: "];
                    NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                    strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                    cell.lblAmount.attributedText = [self setAttributedString:message2 text:strTotalAmount];
                    
                    
                    
                    
                    NSString *message3 = [Setting getValue:@"079m" example:@"รายละเอียดเหตุผล: "];
                    cell.lblReasonDetail.attributedText = [self setAttributedString:message3 text:dispute.detail];
                    [cell.lblReasonDetail sizeToFit];
                    cell.lblReasonDetailTop.constant = 8;
                    cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                    
                    
                    cell.lblPhoneNoTop.constant = 0;
                    cell.lblPhoneNoHeight.constant = 0;
                    
                    return cell;
                }
            }
        }
        else if(section == 3)
        {
            CustomTableViewCellButton *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierButton];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            NSString *title = [Setting getValue:@"106t" example:@"พิมพ์"];
            cell.btnValue.tag = receipt.receiptID;
            cell.btnValue.hidden = ![Utility showPrintButton];
            cell.btnValue.backgroundColor = cSystem1;
            [cell.btnValue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell.btnValue setTitle:title forState:UIControlStateNormal];
            [cell.btnValue addTarget:self action:@selector(print:) forControlEvents:UIControlEventTouchUpInside];
            [self setButtonDesign:cell.btnValue];
            
            
            if(receipt.toBePrinting)
            {
                cell.indicator.alpha = 1;
                [cell.indicator startAnimating];
                cell.indicator.hidden = NO;
                cell.btnValue.enabled = NO;
            }
            else
            {
                cell.indicator.alpha = 0;
                [cell.indicator stopAnimating];
                cell.indicator.hidden = YES;
                cell.btnValue.enabled = YES;
            }
            
            
            return cell;
        }
    }
    else
    {
        NSInteger receiptID = tableView.tag;
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receiptID branchID:[Branch getCurrentBranch].branchID];
        orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
        
        
        if(item < [orderTakingList count])
        {
            CustomTableViewCellOrderSummary *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierOrderSummary];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            OrderTaking *orderTaking = orderTakingList[item];
            Menu *menu = [Menu getMenu:orderTaking.menuID];
            cell.lblQuantity.text = [Utility formatDecimal:orderTaking.quantity withMinFraction:0 andMaxFraction:0];
            
            
            //menu
            if(orderTaking.takeAway)
            {
                NSString *message = [Setting getValue:@"010m" example:@"ใส่ห่อ"];
                UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:15];
                NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:message
                                                                                               attributes:attribute];
                
                NSDictionary *attribute2 = @{NSFontAttributeName: font};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",menu.titleThai] attributes:attribute2];
                
                
                [attrString appendAttributedString:attrString2];
                cell.lblMenuName.attributedText = attrString;
            }
            else
            {
                cell.lblMenuName.text = menu.titleThai;
            }
            [cell.lblMenuName sizeToFit];
            cell.lblMenuNameHeight.constant = cell.lblMenuName.frame.size.height;
   
            
            //note
            NSMutableAttributedString *strAllNote;
            NSMutableAttributedString *attrStringRemove;
            NSMutableAttributedString *attrStringAdd;
            NSString *strRemoveTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:-1];
            NSString *strAddTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:1];
            if(![Utility isStringEmpty:strRemoveTypeNote])
            {
                NSString *message = [Setting getValue:@"011m" example:@"ไม่ใส่"];
                UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:11];
                NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                attrStringRemove = [[NSMutableAttributedString alloc] initWithString:message attributes:attribute];
                
                
                UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:11];
                NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strRemoveTypeNote] attributes:attribute2];
                
                
                [attrStringRemove appendAttributedString:attrString2];
            }
            if(![Utility isStringEmpty:strAddTypeNote])
            {
                NSString *message = [Setting getValue:@"012m" example:@"เพิ่ม"];
                UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:11];
                NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                attrStringAdd = [[NSMutableAttributedString alloc] initWithString:message attributes:attribute];
                
                
                UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:11];
                NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strAddTypeNote] attributes:attribute2];
                
                
                [attrStringAdd appendAttributedString:attrString2];
            }
            if(![Utility isStringEmpty:strRemoveTypeNote])
            {
                strAllNote = attrStringRemove;
                if(![Utility isStringEmpty:strAddTypeNote])
                {
                    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"\n" attributes:nil];
                    [strAllNote appendAttributedString:attrString];
                    [strAllNote appendAttributedString:attrStringAdd];
                }
            }
            else
            {
                if(![Utility isStringEmpty:strAddTypeNote])
                {
                    strAllNote = attrStringAdd;
                }
                else
                {
                    strAllNote = [[NSMutableAttributedString alloc]init];
                }
            }
            cell.lblNote.attributedText = strAllNote;
            [cell.lblNote sizeToFit];
            cell.lblNoteHeight.constant = cell.lblNote.frame.size.height;
            
            
            
            float totalAmount = orderTaking.specialPrice * orderTaking.quantity;
            NSString *strTotalAmount = [Utility formatDecimal:totalAmount withMinFraction:2 andMaxFraction:2];
            cell.lblTotalAmount.text = [Utility addPrefixBahtSymbol:strTotalAmount];
            
            
            
            
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
            //load order มาโชว์
            NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receipt.receiptID branchID:[Branch getCurrentBranch].branchID];
            orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
            float sumHeight = 0;
            for(int i=0; i<[orderTakingList count]; i++)
            {
                CustomTableViewCellOrderSummary *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierOrderSummary];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                OrderTaking *orderTaking = orderTakingList[i];
                Menu *menu = [Menu getMenu:orderTaking.menuID];
                cell.lblQuantity.text = [Utility formatDecimal:orderTaking.quantity withMinFraction:0 andMaxFraction:0];
                
                
                //menu
                if(orderTaking.takeAway)
                {
                    NSString *message = [Setting getValue:@"010m" example:@"ใส่ห่อ"];
                    UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:15.0f];
                    NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
                    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:message
                                                                                                   attributes:attribute];
                    
                    NSDictionary *attribute2 = @{NSFontAttributeName: font};
                    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",menu.titleThai] attributes:attribute2];
                    
                    
                    [attrString appendAttributedString:attrString2];
                    cell.lblMenuName.attributedText = attrString;
                }
                else
                {
                    cell.lblMenuName.text = menu.titleThai;
                }
                [cell.lblMenuName sizeToFit];
                cell.lblMenuNameHeight.constant = cell.lblMenuName.frame.size.height;
  
                
                //note
                NSMutableAttributedString *strAllNote;
                NSMutableAttributedString *attrStringRemove;
                NSMutableAttributedString *attrStringAdd;
                NSString *strRemoveTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:-1];
                NSString *strAddTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:1];
                if(![Utility isStringEmpty:strRemoveTypeNote])
                {
                    NSString *message = [Setting getValue:@"011m" example:@"ไม่ใส่"];
                    UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:13.0f];
                    NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                    attrStringRemove = [[NSMutableAttributedString alloc] initWithString:message attributes:attribute];
                    
                    
                    UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:13.0f];
                    NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strRemoveTypeNote] attributes:attribute2];
                    
                    
                    [attrStringRemove appendAttributedString:attrString2];
                }
                if(![Utility isStringEmpty:strAddTypeNote])
                {
                    NSString *message = [Setting getValue:@"012m" example:@"เพิ่ม"];
                    UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:13.0f];
                    NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                    attrStringAdd = [[NSMutableAttributedString alloc] initWithString:message attributes:attribute];
                    
                    
                    
                    UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:13.0f];
                    NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strAddTypeNote] attributes:attribute2];
                    
                    
                    [attrStringAdd appendAttributedString:attrString2];
                }
                if(![Utility isStringEmpty:strRemoveTypeNote])
                {
                    strAllNote = attrStringRemove;
                    if(![Utility isStringEmpty:strAddTypeNote])
                    {
                        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"\n" attributes:nil];
                        [strAllNote appendAttributedString:attrString];
                        [strAllNote appendAttributedString:attrStringAdd];
                    }
                }
                else
                {
                    if(![Utility isStringEmpty:strAddTypeNote])
                    {
                        strAllNote = attrStringAdd;
                    }
                    else
                    {
                        strAllNote = [[NSMutableAttributedString alloc]init];
                    }
                }
                cell.lblNote.attributedText = strAllNote;
                [cell.lblNote sizeToFit];
                cell.lblNoteHeight.constant = cell.lblNote.frame.size.height;
                

                float height = 8+cell.lblMenuNameHeight.constant+2+cell.lblNoteHeight.constant+8;
                sumHeight += height;
            }
            
            return sumHeight+83;
        }
        else if(section == 1)
        {
            if(item == 0)
            {
                //remarkHeight
                
                CustomTableViewCellLabelRemark *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelRemark];
                if([Utility isStringEmpty:receipt.remark])
                {
                    cell.lblText.attributedText = [self setAttributedString:@"" text:receipt.remark];
                }
                else
                {
                    NSString *message = [Setting getValue:@"013m" example:@"หมายเหตุ: "];
                    cell.lblText.attributedText = [self setAttributedString:message text:receipt.remark];
                }
                [cell.lblText sizeToFit];
                cell.lblTextHeight.constant = cell.lblText.frame.size.height;
                
                cell.lblTextHeight.constant = cell.lblTextHeight.constant<18?18:cell.lblTextHeight.constant;
                float remarkHeight = [Utility isStringEmpty:receipt.remark]?0:4+cell.lblTextHeight.constant+4;
                
                return remarkHeight;
            }
            else
            {
                Branch *branch = [Branch getBranch:receipt.branchID];
                switch (item)
                {
//                    case 0:
//                        return 26;
//                        break;
                    case 1:
                        return 26;
                        break;
                    case 2:
                        return receipt.specialPriceDiscount == 0?0:26;
                        break;
                    case 3:
                        return receipt.discountAmount > 0?26:0;
                        break;
                    case 4:
                        return 26;
                        break;
                    case 5:
                        return branch.serviceChargePercent > 0?26:0;
                        break;
                    case 6:
                        return branch.percentVat > 0?26:0;
                        break;
                    case 7:
                        return branch.serviceChargePercent + branch.percentVat > 0?26:0;
                        break;
                    case 8:
                        return (branch.serviceChargePercent>0 && branch.percentVat>0) || (branch.serviceChargePercent == 0 && branch.percentVat>0 && branch.priceIncludeVat)?26:0;
                        break;
                    case 9:
                        return 44;
                        break;
                    default:
                        break;
                }
                return 26;
            }
        }
        else if(section == 2)
        {
            if(receipt.status == 2 || receipt.status == 5 || receipt.status == 6)
            {
                return item == 0?34:44;
            }
            else if(receipt.status == 7 || receipt.status == 8)
            {
                switch (item)
                {
                    case 0:
                        return 34;
                        break;
                    case 1:
                    {
                        if(receipt.status == 7)
                        {
                            CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            
                            
                            
                            NSString *message = [Setting getValue:@"072m" example:@"ลูกค้าของคุณต้องการยกเลิกบิลนี้  ด้วยเหตุผลด้านล่างนี้ กรุณากด Confirm เพื่อ Refund เงินคืนลูกค้า"];
                            cell.lblRemark.text = message;
                            [cell.lblRemark sizeToFit];
                            cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                            
                            
                            
                            Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:1];
                            DisputeReason *disputeReason = [DisputeReason getDisputeReason:dispute.disputeReasonID];
                            cell.lblReason.text = disputeReason.text;
                            [cell.lblReason sizeToFit];
                            cell.lblReasonHeight.constant = cell.lblReason.frame.size.height;
                            
                            
                            
                            NSString *message2 = [Setting getValue:@"074m" example:@"จำนวนเงินที่ขอคืน: "];
                            float totalAmount = [Receipt getTotalAmount:receipt];
                            NSString *strTotalAmount = [Utility formatDecimal:totalAmount withMinFraction:2 andMaxFraction:2];
                            strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                            cell.lblAmount.attributedText = [self setAttributedString:message2 text:strTotalAmount];
                            
                            
                            
                            cell.lblReasonDetailTop.constant = 0;
                            cell.lblReasonDetailHeight.constant = 0;
                            
                            
                            
                            cell.lblPhoneNo.text = [Utility setPhoneNoFormat:dispute.phoneNo];
                            [cell.lblPhoneNo sizeToFit];
                            cell.lblPhoneNoHeight.constant = cell.lblPhoneNo.frame.size.height;
                            
                            return 11+cell.lblRemarkHeight.constant+8+cell.lblReasonHeight.constant+8+18+cell.lblReasonDetailTop.constant+cell.lblReasonDetailHeight.constant+8+cell.lblPhoneNoHeight.constant+11;
                        }
                        else if(receipt.status == 8)
                        {
                            CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            
                            
                            
                            NSString *message = [Setting getValue:@"078m" example:@"ลูกค้าของคุณ Open dispute ด้วยเหตุผลด้านล่างนี้ กรุณากด Confirm เพื่อ Refund เงินคืนลูกค้า หรือหากต้องการแก้ไขรายการกรุณากด Negotiate"];
                            cell.lblRemark.textColor = cSystem1;
                            cell.lblRemark.text = message;
                            [cell.lblRemark sizeToFit];
                            cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                            
                            
                            
                            
                            NSString *message2 = [Setting getValue:@"073m" example:@"เหตุผล: "];
                            Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:2];
                            DisputeReason *disputeReason = [DisputeReason getDisputeReason:dispute.disputeReasonID];
                            cell.lblReason.attributedText = [self setAttributedString:message2 text:disputeReason.text];
                            [cell.lblReason sizeToFit];
                            cell.lblReasonHeight.constant = cell.lblReason.frame.size.height;
                            
                            
                            
                            NSString *message3 = [Setting getValue:@"074m" example:@"จำนวนเงินที่ขอคืน: "];
                            NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                            strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                            cell.lblAmount.attributedText = [self setAttributedString:message3 text:strTotalAmount];
                            
                            
                            
                            NSString *message4 = [Setting getValue:@"079m" example:@"รายละเอียดเหตุผล: "];
                            cell.lblReasonDetail.attributedText = [self setAttributedString:message4 text:dispute.detail];
                            [cell.lblReasonDetail sizeToFit];
                            cell.lblReasonDetailTop.constant = 8;
                            cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                            
                            
                            
                            NSString *message5 = [Setting getValue:@"075m" example:@"เบอร์โทรติดต่อ: "];
                            cell.lblPhoneNo.attributedText = [self setAttributedString:message5 text:[Utility setPhoneNoFormat:dispute.phoneNo]];
                            [cell.lblPhoneNo sizeToFit];
                            cell.lblPhoneNoHeight.constant = cell.lblPhoneNo.frame.size.height;
                            
                            
                            return 11+cell.lblRemarkHeight.constant+8+cell.lblReasonHeight.constant+8+18+cell.lblReasonDetailTop.constant+cell.lblReasonDetailHeight.constant+8+cell.lblPhoneNoHeight.constant+11;
                        }
                    }
                        
                        break;
                    case 2:
                        return 44;
                        break;
                    case 3:
                        return 44;
                        break;
                    case 4:
                        return 44;
                        break;
                    default:
                        break;
                }
            }
            else if(receipt.status == 9 || receipt.status == 10 || receipt.status == 11 || receipt.status == 12 || receipt.status == 13 || receipt.status == 14)
            {
                if(item == 0)
                {
                    return 34;
                }
                else if(item == 1)
                {
                    switch (receipt.status)
                    {
                        case 9:
                        {
                            CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            
                            
                            
                            NSString *message = [Setting getValue:@"081m" example:@"คำร้องขอยกเลิกออเดอร์เสร็จสิ้น"];
                            cell.lblRemark.textColor = cSystem1;
                            cell.lblRemark.text = message;
                            [cell.lblRemark sizeToFit];
                            cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                            
                            
                            
                            NSString *message2 = [Setting getValue:@"073m" example:@"เหตุผล: "];
                            Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:1];
                            if(!dispute)
                            {
                                dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:3];
                            }
                            DisputeReason *disputeReason = [DisputeReason getDisputeReason:dispute.disputeReasonID];
                            cell.lblReason.attributedText = [self setAttributedString:message2 text:disputeReason.text];
                            [cell.lblReason sizeToFit];
                            cell.lblReasonHeight.constant = cell.lblReason.frame.size.height;
                            
                            
                            
                            NSString *message3 = [Setting getValue:@"074m" example:@"จำนวนเงินที่ขอคืน: "];
                            float totalAmount = [Receipt getTotalAmount:receipt];
                            NSString *strTotalAmount = [Utility formatDecimal:totalAmount withMinFraction:2 andMaxFraction:2];
                            strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                            cell.lblAmount.attributedText = [self setAttributedString:message3 text:strTotalAmount];
                            
                            
                            cell.lblReasonDetailHeight.constant = 0;
                            cell.lblReasonDetailTop.constant = 0;
                            
                            
                            NSString *message4 = [Setting getValue:@"075m" example:@"เบอร์โทรติดต่อ: "];
                            cell.lblPhoneNo.attributedText = [self setAttributedString:message4 text:[Utility setPhoneNoFormat:dispute.phoneNo]];
                            [cell.lblPhoneNo sizeToFit];
                            cell.lblPhoneNoHeight.constant = cell.lblPhoneNo.frame.size.height;
                            
                            
                            return 11+cell.lblRemarkHeight.constant+cell.lblReasonTop.constant+cell.lblReasonHeight.constant+8+18+cell.lblReasonDetailTop.constant+cell.lblReasonDetailHeight.constant+cell.lblPhoneNoTop.constant+cell.lblPhoneNoHeight.constant+11;
                        }
                        break;
                        case 10:
                        {
                            CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            
                            
                            
                            NSString *message = [Setting getValue:@"082m" example:@"กระบวนการ Open dispute เสร็จสิ้น"];
                            cell.lblRemark.textColor = cSystem1;
                            cell.lblRemark.text = message;
                            [cell.lblRemark sizeToFit];
                            cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                            
                            
                            
                            NSString *message2 = [Setting getValue:@"073m" example:@"เหตุผล: "];
                            Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:2];
                            if(!dispute)
                            {
                                dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:4];
                            }
                            DisputeReason *disputeReason = [DisputeReason getDisputeReason:dispute.disputeReasonID];
                            cell.lblReason.attributedText = [self setAttributedString:message2 text:disputeReason.text];
                            [cell.lblReason sizeToFit];
                            cell.lblReasonHeight.constant = cell.lblReason.frame.size.height;
                            
                            
                            
                            NSString *message3 = [Setting getValue:@"074m" example:@"จำนวนเงินที่ขอคืน: "];
                            NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                            strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                            cell.lblAmount.attributedText = [self setAttributedString:message3 text:strTotalAmount];
                            
                            
                            NSString *message4 = [Setting getValue:@"079m" example:@"รายละเอียดเหตุผล: "];
                            cell.lblReasonDetail.attributedText = [self setAttributedString:message4 text:dispute.detail];
                            [cell.lblReasonDetail sizeToFit];
                            cell.lblReasonDetailTop.constant = 8;
                            cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                            
                            
                            
                            NSString *message5 = [Setting getValue:@"075m" example:@"เบอร์โทรติดต่อ: "];
                            cell.lblPhoneNo.attributedText = [self setAttributedString:message5 text:[Utility setPhoneNoFormat:dispute.phoneNo]];
                            [cell.lblPhoneNo sizeToFit];
                            cell.lblPhoneNoHeight.constant = cell.lblPhoneNo.frame.size.height;
                            
                            
                            return 11+cell.lblRemarkHeight.constant+cell.lblReasonTop.constant+cell.lblReasonHeight.constant+8+18+cell.lblReasonDetailTop.constant+cell.lblReasonDetailHeight.constant+cell.lblPhoneNoTop.constant+cell.lblPhoneNoHeight.constant+11;
                        }
                        break;
                        case 11:
                        {
                            CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            
                            
                            
                            NSString *message = [Setting getValue:@"083m" example:@"Open dispute ที่ส่งไปกำลังดำเนินการอยู่ จะมีเจ้าหน้าที่ติดต่อกลับไปภายใน 24 ชม."];
                            cell.lblRemark.textColor = cSystem1;
                            cell.lblRemark.text = message;
                            [cell.lblRemark sizeToFit];
                            cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                            
                            
                            
                            NSString *message2 = [Setting getValue:@"073m" example:@"เหตุผล: "];
                            Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:2];
                            DisputeReason *disputeReason = [DisputeReason getDisputeReason:dispute.disputeReasonID];
                            cell.lblReason.attributedText = [self setAttributedString:message2 text:disputeReason.text];
                            [cell.lblReason sizeToFit];
                            cell.lblReasonHeight.constant = cell.lblReason.frame.size.height;
                            
                            
                            
                            NSString *message3 = [Setting getValue:@"074m" example:@"จำนวนเงินที่ขอคืน: "];
                            NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                            strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                            cell.lblAmount.attributedText = [self setAttributedString:message3 text:strTotalAmount];
                            
                            
                            NSString *message4 = [Setting getValue:@"079m" example:@"รายละเอียดเหตุผล: "];
                            cell.lblReasonDetail.attributedText = [self setAttributedString:message4 text:dispute.detail];
                            [cell.lblReasonDetail sizeToFit];
                            cell.lblReasonDetailTop.constant = 8;
                            cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                            
                            
                            NSString *message5 = [Setting getValue:@"075m" example:@"เบอร์โทรติดต่อ: "];
                            cell.lblPhoneNo.attributedText = [self setAttributedString:message5 text:[Utility setPhoneNoFormat:dispute.phoneNo]];
                            [cell.lblPhoneNo sizeToFit];
                            cell.lblPhoneNoHeight.constant = cell.lblPhoneNo.frame.size.height;
                            
                            
                            return 11+cell.lblRemarkHeight.constant+cell.lblReasonTop.constant+cell.lblReasonHeight.constant+8+18+cell.lblReasonDetailTop.constant+cell.lblReasonDetailHeight.constant+cell.lblPhoneNoTop.constant+cell.lblPhoneNoHeight.constant+11;
                        }
                        break;
                        case 12:
                        {
                            CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            
                            
                            
                            NSString *message = [Setting getValue:@"083m" example:@"Open dispute ได้มีการแก้ไขตามด้านล่าง โปรดรอการยืนยันจากลูกค้าสักครู่"];
                            cell.lblRemark.textColor = cSystem1;
                            cell.lblRemark.text = message;
                            [cell.lblRemark sizeToFit];
                            cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                            
                            
                            
                            NSString *message2 = [Setting getValue:@"073m" example:@"เหตุผล: "];
                            Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:5];
                            DisputeReason *disputeReason = [DisputeReason getDisputeReason:dispute.disputeReasonID];
                            cell.lblReason.attributedText = [self setAttributedString:message2 text:disputeReason.text];
                            [cell.lblReason sizeToFit];
                            cell.lblReasonHeight.constant = cell.lblReason.frame.size.height;
                            
                            
                            
                            NSString *message3 = [Setting getValue:@"074m" example:@"จำนวนเงินที่ขอคืน: "];
                            NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                            strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                            cell.lblAmount.attributedText = [self setAttributedString:message3 text:strTotalAmount];
                            
                            
                            NSString *message4 = [Setting getValue:@"079m" example:@"รายละเอียดเหตุผล: "];
                            cell.lblReasonDetail.attributedText = [self setAttributedString:message4 text:dispute.detail];
                            [cell.lblReasonDetail sizeToFit];
                            cell.lblReasonDetailTop.constant = 8;
                            cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                            
                            
                            NSString *message5 = [Setting getValue:@"075m" example:@"เบอร์โทรติดต่อ: "];
                            cell.lblPhoneNo.attributedText = [self setAttributedString:message5 text:[Utility setPhoneNoFormat:dispute.phoneNo]];
                            [cell.lblPhoneNo sizeToFit];
                            cell.lblPhoneNoHeight.constant = cell.lblPhoneNo.frame.size.height;
                            
                            
                            return 11+cell.lblRemarkHeight.constant+cell.lblReasonTop.constant+cell.lblReasonHeight.constant+8+18+cell.lblReasonDetailTop.constant+cell.lblReasonDetailHeight.constant+cell.lblPhoneNoTop.constant+cell.lblPhoneNoHeight.constant+11;
                        }
                        break;
                        case 13:
                        {
                            CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            
                            
                            
                            NSString *message = [Setting getValue:@"084m" example:@"หลังจากคุยกับเจ้าหน้าที่ Jummum แล้ว มีการแก้ไขจำนวนเงิน refund ใหม่ ตามด้านล่างนี้ กรุณากด Confirm เพื่อ Refund เงินคืนลูกค้า หรือหากต้องการแก้ไขรายการกรุณากด Negotiate"];
                            cell.lblRemark.textColor = cSystem1;
                            cell.lblRemark.text = message;
                            [cell.lblRemark sizeToFit];
                            cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                            
                            
                            
                            Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:3];
                            cell.lblReasonTop.constant = 0;
                            cell.lblReasonHeight.constant = 0;
                            
                            
                            
                            NSString *message2 = [Setting getValue:@"074m" example:@"จำนวนเงินที่ขอคืน: "];
                            NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                            strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                            cell.lblAmount.attributedText = [self setAttributedString:message2 text:strTotalAmount];
                            
                            
                            NSString *message3 = [Setting getValue:@"079m" example:@"รายละเอียดเหตุผล: "];
                            cell.lblReasonDetail.attributedText = [self setAttributedString:message3 text:dispute.detail];
                            [cell.lblReasonDetail sizeToFit];
                            cell.lblReasonDetailTop.constant = 8;
                            cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                            
                            
                            cell.lblPhoneNoTop.constant = 0;
                            cell.lblPhoneNoHeight.constant = 0;
                            
                            
                            return 11+cell.lblRemarkHeight.constant+cell.lblReasonTop.constant+cell.lblReasonHeight.constant+8+18+cell.lblReasonDetailTop.constant+cell.lblReasonDetailHeight.constant+cell.lblPhoneNoTop.constant+cell.lblPhoneNoHeight.constant+11;
                        }
                        break;
                        case 14:
                        {
                            CustomTableViewCellDisputeDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierDisputeDetail];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            
                            
                            
                            NSString *message = [Setting getValue:@"085m" example:@"กระบวนการ Open dispute ดำเนินการเสร็จสิ้นแล้ว"];
                            cell.lblRemark.textColor = cSystem1;
                            cell.lblRemark.text = message;
                            [cell.lblRemark sizeToFit];
                            cell.lblRemarkHeight.constant = cell.lblRemark.frame.size.height;
                            
                            
                            
                            NSString *message2 = [Setting getValue:@"073m" example:@"เหตุผล: "];
                            Dispute *dispute = [Dispute getDisputeWithReceiptID:receipt.receiptID type:5];
                            DisputeReason *disputeReason = [DisputeReason getDisputeReason:dispute.disputeReasonID];
                            cell.lblReason.attributedText = [self setAttributedString:message2 text:disputeReason.text];
                            [cell.lblReason sizeToFit];
                            cell.lblReasonHeight.constant = cell.lblReason.frame.size.height;
                            
                            
                            
                            NSString *message3 = [Setting getValue:@"074m" example:@"จำนวนเงินที่ขอคืน: "];
                            NSString *strTotalAmount = [Utility formatDecimal:dispute.refundAmount withMinFraction:2 andMaxFraction:2];
                            strTotalAmount = [NSString stringWithFormat:@"%@ บาท",strTotalAmount];
                            cell.lblAmount.attributedText = [self setAttributedString:message3 text:strTotalAmount];
                            
                            
                            NSString *message4 = [Setting getValue:@"079m" example:@"รายละเอียดเหตุผล: "];
                            cell.lblReasonDetail.attributedText = [self setAttributedString:message4 text:dispute.detail];
                            [cell.lblReasonDetail sizeToFit];
                            cell.lblReasonDetailTop.constant = 8;
                            cell.lblReasonDetailHeight.constant = cell.lblReasonDetail.frame.size.height;
                            
                            
                            NSString *message5 = [Setting getValue:@"075m" example:@"เบอร์โทรติดต่อ: "];
                            cell.lblPhoneNo.attributedText = [self setAttributedString:message5 text:[Utility setPhoneNoFormat:dispute.phoneNo]];
                            [cell.lblPhoneNo sizeToFit];
                            cell.lblPhoneNoHeight.constant = cell.lblPhoneNo.frame.size.height;
                            
                            
                            return 11+cell.lblRemarkHeight.constant+cell.lblReasonTop.constant+cell.lblReasonHeight.constant+8+18+cell.lblReasonDetailTop.constant+cell.lblReasonDetailHeight.constant+cell.lblPhoneNoTop.constant+cell.lblPhoneNoHeight.constant+11;
                        }
                        break;
                        default:
                        break;
                    }
                }
                else
                {
                    return 38;
                }
            }
        }
        else if(section == 3)
        {
            return [Utility showPrintButton]?44:0;
        }
    }
    else
    {
        
        //load order มาโชว์
        NSInteger receiptID = tableView.tag;
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receiptID branchID:[Branch getCurrentBranch].branchID];
        orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
        
        if(indexPath.item < [orderTakingList count])
        {
            CustomTableViewCellOrderSummary *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierOrderSummary];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            OrderTaking *orderTaking = orderTakingList[item];
            Menu *menu = [Menu getMenu:orderTaking.menuID];
            cell.lblQuantity.text = [Utility formatDecimal:orderTaking.quantity withMinFraction:0 andMaxFraction:0];
            
            
            //menu
            if(orderTaking.takeAway)
            {
                NSString *message = [Setting getValue:@"010m" example:@"ใส่ห่อ"];
                UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:15.0f];
                NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:message
                                                                                               attributes:attribute];
                
                NSDictionary *attribute2 = @{NSFontAttributeName: font};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",menu.titleThai] attributes:attribute2];
                
                
                [attrString appendAttributedString:attrString2];
                cell.lblMenuName.attributedText = attrString;
            }
            else
            {
                cell.lblMenuName.text = menu.titleThai;
            }
            [cell.lblMenuName sizeToFit];
            cell.lblMenuNameHeight.constant = cell.lblMenuName.frame.size.height;
            
            
            
            
            //note
            NSMutableAttributedString *strAllNote;
            NSMutableAttributedString *attrStringRemove;
            NSMutableAttributedString *attrStringAdd;
            NSString *strRemoveTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:-1];
            NSString *strAddTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:1];
            if(![Utility isStringEmpty:strRemoveTypeNote])
            {
                NSString *message = [Setting getValue:@"011m" example:@"ไม่ใส่"];
                UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:13.0f];
                NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                attrStringRemove = [[NSMutableAttributedString alloc] initWithString:message attributes:attribute];
                
                
                UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:13.0f];
                NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strRemoveTypeNote] attributes:attribute2];
                
                
                [attrStringRemove appendAttributedString:attrString2];
            }
            if(![Utility isStringEmpty:strAddTypeNote])
            {
                NSString *message = [Setting getValue:@"012m" example:@"เพิ่ม"];
                UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:13.0f];
                NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
                attrStringAdd = [[NSMutableAttributedString alloc] initWithString:message attributes:attribute];
                
                
                
                UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:13.0f];
                NSDictionary *attribute2 = @{NSFontAttributeName: font2};
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strAddTypeNote] attributes:attribute2];
                
                
                [attrStringAdd appendAttributedString:attrString2];
            }
            if(![Utility isStringEmpty:strRemoveTypeNote])
            {
                strAllNote = attrStringRemove;
                if(![Utility isStringEmpty:strAddTypeNote])
                {
                    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"\n" attributes:nil];
                    [strAllNote appendAttributedString:attrString];
                    [strAllNote appendAttributedString:attrStringAdd];
                }
            }
            else
            {
                if(![Utility isStringEmpty:strAddTypeNote])
                {
                    strAllNote = attrStringAdd;
                }
                else
                {
                    strAllNote = [[NSMutableAttributedString alloc]init];
                }
            }
            cell.lblNote.attributedText = strAllNote;
            [cell.lblNote sizeToFit];
            cell.lblNoteHeight.constant = cell.lblNote.frame.size.height;
            
            
            float height = 8+cell.lblMenuNameHeight.constant+2+cell.lblNoteHeight.constant+8;
            //            float height = menuNameLabelSize.height+noteLabelSize.height+8+8+2;
            return height;
        }
    }
    return 0;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    
    cell.separatorInset = UIEdgeInsetsMake(0.0f, self.view.bounds.size.width, 0.0f, CGFLOAT_MAX);
    if([tableView isEqual:tbvData])
    {
        if([Utility isStringEmpty:receipt.remark] && indexPath.section == 0 && indexPath.row == 0)
        {
            [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
        }
        else if(![Utility isStringEmpty:receipt.remark])
        {
            if(indexPath.section == 1 && indexPath.row == 0)
            {
                [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
            }
        }
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToCustomerKitchen" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segConfirmDispute"])
    {
        ConfirmDisputeViewController *vc = segue.destinationViewController;
        vc.fromType = _fromType;
        vc.receipt = receipt;
    }
}

-(void)moneyRefund:(id)sender
{
    _fromType = receipt.status == 2?3:4;
    [self performSegueWithIdentifier:@"segConfirmDispute" sender:self];
}

-(void)confirmCancel:(id)sender
{
    [self loadingOverlayView];
    Receipt *updateReceipt = [receipt copy];
    updateReceipt.status = 9;
    updateReceipt.modifiedUser = [Utility modifiedUser];
    updateReceipt.modifiedDate = [Utility currentDateTime];    
    [self.homeModel updateItems:dbJummumReceipt withData:updateReceipt actionScreen:@"update JMM receipt"];
}

-(void)cancelCancel:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToCustomerKitchen" sender:self];
}

-(void)confirmDispute:(id)sender
{
    [self loadingOverlayView];
    Receipt *updateReceipt = [receipt copy];
    updateReceipt.status = 10;
    updateReceipt.modifiedUser = [Utility modifiedUser];
    updateReceipt.modifiedDate = [Utility currentDateTime];
    [self.homeModel updateItems:dbJummumReceipt withData:updateReceipt actionScreen:@"update JMM receipt"];
}

-(void)confirmNegotiate:(id)sender
{
    [self loadingOverlayView];
    Receipt *updateReceipt = [receipt copy];
    updateReceipt.status = 14;
    updateReceipt.modifiedUser = [Utility modifiedUser];
    updateReceipt.modifiedDate = [Utility currentDateTime];
    [self.homeModel updateItems:dbJummumReceipt withData:updateReceipt actionScreen:@"update JMM receipt"];
}

-(void)negotiate:(id)sender
{
    [self loadingOverlayView];
    Receipt *updateReceipt = [receipt copy];
    updateReceipt.status = 11;
    updateReceipt.modifiedUser = [Utility modifiedUser];
    updateReceipt.modifiedDate = [Utility currentDateTime];
    [self.homeModel updateItems:dbJummumReceipt withData:updateReceipt actionScreen:@"update JMM receipt"];
}

-(void)cancelDispute:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToCustomerKitchen" sender:self];
}

-(void)sendToKitchen:(id)sender
{
    //start activityIndicator
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    CustomTableViewCellReceiptSummary *cell = [tbvData cellForRowAtIndexPath:indexPath];
    cell.indicator.alpha = 1;
    [cell.indicator startAnimating];
    cell.indicator.hidden = NO;
    
    
    
    //update receipt
    [self loadingOverlayView];    
    receipt.toBeProcessing = 1;
    Receipt *updateReceipt = [receipt copy];
    updateReceipt.status = 5;
    updateReceipt.sendToKitchenDate = [Utility currentDateTime];
    updateReceipt.modifiedUser = [Utility modifiedUser];
    updateReceipt.modifiedDate = [Utility currentDateTime];
    
    
    
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    [self.homeModel updateItems:dbJummumReceiptSendToKitchen withData:updateReceipt actionScreen:@"update JMM receipt"];
}

-(void)deliver:(id)sender
{
    //start activityIndicator
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    CustomTableViewCellReceiptSummary *cell = [tbvData cellForRowAtIndexPath:indexPath];
    cell.indicator.alpha = 1;
    [cell.indicator startAnimating];
    cell.indicator.hidden = NO;
    
    

    //update receipt
    [self loadingOverlayView];
    receipt.toBeProcessing = 1;
    Receipt *updateReceipt = [receipt copy];
    updateReceipt.status = 6;
    updateReceipt.deliveredDate = [Utility currentDateTime];
    updateReceipt.modifiedUser = [Utility modifiedUser];
    updateReceipt.modifiedDate = [Utility currentDateTime];
    

    
    
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    [self.homeModel updateItems:dbJummumReceiptDelivered withData:updateReceipt actionScreen:@"update JMM receipt"];
}

-(void)reloadTableView
{
    [tbvData reloadData];
}

-(void)itemsDownloaded:(NSArray *)items
{
    if(self.homeModel.propCurrentDB == dbReceiptMaxModifiedDate)
    {
        [Utility updateSharedObject:items];
        [tbvData reloadData];
    }
}

-(void)itemsUpdatedWithManager:(NSObject *)objHomeModel items:(NSArray *)items
{
    [self removeOverlayViews];
    HomeModel *homeModel = (HomeModel *)objHomeModel;
    if(homeModel.propCurrentDBUpdate == dbJummumReceiptSendToKitchen || homeModel.propCurrentDBUpdate == dbJummumReceiptDelivered)
    {
        NSMutableArray *messageList = items[0];
        NSMutableArray *receiptList = items[1];
        NSMutableArray *dataList = [[NSMutableArray alloc]init];
        [dataList addObject:receiptList];
        [Utility updateSharedObject:dataList];
        //        NSMutableArray *updateReceiptList = items[2];
        Message *message = messageList[0];
        BOOL alreadyDone = [message.text integerValue];
        Receipt *receipt = receiptList[0];
        
        
        //receipt ที่กด sendToKitchen ถูก device/user อื่นกดไปก่อนหน้านี้แล้ว
        if(alreadyDone)
        {
            if(homeModel.propCurrentDBUpdate == dbJummumReceiptSendToKitchen)
            {
                NSString *message = [Setting getValue:@"016m" example:@"Receipt no: %@ ส่งเข้าครัวไปก่อนหน้านี้แล้วค่ะ"];
                NSString *alertMessage = [NSString stringWithFormat:message,receipt.receiptNoID];
                [self showAlert:@"" message:alertMessage];
            }
            else if(homeModel.propCurrentDBUpdate == dbJummumReceiptDelivered)
            {
                NSString *message = [Setting getValue:@"017m" example:@"Receipt no: %@ ได้ส่งให้ลูกค้าไปก่อนหน้านี้แล้วค่ะ"];
                NSString *alertMessage = [NSString stringWithFormat:message,receipt.receiptNoID];
                [self showAlert:@"" message:alertMessage];
            }
        }
        
        
        //บอก indicator ของปุ่มที่กดให้หยุดหมุน
        receipt.toBeProcessing = 0;
        [self reloadTableView];
    }
    else
    {
        [Utility updateSharedObject:items];
        [self reloadTableView];
        if(receipt.status == 11)
        {
            NSString *title = [Setting getValue:@"086t" example:@"สำเร็จ"];
            NSString *message = [Setting getValue:@"086m" example:@"คุณส่งคำร้องขอแก้ไขจำนวนเงินที่จะ refund สำเร็จ จะมีเจ้าหน้าที่ติดต่อกลับไปภายใน 24 ชม."];
            [self showAlert:title message:message];
        }
        else if(receipt.status == 9 || receipt.status == 10)
        {
            NSString *title = [Setting getValue:@"087t" example:@"สำเร็จ"];
            NSString *message = [Setting getValue:@"087m" example:@"ลูกค้าของคุณจะได้รับเงินคืนภายใน 48 ชม."];
            [self showAlert:title message:message];
        }
        else if(receipt.status == 14)
        {
            NSString *title = [Setting getValue:@"088t" example:@"สำเร็จ"];
            NSString *message = [Setting getValue:@"088m" example:@"กระบวนการ refund เงินคืนลูกค้าสำเร็จ"];
            [self showAlert:title message:message];
        }
    }
}

- (IBAction)refresh:(id)sender
{
    [self viewDidAppear:NO];
}

-(void)print:(id)sender
{
    UIButton *btnPrint = sender;
    Receipt *receipt = [Receipt getReceipt:btnPrint.tag];
    

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:3];
    CustomTableViewCellButton *cell = [tbvData cellForRowAtIndexPath:indexPath];
    cell.indicator.alpha = 1;
    [cell.indicator startAnimating];
    cell.indicator.hidden = NO;
    cell.btnValue.enabled = NO;
    
    
    [self printReviewOrderBill:receipt];
}

-(void)printReviewOrderBill:(Receipt *)receipt
{
    UIImage *reviewOrderBill = [self getReviewOrderBill:receipt];
    
    NSData *commands = nil;
    
    ISCBBuilder *builder = [StarIoExt createCommandBuilder:[AppDelegate getEmulation]];
    
    [builder beginDocument];
    
    UIImage *imagePrint = reviewOrderBill;
    
    [builder appendBitmap:imagePrint diffusion:NO width:[AppDelegate getSelectedPaperSize] bothScale:YES];
    
    [builder appendCutPaper:SCBCutPaperActionPartialCutWithFeed];
    
    [builder endDocument];
    
    commands = [builder.commands copy];
    
    
    NSString *portName     = [AppDelegate getPortName];
    NSString *portSettings = [AppDelegate getPortSettings];
    
    dispatch_async(GlobalQueueManager.sharedManager.serialQueue, ^{
        [Communication sendCommands:commands
                           portName:portName
                       portSettings:portSettings
                            timeout:10000
                  completionHandler:^(BOOL result, NSString *title, NSString *message) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          if(result)
                          {
                              receipt.toBePrinting = NO;
                              
                              NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:3];
                              CustomTableViewCellButton *cell = [tbvData cellForRowAtIndexPath:indexPath];
                              cell.indicator.alpha = 0;
                              [cell.indicator stopAnimating];
                              cell.indicator.hidden = YES;
                              cell.btnValue.enabled = YES;                              
                          }
                          else
                          {
                              [self showAlert:title message:message];
                          }
                      });
                  }];
    });
}

-(UIImage *)getReviewOrderBill:(Receipt *)receipt
{
    NSMutableArray *arrImage = [[NSMutableArray alloc]init];
    
    
    {
        //order header
        CustomTableViewCellReceiptSummary *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierReceiptSummary];
        NSString *message = [Setting getValue:@"006m" example:@"Order no. #%@%@"];
        NSString *message2 = [Setting getValue:@"007m" example:@"Table: %@"];
        NSString *showBuffetOrder = receipt.buffetReceiptID?@" (Buffet)":@"";
        CustomerTable *customerTable = [CustomerTable getCustomerTable:receipt.customerTableID];
        cell.lblReceiptNo.text = [NSString stringWithFormat:message, receipt.receiptNoID, showBuffetOrder];
        cell.lblReceiptNo.textColor = [UIColor blackColor];
        cell.lblReceiptDate.text = [Utility dateToString:receipt.modifiedDate toFormat:@"d MMM yy HH:mm"];
        cell.lblReceiptDate.textColor = [UIColor blackColor];
        cell.lblBranchName.text = [NSString stringWithFormat:message2,customerTable.tableName];
        cell.lblBranchName.textColor = [UIColor blackColor];
        cell.btnOrderItAgain.hidden = YES;
        cell.indicator.hidden = YES;
        
        
        
        CGRect frame = cell.frame;
        frame.size.height = 79;
        cell.frame = frame;
        
        UIImage *image = [self imageFromView:cell];
                
        [arrImage addObject:image];
    }
    
    
    
    
    
    
    
    ///// order detail
    NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receipt.receiptID];
    orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
    for(int i=0; i<[orderTakingList count]; i++)
    {
        CustomTableViewCellOrderSummary *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierOrderSummary];
        
        
        OrderTaking *orderTaking = orderTakingList[i];
        Menu *menu = [Menu getMenu:orderTaking.menuID];
        cell.lblQuantity.text = [Utility formatDecimal:orderTaking.quantity withMinFraction:0 andMaxFraction:0];
        
        
        //menu
        if(orderTaking.takeAway)
        {
            UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:15];
            NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"ใส่ห่อ"
                                                                                           attributes:attribute];
            
            NSDictionary *attribute2 = @{NSFontAttributeName: font};
            NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",menu.titleThai] attributes:attribute2];
            
            
            [attrString appendAttributedString:attrString2];
            cell.lblMenuName.attributedText = attrString;
            cell.lblMenuName.textColor = [UIColor blackColor];
        }
        else
        {
            cell.lblMenuName.text = menu.titleThai;
            cell.lblMenuName.textColor = [UIColor blackColor];
        }
        [cell.lblMenuName sizeToFit];
        cell.lblMenuNameHeight.constant = cell.lblMenuName.frame.size.height;
  
        
        //note
        NSMutableAttributedString *strAllNote;
        NSMutableAttributedString *attrStringRemove;
        NSMutableAttributedString *attrStringAdd;
        NSString *strRemoveTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:-1];
        NSString *strAddTypeNote = [OrderNote getNoteNameListInTextWithOrderTakingID:orderTaking.orderTakingID noteType:1];
        if(![Utility isStringEmpty:strRemoveTypeNote])
        {
            UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:11];
            NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
            attrStringRemove = [[NSMutableAttributedString alloc] initWithString:@"ไม่ใส่" attributes:attribute];
            
            
            UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:11];
            NSDictionary *attribute2 = @{NSFontAttributeName: font2};
            NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strRemoveTypeNote] attributes:attribute2];
            
            
            [attrStringRemove appendAttributedString:attrString2];
        }
        if(![Utility isStringEmpty:strAddTypeNote])
        {
            UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:11];
            NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),NSFontAttributeName: font};
            attrStringAdd = [[NSMutableAttributedString alloc] initWithString:@"เพิ่ม" attributes:attribute];
            
            
            UIFont *font2 = [UIFont fontWithName:@"Prompt-Regular" size:11];
            NSDictionary *attribute2 = @{NSFontAttributeName: font2};
            NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",strAddTypeNote] attributes:attribute2];
            
            
            [attrStringAdd appendAttributedString:attrString2];
        }
        if(![Utility isStringEmpty:strRemoveTypeNote])
        {
            strAllNote = attrStringRemove;
            if(![Utility isStringEmpty:strAddTypeNote])
            {
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"\n" attributes:nil];
                [strAllNote appendAttributedString:attrString];
                [strAllNote appendAttributedString:attrStringAdd];
            }
        }
        else
        {
            if(![Utility isStringEmpty:strAddTypeNote])
            {
                strAllNote = attrStringAdd;
            }
            else
            {
                strAllNote = [[NSMutableAttributedString alloc]init];
            }
        }
        cell.lblNote.attributedText = strAllNote;
        cell.lblNote.textColor = [UIColor blackColor];
        [cell.lblNote sizeToFit];
        cell.lblNoteHeight.constant = cell.lblNote.frame.size.height;
        
        
        cell.lblTotalAmountWidth.constant = 0;

        
        float height = 8+cell.lblMenuNameHeight.constant+2+cell.lblNoteHeight.constant+8;
        CGRect frameCell = cell.frame;
        frameCell.size.height = height;
        cell.frame = frameCell;
        
        
        UIImage *image = [self imageFromView:cell];
        [arrImage addObject:image];
    }
    /////
    
    
    
    UIImage *combineImage = [self combineImage:arrImage];    
    return combineImage;
}
@end
