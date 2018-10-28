//
//  RunningReceiptViewController.m
//  DevJummumOM
//
//  Created by Thidaporn Kijkamjai on 8/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "RunningReceiptViewController.h"
#import "OrderDetailViewController.h"
#import "CustomTableViewCellReceiptSummary.h"
#import "Receipt.h"
#import "UserAccount.h"
#import "Branch.h"
#import "CustomerTable.h"
#import "Message.h"
#import "Setting.h"


@interface RunningReceiptViewController ()
{
    NSMutableArray *_receiptList;
    NSMutableArray *_receiptEndedList;
    BOOL _lastItemReached;
    BOOL _lastItemReachedEnded;
    

    float _contentOffsetYNew;
    float _contentOffsetYPrinted;
    NSIndexPath *_indexPathNew;
    NSIndexPath *_indexPathPrinted;
    NSInteger _lastSegConPrintStatus;

    
    NSInteger _selectedReceiptID;
    Receipt *_selectedReceipt;
    
    NSInteger _selectedTypeIndex;
    NSArray *_typeList;
    NSMutableArray *_buttonTypeList;

    
    UIScrollView *_horizontalScrollView;
    NSMutableDictionary *_dicTimer;
    NSInteger _page;
    NSInteger _pageEnded;
    NSInteger _perPage;
}
@end

@implementation RunningReceiptViewController
static NSString * const reuseIdentifierReceiptSummary = @"CustomTableViewCellReceiptSummary";


@synthesize tbvData;
@synthesize lblNavTitle;
@synthesize topViewHeight;
@synthesize btnShowPrintButton;
@synthesize selectedReceipt;

    
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
    
