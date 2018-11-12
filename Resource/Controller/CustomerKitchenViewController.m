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
#import "CustomTableViewCellReceiptSummary2.h"
#import "CustomTableViewCellOrderSummary.h"
#import "CustomTableViewCellTotal.h"
#import "CustomTableViewCellLabelRemark.h"
#import "CustomTableViewCellButton.h"
#import "CustomTableViewCellButtonLabel.h"
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


#import "AppDelegate.h"
#import "Communication.h"
#import "GlobalQueueManager.h"


@interface CustomerKitchenViewController ()
{
    NSMutableArray *_receiptList;
    BOOL _lastItemReachedDelivery;
    BOOL _lastItemReachedOthers;
    

    float _contentOffsetYNew;
    float _contentOffsetYPrinted;
    NSIndexPath *_indexPathNew;
    NSIndexPath *_indexPathPrinted;
    NSIndexPath *_indexPathDelivered;
    NSIndexPath *_indexPathAction;
    NSIndexPath *_indexPathOthers;
    NSInteger _lastSegConPrintStatus;

    
    NSInteger _selectedReceiptID;
    Receipt *_selectedReceipt;
    
    NSInteger _selectedTypeIndex;
    NSArray *_typeList;
    NSMutableArray *_buttonTypeList;
    UIImageView *imgBadge;
    UIImageView *imgBadgeNew;
    UIImageView *imgBadgeProcessing;
    
    UIScrollView *_horizontalScrollView;
}
@end

@implementation CustomerKitchenViewController
static NSString * const reuseIdentifierReceiptSummary = @"CustomTableViewCellReceiptSummary";
static NSString * const reuseIdentifierReceiptSummary2 = @"CustomTableViewCellReceiptSummary2";
static NSString * const reuseIdentifierOrderSummary = @"CustomTableViewCellOrderSummary";
static NSString * const reuseIdentifierTotal = @"CustomTableViewCellTotal";
static NSString * const reuseIdentifierLabelRemark = @"CustomTableViewCellLabelRemark";
static NSString * const reuseIdentifierButton = @"CustomTableViewCellButton";
static NSString * const reuseIdentifierButtonLabel = @"CustomTableViewCellButtonLabel";



@synthesize tbvData;
@synthesize lblNavTitle;
@synthesize topViewHeight;
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
    
    
    NSDate *maxReceiptModifiedDate = [Receipt getMaxModifiedDateWithBranchID:[Branch getCurrentBranch].branchID];
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    [self.homeModel downloadItems:dbReceiptMaxModifiedDate withData:@[[Branch getCurrentBranch], maxReceiptModifiedDate]];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [tbvData reloadData];
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    
    //layout iphone X
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    
    float topPadding = window.safeAreaInsets.top;
    topViewHeight.constant = topPadding == 0?20:topPadding;
    
    
    
    
    //tab type
    if(!_horizontalScrollView)
    {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        float topPadding = window.safeAreaInsets.top;
        topPadding = topPadding == 0?20:topPadding;
        _horizontalScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topPadding+44, self.view.frame.size.width, 44)];
        _horizontalScrollView.delegate = self;
        _horizontalScrollView.backgroundColor = cSystem4_10;
        
        
        //shadow
        _horizontalScrollView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _horizontalScrollView.layer.shadowOpacity = 0.8;
        _horizontalScrollView.layer.shadowRadius = 3;
        _horizontalScrollView.layer.shadowOffset = CGSizeMake(0, 1);
        _horizontalScrollView.layer.masksToBounds = NO;
        
        
        int buttonX = 0;//15;
        _typeList = @[@"มาใหม่",@"เข้าครัว",@"เสิร์ฟ",@"ประเด็น",@"เคลียร์"];
        _buttonTypeList = [[NSMutableArray alloc]init];
        for (int i = 0; i < [_typeList count]; i++)
        {
            float buttonWidth = self.view.frame.size.width/4;
            NSString *type = _typeList[i];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, 0, buttonWidth, 44)];
            button.titleLabel.font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
            if(i==0)
            {
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.backgroundColor = cSystem2;
            }
            else
            {
                [button setTitleColor:cSystem4 forState:UIControlStateNormal];
                button.backgroundColor = cSystem4_10;
            }
            [button setTitle:type forState:UIControlStateNormal];
            [_horizontalScrollView addSubview:button];
            buttonX = buttonX + buttonWidth;
            [button addTarget:self action:@selector(typeSelected:) forControlEvents:UIControlEventTouchUpInside];
            [_buttonTypeList addObject:button];
  
            
            if(i == 0)
            {
                NSInteger badgeWidth = 25;
                imgBadgeNew = [[UIImageView alloc]initWithFrame:CGRectMake(button.frame.size.width-badgeWidth-6, 0, badgeWidth, badgeWidth)];
                [_horizontalScrollView addSubview:imgBadgeNew];
            }
            else if(i == 1)
            {
                NSInteger badgeWidth = 25;
                imgBadgeProcessing = [[UIImageView alloc]initWithFrame:CGRectMake(button.frame.origin.x + button.frame.size.width-badgeWidth-6, 0, badgeWidth, badgeWidth)];
                [_horizontalScrollView addSubview:imgBadgeProcessing];
            }
            else if(i == 3)
            {
                NSInteger badgeWidth = 25;
                imgBadge = [[UIImageView alloc]initWithFrame:CGRectMake(button.frame.origin.x + button.frame.size.width-badgeWidth-6, 0, badgeWidth, badgeWidth)];
                [_horizontalScrollView addSubview:imgBadge];
            }
            
        }
        
        _horizontalScrollView.contentSize = CGSizeMake(buttonX, _horizontalScrollView.frame.size.height);
        _horizontalScrollView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_horizontalScrollView];
    }
}

