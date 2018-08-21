//
//  CustomerKitchenViewController.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 15/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomerKitchenViewController.h"
#import "OrderDetailViewController.h"
#import "TosAndPrivacyPolicyViewController.h"
#import "PersonalDataViewController.h"
#import "DisputeFormViewController.h"
#import "CustomTableViewCellReceiptSummary.h"
#import "CustomTableViewCellOrderSummary.h"
#import "CustomTableViewCellTotal.h"
#import "CustomTableViewCellLabelLabel.h"
#import "CustomTableViewCellLabelRemark.h"
#import "CustomCollectionReusableView.h"
#import "Receipt.h"
#import "UserAccount.h"
#import "Branch.h"
#import "OrderTaking.h"
#import "Menu.h"
#import "OrderNote.h"
#import "OrderKitchen.h"
#import "MenuType.h"
#import "CustomerTable.h"
#import "Message.h"
#import "Setting.h"
#import "Printer.h"
#import "ReceiptPrint.h"
#import "InvoiceComposer.h"



@interface CustomerKitchenViewController ()
{
    NSMutableArray *_receiptList;
    BOOL _lastItemReachedDelivery;
    BOOL _lastItemReachedOthers;
    

    UIView *_backgroundView;
    NSMutableArray *_arrOfHtmlContentList;
    NSInteger _countPrint;
    NSInteger _countingPrint;
    NSMutableDictionary *_printBillWithPortName;
    

    float _contentOffsetYNew;
    float _contentOffsetYPrinted;
    NSIndexPath *_indexPathNew;
    NSIndexPath *_indexPathPrinted;
    NSIndexPath *_indexPathDelivered;
    NSIndexPath *_indexPathAction;
    NSIndexPath *_indexPathOthers;
    NSInteger _lastSegConPrintStatus;
    
    
    NSMutableArray *_statusCellArray;
    NSMutableArray *_firmwareInfoCellArray;
    
    
    NSInteger _selectedReceiptID;
    Receipt *_selectedReceipt;
    HomeModel *_homeModelDelivered;
    
}
@end

@implementation CustomerKitchenViewController
static NSString * const reuseIdentifierReceiptSummary = @"CustomTableViewCellReceiptSummary";
static NSString * const reuseIdentifierOrderSummary = @"CustomTableViewCellOrderSummary";
static NSString * const reuseIdentifierTotal = @"CustomTableViewCellTotal";
static NSString * const reuseIdentifierLabelLabel = @"CustomTableViewCellLabelLabel";
static NSString * const reuseIdentifierLabelRemark = @"CustomTableViewCellLabelRemark";
static NSString * const reuseHeaderViewIdentifier = @"CustomCollectionReusableView";


@synthesize tbvData;
@synthesize credentialsDb;
@synthesize segConPrintStatus;
@synthesize imgBadge;
@synthesize imgBadgeTrailing;
@synthesize imgBadgeNew;
@synthesize imgBadgeProcessing;
@synthesize imgBadgeLeading;
@synthesize imgBadgeProcessingLeading;
@synthesize btnSelect;
@synthesize btnBack;
@synthesize imgPrinterStaus;
@synthesize lblNavTitle;
@synthesize topViewHeight;