-(IBAction)unwindToRunningReceipt:(UIStoryboardSegue *)segue
{
    
}
    
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

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
        _typeList = @[@"ทานอยู่",@"เคลียร์แล้ว"];
        _buttonTypeList = [[NSMutableArray alloc]init];
        for (int i = 0; i < [_typeList count]; i++)
        {
            float buttonWidth = self.view.frame.size.width/2;
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
    
    if(_selectedTypeIndex == 0)
    {
        _page = [_receiptList count]/_perPage + 1;
        _lastItemReached = NO;
        [tbvData reloadData];
    }
    else if(_selectedTypeIndex == 1)
    {
        NSLog(@"change to ended tab");
        _pageEnded = 1;
        Branch *branch = [Branch getCurrentBranch];
        self.homeModel = [[HomeModel alloc]init];
        self.homeModel.delegate = self;
        [self.homeModel downloadItems:dbReceiptBuffetEndedPage withData:@[branch,@(_pageEnded),@(_perPage)]];
    }
    
    
    _lastSegConPrintStatus = _selectedTypeIndex;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    lblNavTitle.text = @"บิลใบเสร็จ";
    tbvData.delegate = self;
    tbvData.dataSource = self;
    tbvData.separatorColor = [UIColor clearColor];
    _dicTimer = [[NSMutableDictionary alloc]init];
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierReceiptSummary bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierReceiptSummary];
    }

    
    
    if([Utility showPrintButton])
    {
        [btnShowPrintButton setBackgroundImage:[UIImage imageNamed:@"printerGreen.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btnShowPrintButton setBackgroundImage:[UIImage imageNamed:@"printerGreenNo.png"] forState:UIControlStateNormal];
    }
    
    
    [self loadingOverlayView];
    _page = 1;
    _pageEnded = 1;
    _perPage = 10;
    _lastItemReached = NO;
    _lastItemReachedEnded = NO;
    _selectedTypeIndex = 0;
    _indexPathNew = nil;
    _indexPathPrinted = nil;
    _receiptList = [[NSMutableArray alloc]init];
    _receiptEndedList = [[NSMutableArray alloc]init];
    Branch *branch = [Branch getCurrentBranch];
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    [self.homeModel downloadItems:dbReceiptBuffetPage withData:@[branch,@(_page),@(_perPage)]];
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([tableView isEqual:tbvData])
    {
        if(_selectedTypeIndex == 0)
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
                
                
                if(!_lastItemReached)
                {
                    Branch *branch = [Branch getCurrentBranch];
                    self.homeModel = [[HomeModel alloc]init];
                    self.homeModel.delegate = self;
                    [self.homeModel downloadItems:dbReceiptBuffetPage withData:@[branch,@(_page),@(_perPage)]];
                }
                
                
                return 0;
            }
            else
            {
                tableView.backgroundView = nil;
                return [_receiptList count];
            }
        }
        else if(_selectedTypeIndex == 1)
        {
            if([_receiptEndedList count] == 0)
            {
                UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
                noDataLabel.text             = @"ไม่มีข้อมูล";
                noDataLabel.textColor        = [UIColor darkGrayColor];
                noDataLabel.textAlignment    = NSTextAlignmentCenter;
                noDataLabel.font = [UIFont fontWithName:@"Prompt-Regular" size:15.0f];
                tableView.backgroundView = noDataLabel;
                tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                
                
                if(!_lastItemReachedEnded)
                {
                    Branch *branch = [Branch getCurrentBranch];
                    self.homeModel = [[HomeModel alloc]init];
                    self.homeModel.delegate = self;
                    [self.homeModel downloadItems:dbReceiptBuffetEndedPage withData:@[branch,@(_pageEnded),@(_perPage)]];
                }
                
                NSLog(@"0 inside [_receiptEndedList count] == 0");
                return 0;
            }
            else
            {
                tableView.backgroundView = nil;
                NSLog(@"_receiptEndedList count: %ld", [_receiptEndedList count]);
                return [_receiptEndedList count];
            }
        }
        NSLog(@"0 at the end");
        return 0;
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
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    if([tableView isEqual:tbvData])
    {
        CustomTableViewCellReceiptSummary *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierReceiptSummary];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
        Receipt *receipt;
        if(_selectedTypeIndex == 0)
        {
            receipt = _receiptList[section];
        }
        else
        {
            receipt = _receiptEndedList[section];
        }
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
        cell.lblBranchName.text = [NSString stringWithFormat:message2,customerTable.tableName];
        cell.lblBranchName.textColor = cSystem1;
    
    
        //เวลาคงเหลือ
        if(_selectedTypeIndex == 0)
        {
            NSInteger timeToOrder = receipt.timeToOrder+10;
            NSTimeInterval seconds = [[Utility currentDateTime] timeIntervalSinceDate:receipt.receiptDate];
            NSInteger timeToCountDown = timeToOrder - seconds >= 0?timeToOrder - seconds:0;
            if(timeToCountDown == 0)
            {
                cell.lblReceiptDate.text = @"";
            }
            else
            {
                if(![_dicTimer objectForKey:[NSString stringWithFormat:@"%ld",receipt.receiptID]])
                {
                    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
                    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer:) userInfo:receipt repeats:YES];
                    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
                    [self populateLabelwithTime:timeToCountDown receipt:receipt];
                    [_dicTimer setValue:timer forKey:[NSString stringWithFormat:@"%ld",receipt.receiptID]];
                }
            }
            cell.lblReceiptDate.hidden = NO;
        }
        else
        {
            cell.lblReceiptDate.text = @"";
            cell.lblReceiptDate.hidden = YES;
        }
    
    
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
            cell.btnOrderItAgain.tag = section;
            [cell.btnOrderItAgain setTitle:@"เคลียร์โต๊ะ" forState:UIControlStateNormal];
            [cell.btnOrderItAgain removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            [cell.btnOrderItAgain addTarget:self action:@selector(endBuffet:) forControlEvents:UIControlEventTouchUpInside];
            [self setButtonDesign:cell.btnOrderItAgain];
            cell.btnOrderItAgain.hidden = NO;
        }
        else if(_selectedTypeIndex == 1)
        {
            cell.btnOrderItAgain.tag = section;
            [cell.btnOrderItAgain setTitle:@"คืนโต๊ะ" forState:UIControlStateNormal];
            [cell.btnOrderItAgain removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            [cell.btnOrderItAgain addTarget:self action:@selector(returnBuffet:) forControlEvents:UIControlEventTouchUpInside];
            [self setButtonDesign:cell.btnOrderItAgain];
            cell.btnOrderItAgain.hidden = NO;
        }
    
    
    
        switch (_selectedTypeIndex)
        {
            case 0:
            {
                if (!_lastItemReached && section == [_receiptList count]-1)
                {
//                    _page = [_receiptList count]/_perPage + 1;
                    Branch *branch = [Branch getCurrentBranch];
                    self.homeModel = [[HomeModel alloc]init];
                    self.homeModel.delegate = self;
                    [self.homeModel downloadItems:dbReceiptBuffetPage withData:@[branch,@(_page),@(_perPage)]];
                }
            }
                break;
            case 1:
            {
                if (!_lastItemReachedEnded && section == [_receiptEndedList count]-1)
                {
//                    _pageEnded = [_receiptEndedList count]/_perPage + 1;
                    Branch *branch = [Branch getCurrentBranch];
                    self.homeModel = [[HomeModel alloc]init];
                    self.homeModel.delegate = self;
                    [self.homeModel downloadItems:dbReceiptBuffetEndedPage withData:@[branch,@(_pageEnded),@(_perPage)]];
                }
            }
                break;
            default:
                break;
        }
    
    
        return cell;
    }
    
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:tbvData])
    {
        return 83;
    }
    
    return 0;

}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    if([tableView isEqual:tbvData])
    {
        [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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

-(void)itemsDownloaded:(NSArray *)items manager:(NSObject *)objHomeModel
{
    HomeModel *homeModel = (HomeModel *)objHomeModel;
    if(homeModel.propCurrentDB == dbReceiptBuffetPage)
    {
        NSLog(@"finish downloaded, receipt count: %ld",[items[0] count]);
        [self removeOverlayViews];
        if([[items[0] mutableCopy] count]==0)
        {
            _lastItemReached = YES;
            if(_page == 1)
            {
                [_receiptList removeAllObjects];
            }
            [tbvData reloadData];
        }
        else
        {
            [Utility updateSharedObject:items];
            if(_page == 1)
            {
                [_receiptList removeAllObjects];
            }
            
            _page += 1;
            
            NSInteger remaining = [_receiptList count]%_perPage;
            for(int i=0; i<remaining; i++)
            {
                [_receiptList removeLastObject];
            }

            [_receiptList addObjectsFromArray:items[0]];
//            [self updateReceiptList:_receiptList withReceiptList:items[0]];
            [tbvData reloadData];
        }
    }
    else if(homeModel.propCurrentDB == dbReceiptBuffetEndedPage)
    {
        NSLog(@"download dbReceiptBuffetEndedPage finished");
        [self removeOverlayViews];
        if([[items[0] mutableCopy] count]==0)
        {
            _lastItemReachedEnded = YES;
            if(_pageEnded == 1)
            {
                [_receiptEndedList removeAllObjects];
            }
            [tbvData reloadData];
        }
        else
        {
            [Utility updateSharedObject:items];
            if(_pageEnded == 1)
            {
                [_receiptEndedList removeAllObjects];
            }
            
            _pageEnded += 1;
            
            
            NSInteger remaining = [_receiptEndedList count]%_perPage;
            for(int i=0; i<remaining; i++)
            {
                [_receiptEndedList removeLastObject];
            }

            
            [_receiptEndedList addObjectsFromArray:items[0]];
            NSLog(@"_receiptEndedList: %ld", [_receiptEndedList count]);
//            [self updateReceiptList:_receiptEndedList withReceiptList:items[0]];
            [tbvData reloadData];
        }
    }
}

-(void)endBuffet:(id)sender
{
    //start activityIndicator
    UIButton *btnEndBuffet = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:btnEndBuffet.tag];
    CustomTableViewCellReceiptSummary *cell = [tbvData cellForRowAtIndexPath:indexPath];
    cell.indicator.alpha = 1;
    [cell.indicator startAnimating];
    cell.indicator.hidden = NO;
    cell.btnOrderItAgain.enabled = NO;
    
    
    
    //update receipt
    Receipt *receipt = _receiptList[btnEndBuffet.tag];
    receipt.toBeProcessing = 1;
    
    Receipt *updateReceipt = [receipt copy];
    updateReceipt.buffetEnded = 1;
    updateReceipt.buffetEndedDate = [Utility currentDateTime];
    updateReceipt.modifiedUser = [Utility modifiedUser];
    updateReceipt.modifiedDate = [Utility currentDateTime];
    
    
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    [self.homeModel updateItems:dbReceiptBuffetEnded withData:updateReceipt actionScreen:@"update receipt buffetEnded"];
}

-(void)returnBuffet:(id)sender
{
    //start activityIndicator
    UIButton *btnReturnBuffet = sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:btnReturnBuffet.tag];
    CustomTableViewCellReceiptSummary *cell = [tbvData cellForRowAtIndexPath:indexPath];
    cell.indicator.alpha = 1;
    [cell.indicator startAnimating];
    cell.indicator.hidden = NO;
    cell.btnOrderItAgain.enabled = NO;
    
    
    
    //update receipt
    Receipt *receipt = _receiptEndedList[btnReturnBuffet.tag];
    receipt.toBeProcessing = 1;
    
    Receipt *updateReceipt = [receipt copy];
    updateReceipt.buffetEnded = 0;
    updateReceipt.modifiedUser = [Utility modifiedUser];
    updateReceipt.modifiedDate = [Utility currentDateTime];
    
    
    self.homeModel = [[HomeModel alloc]init];
    self.homeModel.delegate = self;
    [self.homeModel updateItems:dbReceiptBuffetEnded withData:updateReceipt actionScreen:@"update receipt return buffet"];
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
    if(selectedReceipt)
    {
        [self removeReceipt:selectedReceipt];
        _selectedTypeIndex = selectedReceipt.buffetEnded;
        selectedReceipt = nil;        
    }

    [self typeSelected:_buttonTypeList[_selectedTypeIndex]];
    
}