-(void)typeSelected:(UIButton*)sender
{
    UIButton *button = sender;
    for(int i=0; i < [_typeList count]; i++)
    {
        UIButton *eachButton = _buttonTypeList[i];
        [eachButton setTitleColor:cSystem4 forState:UIControlStateNormal];
        eachButton.backgroundColor = cSystem4_10;
        
        
        if([eachButton isEqual:button])
        {
            _selectedTypeIndex = i;
        }
    }
    
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = cSystem2;

    

    //type changed
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
    _lastSegConPrintStatus = _selectedTypeIndex;
    
}

-(void)loadView
{
    [super loadView];
    
    [self reloadTableView];
}

-(void)loadViewProcess
{
    [tbvData reloadData];
    [tbvData layoutIfNeeded];
    if(_selectedTypeIndex == 0)
    {
        [UIView animateWithDuration:.25 animations:^{
            if(_indexPathNew)
            {
                if(_indexPathNew.section < [_receiptList count])
                {
                    [tbvData scrollToRowAtIndexPath:_indexPathNew atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
            }
        }];
    }
    else if(_selectedTypeIndex == 1)
    {
        [UIView animateWithDuration:.25 animations:^{
            if(_indexPathPrinted)
            {
                if(_indexPathPrinted.section < [_receiptList count])
                {
                    [tbvData scrollToRowAtIndexPath:_indexPathPrinted atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
            }
        }];
    }
    else if(_selectedTypeIndex == 2)
    {
        [UIView animateWithDuration:.25 animations:^{
            if(_indexPathDelivered)
            {
                if(_indexPathDelivered.section < [_receiptList count])
                {
                    [tbvData scrollToRowAtIndexPath:_indexPathDelivered atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
            }
        }];
    }
    else if(_selectedTypeIndex == 3)
    {
        //if there is receipt with status = 7,8,11 ให้ขึ้น badge
        [UIView animateWithDuration:.25 animations:^{
            if(_indexPathAction)
            {
                if(_indexPathAction.section < [_receiptList count])
                {
                    [tbvData scrollToRowAtIndexPath:_indexPathAction atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
            }
        }];
    }
    else if(_selectedTypeIndex == 4)
    {
        //status 9,10
        [UIView animateWithDuration:.25 animations:^{
            if(_indexPathOthers)
            {
                if(_indexPathOthers.section < [_receiptList count])
                {
                    [tbvData scrollToRowAtIndexPath:_indexPathOthers atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
            }
        }];
    }
    
    //badge
    {
        NSMutableArray *receiptActionList = [Receipt getReceiptListWithStatus:7 branchID:[Branch getCurrentBranch].branchID];
        [receiptActionList addObjectsFromArray:[Receipt getReceiptListWithStatus:8 branchID:[Branch getCurrentBranch].branchID]];
        [receiptActionList addObjectsFromArray:[Receipt getReceiptListWithStatus:13 branchID:[Branch getCurrentBranch].branchID]];
        imgBadge.hidden = [receiptActionList count]==0;
    }
    
    
    //badge new
    {
        NSMutableArray *receiptActionList = [Receipt getReceiptListWithStatus:2 branchID:[Branch getCurrentBranch].branchID];
        imgBadgeNew.hidden = [receiptActionList count]==0;
    }
    
    
    //badge processing
    {
        NSMutableArray *receiptActionList = [Receipt getReceiptListWithStatus:5 branchID:[Branch getCurrentBranch].branchID];
        imgBadgeProcessing.hidden = [receiptActionList count]==0;
    }
    
    
    
    if(!imgBadgeNew.hidden)
    {
        if(_selectedTypeIndex == 0)
        {
            imgBadgeNew.image = [UIImage imageNamed:@"badgeWhite.png"];
        }
        else
        {
            imgBadgeNew.image = [UIImage imageNamed:@"badgeGray.png"];
        }
    }
    if(!imgBadgeProcessing.hidden)
    {
        if(_selectedTypeIndex == 1)
        {
            imgBadgeProcessing.image = [UIImage imageNamed:@"badgeWhite.png"];
        }
        else
        {
            imgBadgeProcessing.image = [UIImage imageNamed:@"badgeGray.png"];
        }
    }
    if(!imgBadge.hidden)
    {
        if(_selectedTypeIndex == 3)
        {
            imgBadge.image = [UIImage imageNamed:@"badgeWhite.png"];
        }
        else
        {
            imgBadge.image = [UIImage imageNamed:@"badgeGray.png"];
        }
    }
}

-(void)setReceiptList
{
    if(_selectedTypeIndex == 0)
    {
        _receiptList = [Receipt getReceiptListWithStatus:2 branchID:[Branch getCurrentBranch].branchID];
        _receiptList = [Receipt sortListAsc:_receiptList];
    }
    else if(_selectedTypeIndex == 1)
    {
        _receiptList = [Receipt getReceiptListWithStatus:5 branchID:[Branch getCurrentBranch].branchID];
        _receiptList = [Receipt sortListAsc:_receiptList];
    }
    else if(_selectedTypeIndex == 2)
    {
        _receiptList = [Receipt getReceiptListWithStatus:6 branchID:[Branch getCurrentBranch].branchID];
        _receiptList = [Receipt sortList:_receiptList];
    }
    else if(_selectedTypeIndex == 3)
    {
        _receiptList = [Receipt getReceiptListWithStatus:7 branchID:[Branch getCurrentBranch].branchID];
        [_receiptList addObjectsFromArray:[Receipt getReceiptListWithStatus:8 branchID:[Branch getCurrentBranch].branchID]];
        [_receiptList addObjectsFromArray:[Receipt getReceiptListWithStatus:11 branchID:[Branch getCurrentBranch].branchID]];
        [_receiptList addObjectsFromArray:[Receipt getReceiptListWithStatus:12 branchID:[Branch getCurrentBranch].branchID]];
        [_receiptList addObjectsFromArray:[Receipt getReceiptListWithStatus:13 branchID:[Branch getCurrentBranch].branchID]];
        _receiptList = [Receipt sortListAsc:_receiptList];
    }
    else if(_selectedTypeIndex == 4)
    {
        _receiptList = [Receipt getReceiptListWithStatus:9 branchID:[Branch getCurrentBranch].branchID];
        [_receiptList addObjectsFromArray:[Receipt getReceiptListWithStatus:10 branchID:[Branch getCurrentBranch].branchID]];
        [_receiptList addObjectsFromArray:[Receipt getReceiptListWithStatus:14 branchID:[Branch getCurrentBranch].branchID]];
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
    tbvData.separatorColor = [UIColor clearColor];

    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierReceiptSummary bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierReceiptSummary];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelRemark bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelRemark];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierOrderSummary bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierOrderSummary];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierReceiptSummary2 bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierReceiptSummary2];
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
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receiptID branchID:[Branch getCurrentBranch].branchID];
        orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
        return [orderTakingList count]+1+1+1;//remark,total amount,status
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
        
        
        
        Receipt *receipt = _receiptList[section];
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
        {
            UINib *nib = [UINib nibWithNibName:reuseIdentifierLabelRemark bundle:nil];
            [cell.tbvOrderDetail registerNib:nib forCellReuseIdentifier:reuseIdentifierLabelRemark];
        }
        {
            UINib *nib = [UINib nibWithNibName:reuseIdentifierTotal bundle:nil];
            [cell.tbvOrderDetail registerNib:nib forCellReuseIdentifier:reuseIdentifierTotal];
        }
        {
            UINib *nib = [UINib nibWithNibName:reuseIdentifierButton bundle:nil];
            [cell.tbvOrderDetail registerNib:nib forCellReuseIdentifier:reuseIdentifierButton];
        }
        {
            UINib *nib = [UINib nibWithNibName:reuseIdentifierButtonLabel bundle:nil];
            [cell.tbvOrderDetail registerNib:nib forCellReuseIdentifier:reuseIdentifierButtonLabel];
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
            cell.btnOrderItAgain.enabled = NO;
        }
        else
        {
            cell.indicator.alpha = 0;
            [cell.indicator stopAnimating];
            cell.indicator.hidden = YES;
            cell.btnOrderItAgain.enabled = YES;
        }
        
        
        cell.btnOrderItAgain.backgroundColor = cSystem2;
        if(_selectedTypeIndex == 0)
        {
            NSString *message = [Setting getValue:@"008m" example:@"ส่งเข้าครัว"];
            cell.btnOrderItAgain.tag = section;
            cell.btnOrderItAgain.hidden = NO;
            [cell.btnOrderItAgain setTitle:message forState:UIControlStateNormal];
            [cell.btnOrderItAgain removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            [cell.btnOrderItAgain addTarget:self action:@selector(sendToKitchen:) forControlEvents:UIControlEventTouchUpInside];
            [self setButtonDesign:cell.btnOrderItAgain];
        }
        else if(_selectedTypeIndex == 1)
        {
            NSString *message = [Setting getValue:@"009m" example:@"เสิร์ฟ"];
            cell.btnOrderItAgain.tag = section;
            cell.btnOrderItAgain.hidden = NO;
            [cell.btnOrderItAgain setTitle:message forState:UIControlStateNormal];
            [cell.btnOrderItAgain removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            [cell.btnOrderItAgain addTarget:self action:@selector(deliver:) forControlEvents:UIControlEventTouchUpInside];
            [self setButtonDesign:cell.btnOrderItAgain];
        }
        else
        {
            cell.btnOrderItAgain.hidden = YES;
        }
        
        
        
        
        switch (_selectedTypeIndex)
        {
            case 2:
            {
                if (!_lastItemReachedDelivery && section == [_receiptList count]-1)
                {
                    [self.homeModel downloadItems:dbReceiptSummary withData:@[receipt,[Branch getCurrentBranch]]];
                }
            }
                break;
            case 4:
            {
                if (!_lastItemReachedOthers && section == [_receiptList count]-1)
                {
                    [self.homeModel downloadItems:dbReceiptSummary withData:@[receipt,[Branch getCurrentBranch]]];
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
                UIFont *font = [UIFont fontWithName:@"Prompt-Regular" size:15.0f];
                NSDictionary *attribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSFontAttributeName: font};
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:message                                                                                               attributes:attribute];
                
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
            
            
            Receipt *receipt = [Receipt getReceipt:receiptID branchID:[Branch getCurrentBranch].branchID];
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
            Receipt *receipt = [Receipt getReceipt:receiptID branchID:[Branch getCurrentBranch].branchID];
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
            CustomTableViewCellButtonLabel *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierButtonLabel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
            
            
            Receipt *receipt = [Receipt getReceipt:receiptID branchID:[Branch getCurrentBranch].branchID];
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
            
            
   
            cell.btnValue.hidden = [Utility showPrintButton];
            NSString *title = [Setting getValue:@"106t" example:@"พิมพ์"];
            cell.btnValue.tag = receiptID;
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
            
            
//            cell.lblText.text = @"";
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
        
        float statusHeight = 44;
        return 83+sumHeight+remarkHeight+26+statusHeight;//+printHeight;
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
            return height;
        }
        else if(indexPath.item == [orderTakingList count])
        {
            CustomTableViewCellLabelRemark *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabelRemark];
            
            
            Receipt *receipt = [Receipt getReceipt:receiptID branchID:[Branch getCurrentBranch].branchID];
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
            return 44;//26;
        }
    }
    return 0;

}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    if([tableView isEqual:tbvData])
    {
        [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
    }
    else
    {
        NSInteger receiptID = tableView.tag;
        NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receiptID];
        orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
        Receipt *receipt = [Receipt getReceipt:receiptID];
        cell.separatorInset = UIEdgeInsetsMake(0.0f, self.view.bounds.size.width, 0.0f, CGFLOAT_MAX);
        if([Utility isStringEmpty:receipt.remark] && indexPath.item == [orderTakingList count]-1)
        {
            [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
        }
        
        
        if(indexPath.item == [orderTakingList count] || indexPath.item == [orderTakingList count]+1)
        {
            [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
        }
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if([tableView isEqual:tbvData])
    {
        if (section == 0)
        {
            return CGFLOAT_MIN;
        }
        return tableView.sectionHeaderHeight;
    }
    return CGFLOAT_MIN;
}

-(void)itemsDownloaded:(NSArray *)items
{
    if(self.homeModel.propCurrentDB == dbReceiptSummary)
    {
        if([[items[0] mutableCopy] count]==0)
        {
            if(_selectedTypeIndex == 2)
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

-(void)sendToKitchen:(id)sender
{
    //start activityIndicator
    UIButton *btnPrint = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:btnPrint.tag];
    CustomTableViewCellReceiptSummary *cell = [tbvData cellForRowAtIndexPath:indexPath];
    cell.indicator.alpha = 1;
    [cell.indicator startAnimating];
    cell.indicator.hidden = NO;
    cell.btnOrderItAgain.enabled = NO;
    
    
    
    //update receipt
    Receipt *receipt = _receiptList[btnPrint.tag];
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
    UIButton *btnPrint = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:btnPrint.tag];
    CustomTableViewCellReceiptSummary *cell = [tbvData cellForRowAtIndexPath:indexPath];
    cell.indicator.alpha = 1;
    [cell.indicator startAnimating];
    cell.indicator.hidden = NO;
    cell.btnOrderItAgain.enabled = NO;
    
    
    
    //update receipt
    Receipt *receipt = _receiptList[btnPrint.tag];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segOrderDetail"])
    {
        OrderDetailViewController *vc = segue.destinationViewController;
        vc.receipt = _selectedReceipt;
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
    _selectedTypeIndex = 0;
    [self reloadTableView];
}

-(void)reloadTableViewIssueTab
{
    _indexPathAction = [NSIndexPath indexPathForRow:0 inSection:0];
    _selectedTypeIndex = 3;
    [self reloadTableView];
}

-(void)reloadTableViewProcessingTab
{
    _indexPathPrinted = [NSIndexPath indexPathForRow:0 inSection:0];
    _selectedTypeIndex = 1;
    [self reloadTableView];
}

-(void)reloadTableViewDeliveredTab
{
    _indexPathDelivered = [NSIndexPath indexPathForRow:0 inSection:0];
    _selectedTypeIndex = 2;
    [self reloadTableView];
}

-(void)reloadTableViewClearTab
{
    _indexPathOthers = [NSIndexPath indexPathForRow:0 inSection:0];
    _selectedTypeIndex = 4;
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
}

-(void)print:(id)sender
{
    UIButton *btnPrint = sender;
    Receipt *receipt = [Receipt getReceipt:btnPrint.tag];
    
    NSInteger receiptIndex = [Receipt getIndex:_receiptList receipt:receipt];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:receiptIndex];
    CustomTableViewCellReceiptSummary *cell = [tbvData cellForRowAtIndexPath:indexPath];
    NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receipt.receiptID branchID:[Branch getCurrentBranch].branchID];
    orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
    NSIndexPath *indexPathOrderDetail = [NSIndexPath indexPathForRow:[orderTakingList count]+4-1 inSection:0];
    CustomTableViewCellButton *cellButton = [cell.tbvOrderDetail cellForRowAtIndexPath:indexPathOrderDetail];
    
    
    cellButton.indicator.alpha = 1;
    [cellButton.indicator startAnimating];
    cellButton.indicator.hidden = NO;
    cellButton.btnValue.enabled = NO;
    
    
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
                              
                              NSInteger receiptIndex = [Receipt getIndex:_receiptList receipt:receipt];
                              NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:receiptIndex];
                              CustomTableViewCellReceiptSummary *cell = [tbvData cellForRowAtIndexPath:indexPath];
                              NSMutableArray *orderTakingList = [OrderTaking getOrderTakingListWithReceiptID:receipt.receiptID branchID:[Branch getCurrentBranch].branchID];
                              orderTakingList = [OrderTaking createSumUpOrderTakingWithTheSameMenuAndNote:orderTakingList];
                              NSIndexPath *indexPathOrderDetail = [NSIndexPath indexPathForRow:[orderTakingList count]+4-1 inSection:0];
                              CustomTableViewCellButton *cellButton = [cell.tbvOrderDetail cellForRowAtIndexPath:indexPathOrderDetail];
                              
                              cellButton.indicator.alpha = 0;
                              [cellButton.indicator stopAnimating];
                              cellButton.indicator.hidden = YES;
                              cellButton.btnValue.enabled = YES;
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
        CustomTableViewCellReceiptSummary2 *cell = [tbvData dequeueReusableCellWithIdentifier:reuseIdentifierReceiptSummary2];
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
        [cell.lblBranchName sizeToFit];
        cell.btnOrderItAgain.hidden = YES;
        cell.indicator.hidden = YES;
        
        
        CGRect frame = cell.frame;
        frame.size.height = 91;//79;
        cell.frame = frame;
//        [self.view addSubview:cell];
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
        cell.lblQuantity.textColor = [UIColor blackColor];
        
        
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
        
 
        
        float height = cell.lblMenuNameHeight.constant+cell.lblNoteHeight.constant+8+8+2;
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