-(IBAction)unwindToCustomerKitchen:(UIStoryboardSegue *)segue
{
    if([segue.sourceViewController isKindOfClass:[OrderDetailViewController class]] || [segue.sourceViewController isKindOfClass:[TosAndPrivacyPolicyViewController class]] || [segue.sourceViewController isKindOfClass:[PersonalDataViewController class]])
    {
        CustomViewController *vc = segue.sourceViewController;
        if(vc.newOrderComing)
        {
            [self reloadTableViewNewOrderTab];
        }
        else if(vc.issueComing)
        {
            [self reloadTableViewIssueTab];
        }
        else if(vc.issueComing)
        {
            [self reloadTableViewProcessingTab];
        }
        else if(vc.issueComing)
        {
            [self reloadTableViewDeliveredTab];
        }
        else if(vc.issueComing)
        {
            [self reloadTableViewClearTab];
        }
        else
        {
            [self reloadTableView];
        }
    }
    else if([segue.sourceViewController isKindOfClass:[DisputeFormViewController class]])
    {
        [self reloadTableViewClearTab];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    NSDate *maxReceiptModifiedDate = [Receipt getMaxModifiedDateWithBranchID:credentialsDb.branchID];    
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    [self.homeModel downloadItems:dbReceiptMaxModifiedDate withData:@[credentialsDb, maxReceiptModifiedDate]];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    
    //layout iphone X
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    
    float topPadding = window.safeAreaInsets.top;
    topViewHeight.constant = topPadding == 0?20:topPadding;
    
    
    
    
    float segConWidthPerItem = (self.view.frame.size.width-2*16)/5;
    imgBadgeTrailing.constant = segConWidthPerItem+16;
    imgBadgeLeading.constant = (segConWidthPerItem*3+16)-imgBadgeTrailing.constant-25;
    imgBadgeProcessingLeading.constant = (segConWidthPerItem*4+16)-imgBadgeTrailing.constant-imgBadgeLeading.constant-2*25;
    
    UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:14.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    [segConPrintStatus setTitleTextAttributes:attributes forState:UIControlStateNormal];
}

-(void)loadView
{
    [super loadView];
    
   
    _homeModelDelivered = [[HomeModel alloc]init];
    _homeModelDelivered.delegate = self;
    
    
    
    [self reloadTableView];
}

-(void)loadViewProcess
{
    [tbvData reloadData];
    [tbvData layoutIfNeeded];
    if(segConPrintStatus.selectedSegmentIndex == 0)
    {
        [UIView animateWithDuration:.25 animations:^{
            if(_indexPathNew)
            {
                if(_indexPathNew.row < [_receiptList count])
                {
                    [tbvData scrollToRowAtIndexPath:_indexPathNew atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
            }
        }];
    }
    else if(segConPrintStatus.selectedSegmentIndex == 1)
    {
        [UIView animateWithDuration:.25 animations:^{
            if(_indexPathPrinted)
            {
                if(_indexPathPrinted.row < [_receiptList count])
                {
                    [tbvData scrollToRowAtIndexPath:_indexPathPrinted atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
            }
        }];
    }
    else if(segConPrintStatus.selectedSegmentIndex == 2)
    {
        [UIView animateWithDuration:.25 animations:^{
            if(_indexPathDelivered)
            {
                if(_indexPathDelivered.row < [_receiptList count])
                {
                    [tbvData scrollToRowAtIndexPath:_indexPathDelivered atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
            }
        }];
    }
    else if(segConPrintStatus.selectedSegmentIndex == 3)
    {
        //if there is receipt with status = 7,8,11 ให้ขึ้น badge
        [UIView animateWithDuration:.25 animations:^{
            if(_indexPathAction)
            {
                if(_indexPathAction.row < [_receiptList count])
                {
                    [tbvData scrollToRowAtIndexPath:_indexPathAction atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
            }
        }];
    }
    else if(segConPrintStatus.selectedSegmentIndex == 4)
    {
        //status 9,10
        [UIView animateWithDuration:.25 animations:^{
            if(_indexPathOthers)
            {
                if(_indexPathOthers.row < [_receiptList count])
                {
                    [tbvData scrollToRowAtIndexPath:_indexPathOthers atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
            }
        }];
    }
    
    //badge
    {
        NSMutableArray *receiptActionList = [Receipt getReceiptListWithStatus:7 branchID:credentialsDb.branchID];
        [receiptActionList addObjectsFromArray:[Receipt getReceiptListWithStatus:8 branchID:credentialsDb.branchID]];        
        [receiptActionList addObjectsFromArray:[Receipt getReceiptListWithStatus:13 branchID:credentialsDb.branchID]];
        imgBadge.hidden = [receiptActionList count]==0;
    }
    
    
    //badge new
    {
        NSMutableArray *receiptActionList = [Receipt getReceiptListWithStatus:2 branchID:credentialsDb.branchID];
        imgBadgeNew.hidden = [receiptActionList count]==0;
    }
    
    
    //badge processing
    {
        NSMutableArray *receiptActionList = [Receipt getReceiptListWithStatus:5 branchID:credentialsDb.branchID];
        imgBadgeProcessing.hidden = [receiptActionList count]==0;
    }
}

-(void)setReceiptList
{
    if(segConPrintStatus.selectedSegmentIndex == 0)
    {
        _receiptList = [Receipt getReceiptListWithStatus:2 branchID:credentialsDb.branchID];
        _receiptList = [Receipt sortListAsc:_receiptList];
    }
    else if(segConPrintStatus.selectedSegmentIndex == 1)
    {
        _receiptList = [Receipt getReceiptListWithStatus:5 branchID:credentialsDb.branchID];
        _receiptList = [Receipt sortListAsc:_receiptList];
    }
    else if(segConPrintStatus.selectedSegmentIndex == 2)
    {
        _receiptList = [Receipt getReceiptListWithStatus:6 branchID:credentialsDb.branchID];
        _receiptList = [Receipt sortList:_receiptList];
    }
    else if(segConPrintStatus.selectedSegmentIndex == 3)
    {
        _receiptList = [Receipt getReceiptListWithStatus:7 branchID:credentialsDb.branchID];
        [_receiptList addObjectsFromArray:[Receipt getReceiptListWithStatus:8 branchID:credentialsDb.branchID]];
        [_receiptList addObjectsFromArray:[Receipt getReceiptListWithStatus:11 branchID:credentialsDb.branchID]];
        [_receiptList addObjectsFromArray:[Receipt getReceiptListWithStatus:12 branchID:credentialsDb.branchID]];
        [_receiptList addObjectsFromArray:[Receipt getReceiptListWithStatus:13 branchID:credentialsDb.branchID]];
        _receiptList = [Receipt sortListAsc:_receiptList];
    }
    else if(segConPrintStatus.selectedSegmentIndex == 4)
    {
        _receiptList = [Receipt getReceiptListWithStatus:9 branchID:credentialsDb.branchID];
        [_receiptList addObjectsFromArray:[Receipt getReceiptListWithStatus:10 branchID:credentialsDb.branchID]];
        [_receiptList addObjectsFromArray:[Receipt getReceiptListWithStatus:14 branchID:credentialsDb.branchID]];
        _receiptList = [Receipt sortList:_receiptList];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSString *title = [Setting getValue:@"005t" example:@"รายการอาหารที่ลูกค้าสั่ง"];
    lblNavTitle.text = title;
    tbvData.delegate = self;
    tbvData.dataSource = self;

    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierReceiptSummary bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierReceiptSummary];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelRemark bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelRemark];
    }
    
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if([tableView isEqual:tbvData])
    {
        if([_receiptList count] == 0)
        {
            UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
            noDataLabel.text             = @"ไม่มีข้อมูล";
            noDataLabel.textColor        = [UIColor darkGrayColor];
            noDataLabel.textAlignment    = NSTextAlignmentCenter;
            noDataLabel.font = [UIFont fontWithName:@"Prompt-Regular" size:15.0f];
            tableView.backgroundView = noDataLabel;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            return 0;
        }
        else
        {
            tableView.backgroundView = nil;
            return [_receiptList count];
        }
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
        return 1;
    }
    else
    {
        NSInteger receiptID = tableView.tag;
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receiptID branchID:credentialsDb.branchID];
        orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
        return [orderTakingList count]+1+1+1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    if([tableView isEqual:tbvData])
    {
        CustomTableViewCellReceiptSummary *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierReceiptSummary];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
        NSString *message = [Setting getValue:@"006m" example:@"Order no. #%@%@"];
        NSString *message2 = [Setting getValue:@"007m" example:@"Table: %@"];
        Receipt *receipt = _receiptList[section];
        NSString *showBuffetOrder = receipt.buffetReceiptID?@" (Buffet)":@"";
        CustomerTable *customerTable = [CustomerTable getCustomerTable:receipt.customerTableID];
        cell.lblReceiptNo.text = [NSString stringWithFormat:message, receipt.receiptNoID, showBuffetOrder];
        cell.lblReceiptDate.text = [Utility dateToString:receipt.modifiedDate toFormat:@"d MMM yy HH:mm"];
        cell.lblBranchName.text = [NSString stringWithFormat:message2,customerTable.tableName];
        cell.lblBranchName.textColor = cSystem1;
        
        
        
        {
            UINib *nib = [UINib nibWithNibName:reuseIdentifierOrderSummary bundle:nil];
            [cell.tbvOrderDetail registerNib:nib forCellReuseIdentifier:reuseIdentifierOrderSummary];
        }
        {
            UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelRemark bundle:nil];
            [cell.tbvOrderDetail registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelRemark];
        }
        {
            UINib *nib = [UINib nibWithNibName:reuseIdentifierTotal bundle:nil];
            [cell.tbvOrderDetail registerNib:nib forCellReuseIdentifier:reuseIdentifierTotal];
        }
        {
            UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelLabel bundle:nil];
            [cell.tbvOrderDetail registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelLabel];
        }
        
        
        cell.tbvOrderDetail.separatorColor = [UIColor clearColor];
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
        
        if(segConPrintStatus.selectedSegmentIndex == 0)
        {
            NSString *message = [Setting getValue:@"008m" example:@"ส่งเข้าครัว"];
            cell.btnOrderItAgain.tag = section;
            cell.btnOrderItAgain.hidden = NO;
            [cell.btnOrderItAgain setTitle:message forState:UIControlStateNormal];
            [cell.btnOrderItAgain removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            [cell.btnOrderItAgain addTarget:self action:@selector(printIndividualReceipt:) forControlEvents:UIControlEventTouchUpInside];
            [self setButtonDesign:cell.btnOrderItAgain];
        }
        else if(segConPrintStatus.selectedSegmentIndex == 1)
        {
            NSString *message = [Setting getValue:@"009m" example:@"เสิร์ฟ"];
            cell.btnOrderItAgain.tag = section;
            cell.btnOrderItAgain.hidden = NO;
            [cell.btnOrderItAgain setTitle:message forState:UIControlStateNormal];
            [cell.btnOrderItAgain removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            [cell.btnOrderItAgain addTarget:self action:@selector(changeToDeliveredStatus:) forControlEvents:UIControlEventTouchUpInside];
            [self setButtonDesign:cell.btnOrderItAgain];
        }
        else
        {
            cell.btnOrderItAgain.hidden = YES;
        }
        
        
        
        
        switch (segConPrintStatus.selectedSegmentIndex)
        {
            case 2:
            {
                if (!_lastItemReachedDelivery && section == [_receiptList count]-1)
                {
                    [self.homeModel downloadItems:dbReceiptSummary withData:@[receipt,credentialsDb]];
                }
            }
                break;
            case 4:
            {
                if (!_lastItemReachedOthers && section == [_receiptList count]-1)
                {
                    [self.homeModel downloadItems:dbReceiptSummary withData:@[receipt,credentialsDb]];
                }
            }
                break;
            default:
                break;
        }
        
        
        return cell;
    }
    else
    {
        NSInteger receiptID = tableView.tag;
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receiptID branchID:credentialsDb.branchID];
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
            CGSize menuNameLabelSize = [self suggestedSizeWithFont:cell.lblMenuName.font size:CGSizeMake(tbvData.frame.size.width - 75-28-2*16-2*8, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:cell.lblMenuName.text];
            CGRect frame = cell.lblMenuName.frame;
            frame.size.width = menuNameLabelSize.width;
            frame.size.height = menuNameLabelSize.height;
            cell.lblMenuNameHeight.constant = menuNameLabelSize.height;
            cell.lblMenuName.frame = frame;
            
            
            
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
                
                
//                UIFont *font2 = [UIFont systemFontOfSize:11];
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
            
            
            
            CGSize noteLabelSize = [self suggestedSizeWithFont:cell.lblNote.font size:CGSizeMake(tbvData.frame.size.width - 75-28-2*16-2*8, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:[strAllNote string]];
            noteLabelSize.height = [Utility isStringEmpty:[strAllNote string]]?13.13:noteLabelSize.height;
            CGRect frame2 = cell.lblNote.frame;
            frame2.size.width = noteLabelSize.width;
            frame2.size.height = noteLabelSize.height;
            cell.lblNoteHeight.constant = noteLabelSize.height;
            cell.lblNote.frame = frame2;
            
            
            
            
            
            float totalAmount = orderTaking.specialPrice * orderTaking.quantity;
            NSString *strTotalAmount = [Utility formatDecimal:totalAmount withMinFraction:2 andMaxFraction:2];
            cell.lblTotalAmount.text = [Utility addPrefixBahtSymbol:strTotalAmount];
            
            
            
            if(receiptID == _selectedReceiptID)
            {
                cell.backgroundColor = mSelectionStyleGray;
                if(item == [orderTakingList count]-1)
                {
                    _selectedReceiptID = 0;
                }
            }
            else
            {
                cell.backgroundColor = [UIColor whiteColor];
            }
            return cell;
        }
        else if(item == [orderTakingList count])
        {
            CustomTableViewCellLabelRemark *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelRemark];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            Receipt *receipt = [Receipt getReceipt:receiptID branchID:credentialsDb.branchID];
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
        else if(item == [orderTakingList count]+1)
        {
            CustomTableViewCellTotal *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierTotal];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            NSString *message = [Setting getValue:@"014m" example:@"รวมทั้งหมด"];
            Receipt *receipt = [Receipt getReceipt:receiptID branchID:credentialsDb.branchID];
            NSString *strTotalAmount = [Utility formatDecimal:receipt.cashAmount+receipt.transferAmount+receipt.creditCardAmount withMinFraction:2 andMaxFraction:2];
            strTotalAmount = [Utility addPrefixBahtSymbol:strTotalAmount];
            cell.lblAmount.text = strTotalAmount;
            cell.lblAmount.textColor = cSystem1;
            cell.lblAmount.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15.0f];
            cell.lblTitle.text = message;
            cell.lblTitle.textColor = cSystem4;
            cell.lblTitle.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15.0f];
            cell.lblTitleTop.constant = 8;
            
            
            
            return cell;
        }
        else if(item == [orderTakingList count]+2)
        {
            CustomTableViewCellLabelLabel *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelLabel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
            
            
            Receipt *receipt = [Receipt getReceipt:receiptID branchID:credentialsDb.branchID];
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
            
            
            
            return cell;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = indexPath.item;
    if([tableView isEqual:tbvData])
    {
        //load order มาโชว์
        Receipt *receipt = _receiptList[indexPath.section];
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receipt.receiptID branchID:credentialsDb.branchID];
        orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
        float sumHeight = 0;
        for(int i=0; i<[orderTakingList count]; i++)
        {
            OrderTaking *orderTaking = orderTakingList[i];
            Menu *menu = [Menu getMenu:orderTaking.menuID];
            
            NSString *strMenuName;
            if(orderTaking.takeAway)
            {
                NSString *message = [Setting getValue:@"015m" example:@"ใส่ห่อ %@"];
                strMenuName = [NSString stringWithFormat:message,menu.titleThai];
            }
            else
            {
                strMenuName = menu.titleThai;
            }
            
            
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
            
            
            
            UIFont *fontMenuName = [UIFont fontWithName:@"Prompt-Regular" size:15.0f];
            UIFont *fontNote = [UIFont fontWithName:@"Prompt-Regular" size:13.0f];
            
            CGSize menuNameLabelSize = [self suggestedSizeWithFont:fontMenuName size:CGSizeMake(tbvData.frame.size.width - 75-28-2*16-2*8, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:strMenuName];//153 from storyboard
            CGSize noteLabelSize = [self suggestedSizeWithFont:fontNote size:CGSizeMake(tbvData.frame.size.width - 75-28-2*16-2*8, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:[strAllNote string]];
            noteLabelSize.height = [Utility isStringEmpty:[strAllNote string]]?13.13:noteLabelSize.height;
            
            
            float height = menuNameLabelSize.height+noteLabelSize.height+8+8+2;
            sumHeight += height;
        }
        
        
        //remarkHeight
        CustomTableViewCellReceiptSummary *receiptSummaryCell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierReceiptSummary];
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
        

        return 83+sumHeight+remarkHeight+26+26;
    }
    else
    {
        NSInteger receiptID = tableView.tag;
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receiptID branchID:credentialsDb.branchID];
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
            CGSize menuNameLabelSize = [self suggestedSizeWithFont:cell.lblMenuName.font size:CGSizeMake(tbvData.frame.size.width - 75-28-2*16-2*8, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:cell.lblMenuName.text];
            
            
            
            
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
            
            
            
            CGSize noteLabelSize = [self suggestedSizeWithFont:cell.lblNote.font size:CGSizeMake(tbvData.frame.size.width - 75-28-2*16-2*8, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping forString:[strAllNote string]];
            noteLabelSize.height = [Utility isStringEmpty:[strAllNote string]]?13.13:noteLabelSize.height;
            
            
            
            float height = menuNameLabelSize.height+noteLabelSize.height+8+8+2;
            return height;
        }
        else if(indexPath.item == [orderTakingList count])
        {
            CustomTableViewCellLabelRemark *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelRemark];
            
            
            Receipt *receipt = [Receipt getReceipt:receiptID branchID:credentialsDb.branchID];
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
            
            if([Utility isStringEmpty:receipt.remark])
            {
                return 0;
            }
            else
            {
                cell.lblTextHeight.constant = cell.lblTextHeight.constant<18?18:cell.lblTextHeight.constant;
                float remarkHeight = [Utility isStringEmpty:receipt.remark]?0:4+cell.lblTextHeight.constant+4;
                
                return remarkHeight;
            }
        }
        else if(indexPath.item == [orderTakingList count]+1)
        {
            return 26;
        }
        else if(indexPath.item == [orderTakingList count]+2)
        {
            return 26;
        }
    }
    return 0;

}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
//    cell.backgroundColor = [UIColor whiteColor];
    [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![tableView isEqual:tbvData])
    {
        _selectedReceiptID = tableView.tag;
        _selectedReceipt = [Receipt getReceipt:_selectedReceiptID];
        [tableView reloadData];
        
        
        double delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self performSegueWithIdentifier:@"segOrderDetail" sender:self];
        });
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if([tableView isEqual:tbvData])
    {
        if(section != 0)
        {
            UIView *topBorder = [[UIView alloc]initWithFrame:CGRectMake(16, 0, tableView.frame.size.width-16*2, 1)];
            topBorder.backgroundColor = cSystem4_10;
            return topBorder;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if([tableView isEqual:tbvData])
    {
        if(section != 0)
        {
            return 1;
        }
    }
    return 0;
}

-(void)itemsDownloaded:(NSArray *)items
{
    if(self.homeModel.propCurrentDB == dbReceiptSummary)
    {
        if([[items[0] mutableCopy] count]==0)
        {
            if(segConPrintStatus.selectedSegmentIndex == 2)
            {
                _lastItemReachedDelivery = YES;
            }
            else
            {
                _lastItemReachedOthers = YES;
            }
            [tbvData reloadData];
        }
        else
        {
            [Utility updateSharedObject:items];
//            [Receipt addList:[items[0] mutableCopy]];
//            [OrderTaking addList:[items[1] mutableCopy]];
//            [OrderNote addList:[items[2] mutableCopy]];
//            [ReceiptPrint addList:[items[3] mutableCopy]];
            
            
            [self reloadTableView];
        }
    }
    else if(self.homeModel.propCurrentDB == dbReceiptMaxModifiedDate)
    {
        [Utility updateSharedObject:items];
        [self reloadTableView];
    }
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToCustomerTable" sender:self];
}

- (IBAction)selectList:(id)sender
{
    tbvData.editing = YES;
    [tbvData reloadData];
}

-(void)printIndividualReceipt:(id)sender
{
    //start activityIndicator
    UIButton *btnPrint = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:btnPrint.tag];
    CustomTableViewCellReceiptSummary *cell = [tbvData cellForRowAtIndexPath:indexPath];
    cell.indicator.alpha = 1;
    [cell.indicator startAnimating];
    cell.indicator.hidden = NO;
    
    
    
    //update receipt
    NSDate *maxReceiptModifiedDate = [Receipt getMaxModifiedDateWithBranchID:credentialsDb.branchID];
    Receipt *receipt = _receiptList[btnPrint.tag];
    receipt.toBeProcessing = 1;
    
    Receipt *updateReceipt = [receipt copy];
    updateReceipt.status = 5;
    updateReceipt.sendToKitchenDate = [Utility currentDateTime];
    updateReceipt.modifiedUser = [Utility modifiedUser];
    updateReceipt.modifiedDate = [Utility currentDateTime];
    
    
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    [self.homeModel updateItems:dbJummumReceiptSendToKitchen withData:@[updateReceipt,maxReceiptModifiedDate] actionScreen:@"update JMM receipt"];
}

-(void)changeToDeliveredStatus:(id)sender
{
    //start activityIndicator
    UIButton *btnPrint = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:btnPrint.tag];
    CustomTableViewCellReceiptSummary *cell = [tbvData cellForRowAtIndexPath:indexPath];
    cell.indicator.alpha = 1;
    [cell.indicator startAnimating];
    cell.indicator.hidden = NO;
    
    
    
    //update receipt
    NSDate *maxReceiptModifiedDate = [Receipt getMaxModifiedDateWithBranchID:credentialsDb.branchID];
    Receipt *receipt = _receiptList[btnPrint.tag];
    receipt.toBeProcessing = 1;
    
    Receipt *updateReceipt = [receipt copy];
    updateReceipt.status = 6;
    updateReceipt.deliveredDate = [Utility currentDateTime];
    updateReceipt.modifiedUser = [Utility modifiedUser];
    updateReceipt.modifiedDate = [Utility currentDateTime];
    
    
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    [self.homeModel updateItems:dbJummumReceiptDelivered withData:@[updateReceipt,maxReceiptModifiedDate] actionScreen:@"update JMM receipt"];
}

- (IBAction)printStatusChanged:(id)sender
{
    
    if(_lastSegConPrintStatus == 0)
    {
        _indexPathNew = tbvData.indexPathsForVisibleRows.firstObject;
    }
    else if(_lastSegConPrintStatus == 1)
    {
        _indexPathPrinted = tbvData.indexPathsForVisibleRows.firstObject;
    }
    else if(_lastSegConPrintStatus == 2)
    {
        _indexPathDelivered = tbvData.indexPathsForVisibleRows.firstObject;
    }
    else if(_lastSegConPrintStatus == 3)
    {
        _indexPathAction = tbvData.indexPathsForVisibleRows.firstObject;
    }
    else if(_lastSegConPrintStatus == 4)
    {
        _indexPathOthers = tbvData.indexPathsForVisibleRows.firstObject;
    }
    [self reloadTableView];
    _lastSegConPrintStatus = segConPrintStatus.selectedSegmentIndex;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segOrderDetail"])
    {
        OrderDetailViewController *vc = segue.destinationViewController;
        vc.receipt = _selectedReceipt;
        vc.credentialsDb = credentialsDb;
    }
}

-(void)reloadTableView
{
    [self setReceiptList];
    [self loadViewProcess];
}

-(void)reloadTableViewNewOrderTab
{
    _indexPathNew = [NSIndexPath indexPathForRow:0 inSection:0];
    segConPrintStatus.selectedSegmentIndex = 0;
    [self reloadTableView];
}

-(void)reloadTableViewIssueTab
{
    _indexPathAction = [NSIndexPath indexPathForRow:0 inSection:0];
    segConPrintStatus.selectedSegmentIndex = 3;
    [self reloadTableView];
}

-(void)reloadTableViewProcessingTab
{
    _indexPathPrinted = [NSIndexPath indexPathForRow:0 inSection:0];
    segConPrintStatus.selectedSegmentIndex = 1;
    [self reloadTableView];
}

-(void)reloadTableViewDeliveredTab
{
    _indexPathDelivered = [NSIndexPath indexPathForRow:0 inSection:0];
    segConPrintStatus.selectedSegmentIndex = 2;
    [self reloadTableView];
}

-(void)reloadTableViewClearTab
{
    _indexPathOthers = [NSIndexPath indexPathForRow:0 inSection:0];
    segConPrintStatus.selectedSegmentIndex = 4;
    [self reloadTableView];
}

- (IBAction)refresh:(id)sender
{
    [self viewDidAppear:NO];
}

-(void)itemsUpdatedWithManager:(NSObject *)objHomeModel items:(NSArray *)items
{
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
        [Receipt updateStatusAndIndicator:receipt];
        
        
        
//        //update receipt ที่มาใหม่หรือมีการ update
//        NSMutableArray *updateList = [[NSMutableArray alloc]init];
//        [updateList addObject:updateReceiptList];
//        [Utility updateSharedObject:updateList];
        
        
        
        
        [self reloadTableView];
    }
}

@end