-(void)stopIndicator:(NSInteger)receiptID
{
    {
        Receipt *receipt = [Receipt getReceipt:receiptID receiptList:_receiptList];
        receipt.toBeProcessing = 0;
    }
    {
        Receipt *receipt = [Receipt getReceipt:receiptID receiptList:_receiptEndedList];
        receipt.toBeProcessing = 0;
    }
}

-(void)removeReceipt:(Receipt *)receipt
{
    for(Receipt *item in _receiptList)
    {
        if(item.receiptID == receipt.receiptID)
        {
            [_receiptList removeObject:item];
            break;
        }
    }
}

- (IBAction)refresh:(id)sender
{
    if(_selectedTypeIndex == 0)
    {
        _page = 1;
        _lastItemReached = NO;
        Branch *branch = [Branch getCurrentBranch];
        self.homeModel = [[HomeModel alloc]init];
        self.homeModel.delegate = self;
        [self.homeModel downloadItems:dbReceiptBuffetPage withData:@[branch,@(_page),@(_perPage)]];
    }
    else
    {
        _pageEnded = 1;
        _lastItemReachedEnded = NO;
        Branch *branch = [Branch getCurrentBranch];
        self.homeModel = [[HomeModel alloc]init];
        self.homeModel.delegate = self;
        [self.homeModel downloadItems:dbReceiptBuffetEndedPage withData:@[branch,@(_pageEnded),@(_perPage)]];
    }
}

-(void)itemsUpdatedWithManager:(NSObject *)objHomeModel items:(NSArray *)items
{
    HomeModel *homeModel = (HomeModel *)objHomeModel;
    if(homeModel.propCurrentDBUpdate == dbReceiptBuffetEnded)
    {
        NSMutableArray *messageList = items[0];
        NSMutableArray *receiptList = items[1];

        [Utility updateSharedObject:items];
        

        Message *message = messageList[0];
        NSString *strWarning = message.text;
        Receipt *receipt = receiptList[0];
        
        
        //บอก indicator ของปุ่มที่กดให้หยุดหมุน
        [self stopIndicator:receipt.receiptID];
        
        
        //receipt ที่กด endBuffet ถูก device/user อื่นกดไปก่อนหน้านี้แล้ว
        if(![Utility isStringEmpty:strWarning])
        {
            [self showAlert:@"" message:strWarning];
        }
        else
        {
            //remove from current list
            [self removeReceipt:receipt];
            [self typeSelected:_buttonTypeList[_selectedTypeIndex]];
        
            
            NSTimer *timer = [_dicTimer objectForKey:[NSString stringWithFormat:@"%ld",receipt.receiptID]];
            [timer invalidate];
            [_dicTimer removeObjectForKey:[NSString stringWithFormat:@"%ld",receipt.receiptID]];
        }
    }
}

-(void)updateTimer:(NSTimer *)timer
{
    Receipt *receipt = timer.userInfo;
    NSInteger timeToOrder = receipt.timeToOrder+10;
    NSTimeInterval seconds = [[Utility currentDateTime] timeIntervalSinceDate:receipt.receiptDate];
    NSInteger timeToCountDown = timeToOrder - seconds >= 0?timeToOrder - seconds:0;
    if(timeToCountDown == 0)
    {
        NSLog(@"timer invalidate receiptID = %ld",receipt.receiptID);
        [timer invalidate];
        [self removeReceipt:receipt];
        if(_selectedTypeIndex == 0)
        {
            [tbvData reloadData];
        }
        else
        {
            _pageEnded = 1;
            Branch *branch = [Branch getCurrentBranch];
            self.homeModel = [[HomeModel alloc]init];
            self.homeModel.delegate = self;
            [self.homeModel downloadItems:dbReceiptBuffetEndedPage withData:@[branch,@(_pageEnded),@(_perPage)]];
        }
    }
    else
    {
        [self populateLabelwithTime:timeToCountDown receipt:receipt];
    }
}

- (void)populateLabelwithTime:(NSInteger)seconds receipt:(Receipt *)receipt
{
    NSInteger minutes = seconds / 60;
    NSInteger hours = minutes / 60;
    
    seconds -= minutes * 60;
    minutes -= hours * 60;
    
    
    NSInteger index = [Receipt getIndex:_receiptList receipt:receipt];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    CustomTableViewCellReceiptSummary *cell = [tbvData cellForRowAtIndexPath:indexPath];
    
    
    
    cell.lblReceiptDate.text = [NSString stringWithFormat:@"เวลาคงเหลือ %02ld:%02ld:%02ld", hours, minutes, seconds];
}

//-(NSMutableArray *)updateReceiptList:(NSMutableArray *)receiptList withReceiptList:(NSMutableArray *)newReceiptList
//{
//    for(Receipt *newReceipt in newReceiptList)
//    {
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_receiptID = %ld",newReceipt.receiptID];
//        NSArray *filterArray = [receiptList filteredArrayUsingPredicate:predicate];
//        if([filterArray count]>0)
//        {
//            Receipt *sourceReceipt = filterArray[0];
//            [Receipt copyFrom:newReceipt to:sourceReceipt];
//        }
//        else
//        {
//            [receiptList addObject:newReceipt];
//        }
//    }
//
//    return receiptList;
//}
@end
