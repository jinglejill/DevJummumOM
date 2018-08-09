//
//  MyRewardViewController.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 3/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "MyRewardViewController.h"
#import "CustomTableViewCellReward.h"
#import "RewardRedemption.h"
#import "Branch.h"
#import "RewardRedemptionViewController.h"


@interface MyRewardViewController ()
{
    NSMutableArray *_rewardRedemptionList;
    NSMutableArray *_rewardPointList;
    NSMutableArray *_promoCodeList;
    NSMutableArray *_timeToCountDownList;
    NSMutableArray *_timerList;
    BOOL _lastItemReached;
    
    
    
    
    NSMutableArray *_rewardRedemptionUsedList;
    NSMutableArray *_rewardPointUsedList;
    NSMutableArray *_promoCodeUsedList;
    NSMutableArray *_timeToCountDownUsedList;
    NSMutableArray *_timerUsedList;
    BOOL _lastItemReachedUsed;
    
    
    
    
    
    RewardRedemption *_rewardRedemption;
    RewardPoint *_rewardPointSpent;
    PromoCode *_promoCode;
}
@end

@implementation MyRewardViewController
static NSString * const reuseIdentifierReward = @"CustomTableViewCellReward";


@synthesize segConValue;
@synthesize tbvData;
@synthesize rewardPoint;


-(IBAction)unwindToMyReward:(UIStoryboardSegue *)segue
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    tbvData.dataSource = self;
    tbvData.delegate = self;
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierReward bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierReward];
    }
    
    UserAccount *userAccount = [UserAccount getCurrentUserAccount];
    [self.homeModel downloadItems:dbRewardPointSpent withData:userAccount];
    [self loadingOverlayView];
    _timeToCountDownList = [[NSMutableArray alloc]init];
    _rewardPointList = [[NSMutableArray alloc]init];
    _promoCodeList = [[NSMutableArray alloc]init];
    _rewardRedemptionList = [[NSMutableArray alloc]init];
    
    
    _timeToCountDownUsedList = [[NSMutableArray alloc]init];
    _rewardPointUsedList = [[NSMutableArray alloc]init];
    _promoCodeUsedList = [[NSMutableArray alloc]init];
    _rewardRedemptionUsedList = [[NSMutableArray alloc]init];
    _timerList = [[NSMutableArray alloc]init];
    _timerUsedList = [[NSMutableArray alloc]init];
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if(segConValue.selectedSegmentIndex == 0)
    {
        if([_rewardRedemptionList count] > 0)
        {
            tableView.backgroundView = nil;
            return 1;
        }
        else
        {
            UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
            noDataLabel.text             = @"คุณยังไม่มีรางวัล";
            noDataLabel.textColor        = [UIColor darkGrayColor];
            noDataLabel.textAlignment    = NSTextAlignmentCenter;
            tableView.backgroundView = noDataLabel;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            return 0;
        }
    }
    else
    {
        if([_rewardRedemptionUsedList count] > 0)
        {
            tableView.backgroundView = nil;
            return 1;
        }
        else
        {
            UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
            noDataLabel.text             = @"คุณยังไม่มีรางวัล";
            noDataLabel.textColor        = [UIColor darkGrayColor];
            noDataLabel.textAlignment    = NSTextAlignmentCenter;
            tableView.backgroundView = noDataLabel;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            return 0;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if(segConValue.selectedSegmentIndex == 0)
    {
        return [_rewardRedemptionList count];
    }
    else
    {
        return [_rewardRedemptionUsedList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    if(segConValue.selectedSegmentIndex == 0)
    {
        CustomTableViewCellReward *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierReward];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        RewardRedemption *rewardRedemption = _rewardRedemptionList[item];
        cell.lblHeader.text = rewardRedemption.header;
        [cell.lblHeader sizeToFit];
        cell.lblHeaderHeight.constant = cell.lblHeader.frame.size.height>70?70:cell.lblHeader.frame.size.height;
        
        
        cell.lblSubTitle.text = rewardRedemption.subTitle;
        [cell.lblSubTitle sizeToFit];
        cell.lblSubTitleHeight.constant = 70-8-cell.lblHeaderHeight.constant<0?0:70-8-cell.lblHeaderHeight.constant;
        
        
        cell.lblRemark.text = [NSString stringWithFormat:@"🍄 %ld points",rewardRedemption.point];
        
        
        Branch *branch = [Branch getBranch:rewardRedemption.branchID];
        NSString *imageFileName = [Utility isStringEmpty:branch.imageUrl]?@"NoImage.jpg":branch.imageUrl;
        [self.homeModel downloadImageWithFileName:imageFileName completionBlock:^(BOOL succeeded, UIImage *image)
         {
             if (succeeded)
             {
                 NSLog(@"succeed");
                 cell.imgVwValue.image = image;
             }
         }];
        if(rewardRedemption.withInPeriod == 0)
        {
            cell.lblCountDown.text = [NSString stringWithFormat:@"ใช้ได้ 1 ครั้ง ภายใน %@",[Utility dateToString:rewardRedemption.usingEndDate toFormat:@"d MMM yyyy"]];
        }

        
        
        
        
        
        if (!_lastItemReached && item == [_rewardRedemptionList count]-1)
        {
            UserAccount *userAccount = [UserAccount getCurrentUserAccount];
            RewardPoint *rewardPointSpent = _rewardPointList[item];
            [self.homeModel downloadItems:dbRewardPointSpentMore withData:@[rewardPointSpent,userAccount]];
        }
        
        
        return cell;
    }
    else
    {
        CustomTableViewCellReward *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierReward];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        RewardRedemption *rewardRedemption = _rewardRedemptionUsedList[item];
        cell.lblHeader.text = rewardRedemption.header;
        [cell.lblHeader sizeToFit];
        cell.lblHeaderHeight.constant = cell.lblHeader.frame.size.height>70?70:cell.lblHeader.frame.size.height;
        
        
        cell.lblSubTitle.text = rewardRedemption.subTitle;
        [cell.lblSubTitle sizeToFit];
        cell.lblSubTitleHeight.constant = 70-8-cell.lblHeaderHeight.constant<0?0:70-8-cell.lblHeaderHeight.constant;
        
        
        cell.lblRemark.text = [NSString stringWithFormat:@"🍄 %ld points",rewardRedemption.point];
        
        
        Branch *branch = [Branch getBranch:rewardRedemption.branchID];
        NSString *imageFileName = [Utility isStringEmpty:branch.imageUrl]?@"NoImage.jpg":branch.imageUrl;
        [self.homeModel downloadImageWithFileName:imageFileName completionBlock:^(BOOL succeeded, UIImage *image)
         {
             if (succeeded)
             {
                 NSLog(@"succeed");
                 cell.imgVwValue.image = image;
             }
         }];
        if(rewardRedemption.withInPeriod == 0)
        {
            cell.lblCountDown.text = [NSString stringWithFormat:@"หมดอายุเมื่อ %@",[Utility dateToString:rewardRedemption.usingEndDate toFormat:@"d MMM yyyy"]];
        }
        else
        {
            cell.lblCountDown.text = @"00:00:00";

        }

        
        
        
        if (!_lastItemReachedUsed && item == [_rewardRedemptionUsedList count]-1)
        {
            UserAccount *userAccount = [UserAccount getCurrentUserAccount];
            RewardPoint *rewardPointSpent = _rewardPointUsedList[item];
            [self.homeModel downloadItems:dbRewardPointSpentUsedMore withData:@[rewardPointSpent,userAccount]];
        }
        
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;

    {
        return 112+25;
    }
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
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

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
    [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;

    
    if(segConValue.selectedSegmentIndex == 0)
    {
        _rewardRedemption = _rewardRedemptionList[item];
        _rewardPointSpent = _rewardPointList[item];
        _promoCode = _promoCodeList[item];
    }
    else
    {
        _rewardRedemption = _rewardRedemptionUsedList[item];
        _rewardPointSpent = _rewardPointUsedList[item];
        _promoCode = _promoCodeUsedList[item];
    }
    [self performSegueWithIdentifier:@"segRewardRedemption" sender:self];
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToReward" sender:self];
}

- (IBAction)segmentControlChanged:(id)sender
{
    if(segConValue.selectedSegmentIndex == 1)
    {
        if([_rewardRedemptionUsedList count] == 0)
        {
            UserAccount *userAccount = [UserAccount getCurrentUserAccount];
            [self.homeModel downloadItems:dbRewardPointSpentUsed withData:userAccount];
            [self loadingOverlayView];
        }
        else
        {
            //sort by หมดอายุก่อนหลัง
            //ให้เช็คว่า แยกเป็น 2 กรณี 1.within=0-->sort by rewardRedemption.usingEndDate desc, rewardPoint.modifiedDate Desc 2.countDown-->sort by within+reward.modifiedDate>rewardRedemption.usingEndDate?rewardRedemption.usingEndDate:within+reward.modifiedDate
            for(int i=0; i<[_rewardRedemptionUsedList count]; i++)
            {
                RewardRedemption *rewardRedemption = _rewardRedemptionUsedList[i];
                RewardPoint *rewardPoint = _rewardPointUsedList[i];

                
                if(rewardRedemption.withInPeriod == 0)
                {
                    rewardRedemption.sortDate = [Utility setEndOfTheDay:rewardRedemption.usingEndDate];
                }
                else
                {
                    NSDate *modifiedDateAddWithInPeriod = [Utility addSecond:rewardPoint.modifiedDate numberOfSecond:rewardRedemption.withInPeriod];
                    
                    NSTimeInterval seconds = [modifiedDateAddWithInPeriod timeIntervalSinceDate:[Utility setEndOfTheDay:rewardRedemption.usingEndDate]];
                    if(seconds > 0)
                    {
                        rewardRedemption.sortDate = [Utility setEndOfTheDay:rewardRedemption.usingEndDate];
                    }
                    else
                    {
                        rewardRedemption.sortDate = modifiedDateAddWithInPeriod;
                    }
                }
            }
            _rewardRedemptionUsedList = [RewardRedemption sort:_rewardRedemptionUsedList];
            
            
            for(PromoCode *item in _promoCodeUsedList)
            {
                RewardRedemption *rewardRedemption = [RewardRedemption getRewardRedemption:item.rewardRedemptionID];
                item.rewardRedemptionSortDate = rewardRedemption.sortDate;
            }
            _promoCodeUsedList = [PromoCode sort:_promoCodeUsedList];
            
            
            for(RewardPoint *item in _rewardPointUsedList)
            {
                PromoCode *promoCode = [PromoCode getPromoCode:item.promoCodeID];
                item.rewardRedemptionSortDate = promoCode.rewardRedemptionSortDate;
            }
            _promoCodeUsedList = [PromoCode sort:_promoCodeUsedList];
            
            
            [tbvData reloadData];
        }
    }
    else
    {
        [tbvData reloadData];
    }
}

-(void)itemsDownloaded:(NSArray *)items
{
    [self removeOverlayViews];
    if(segConValue.selectedSegmentIndex == 0)
    {
        NSMutableArray *rewardPointList = items[0];
        NSMutableArray *promoCodeList = items[1];
        NSMutableArray *rewardRedemptionList = items[2];
        
        
        
        if([rewardPointList count]==0)
        {
            _lastItemReached = YES;
        }
        else
        {
            for(int i=0; i<[rewardPointList count]; i++)
            {
                RewardRedemption *rewardRedemption = rewardRedemptionList[i];
                RewardPoint *rewardPoint = rewardPointList[i];
                NSTimeInterval seconds = [[Utility currentDateTime] timeIntervalSinceDate:rewardPoint.modifiedDate];
                NSInteger timeToCountDown = rewardRedemption.withInPeriod - seconds >= 0?rewardRedemption.withInPeriod - seconds:0;
                if(rewardRedemption.withInPeriod == 0)
                {
                    timeToCountDown = 0;
                }
                [_timeToCountDownList addObject:[NSNumber numberWithInteger:timeToCountDown]];
                NSNumber *objIndex = [NSNumber numberWithInt:i];
                NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer:) userInfo:objIndex repeats:YES];
                [_timerList addObject:timer];
                
                

                NSTimeInterval seconds2 = [[Utility setEndOfTheDay:rewardRedemption.usingEndDate] timeIntervalSinceDate:[Utility currentDateTime]];
                seconds2 = seconds2>0?seconds2:0;
                NSTimer *timer2 = [NSTimer scheduledTimerWithTimeInterval:seconds2 target:self selector:@selector(updateTimer2:) userInfo:objIndex repeats:NO];
                [_timerUsedList addObject:timer2];
            }
            
            
            [_rewardPointList addObjectsFromArray:rewardPointList];
            [_promoCodeList addObjectsFromArray:promoCodeList];
            [_rewardRedemptionList addObjectsFromArray:rewardRedemptionList];
        }
    }
    else
    {
        NSMutableArray *rewardPointUsedList = items[0];
        NSMutableArray *promoCodeUsedList = items[1];
        NSMutableArray *rewardRedemptionUsedList = items[2];
        
        
        if([rewardPointUsedList count]==0)
        {
            _lastItemReachedUsed = YES;
        }
        else
        {
            
            [_rewardPointUsedList addObjectsFromArray:rewardPointUsedList];
            [_promoCodeUsedList addObjectsFromArray:promoCodeUsedList];
            [_rewardRedemptionUsedList addObjectsFromArray:rewardRedemptionUsedList];
            
            
            //sort
            //sort by หมดอายุก่อนหลัง
            //ให้เช็คว่า แยกเป็น 2 กรณี 1.within=0-->sort by rewardRedemption.usingEndDate desc, rewardPoint.modifiedDate Desc 2.countDown-->sort by within+reward.modifiedDate>rewardRedemption.usingEndDate?rewardRedemption.usingEndDate:within+reward.modifiedDate
            for(int i=0; i<[_rewardRedemptionUsedList count]; i++)
            {
                RewardRedemption *rewardRedemption = _rewardRedemptionUsedList[i];
                RewardPoint *rewardPoint = _rewardPointUsedList[i];
                
                
                if(rewardRedemption.withInPeriod == 0)
                {
                    rewardRedemption.sortDate = [Utility setEndOfTheDay:rewardRedemption.usingEndDate];
                }
                else
                {
                    NSDate *modifiedDateAddWithInPeriod = [Utility addSecond:rewardPoint.modifiedDate numberOfSecond:rewardRedemption.withInPeriod];
                    
                    NSTimeInterval seconds = [modifiedDateAddWithInPeriod timeIntervalSinceDate:[Utility setEndOfTheDay:rewardRedemption.usingEndDate]];
                    if(seconds > 0)
                    {
                        rewardRedemption.sortDate = [Utility setEndOfTheDay:rewardRedemption.usingEndDate];
                    }
                    else
                    {
                        rewardRedemption.sortDate = modifiedDateAddWithInPeriod;
                    }
                }
            }
            _rewardRedemptionUsedList = [RewardRedemption sort:_rewardRedemptionUsedList];
            
            
            for(PromoCode *item in _promoCodeUsedList)
            {
                RewardRedemption *rewardRedemption = [RewardRedemption getRewardRedemption:item.rewardRedemptionID];
                item.rewardRedemptionSortDate = rewardRedemption.sortDate;
            }
            _promoCodeUsedList = [PromoCode sort:_promoCodeUsedList];
            
            
            for(RewardPoint *item in _rewardPointUsedList)
            {
                PromoCode *promoCode = [PromoCode getPromoCode:item.promoCodeID];
                item.rewardRedemptionSortDate = promoCode.rewardRedemptionSortDate;
            }
            _promoCodeUsedList = [PromoCode sort:_promoCodeUsedList];
            
        }
    }
    
    [tbvData reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"segRewardRedemption"])
    {
        RewardRedemptionViewController *vc = segue.destinationViewController;
        vc.rewardPoint = rewardPoint;
        vc.rewardRedemption = _rewardRedemption;
        vc.rewardPointSpent = _rewardPointSpent;
        vc.promoCode = _promoCode;
        vc.fromMenuMyReward = 1;
    }
}

-(void)updateTimer:(NSTimer *)timer
{
    NSInteger index = [timer.userInfo integerValue];
    _timeToCountDownList[index] = @([_timeToCountDownList[index] integerValue] - 1);
    _timeToCountDownList[index] = [_timeToCountDownList[index] integerValue] < 0?@0:_timeToCountDownList[index];
    
    [self populateLabelwithTime:[_timeToCountDownList[index] integerValue] index:index];
    if([_timeToCountDownList[index] integerValue] == 0)
    {
        [timer invalidate];
        
        
        RewardPoint *rewardPoint = _rewardPointList[index];
        PromoCode *promoCode = _promoCodeList[index];
        RewardRedemption *rewardRedemption = _rewardRedemptionList[index];
        
        
        if(rewardRedemption.withInPeriod == 0)
        {
            return;
        }
        
        
        
        
        for(NSInteger i=0; i<[_timerList count]; i++)
        {
            NSTimer *timerCountDown = _timerList[i];
            NSTimer *timer2 = _timerUsedList[i];
            
            [timerCountDown invalidate];
            [timer2 invalidate];
        }
        
        
        [_rewardPointUsedList addObject:rewardPoint];
        [_promoCodeUsedList addObject:promoCode];
        [_rewardRedemptionUsedList addObject:rewardRedemption];
        [_rewardPointList removeObject:rewardPoint];
        [_promoCodeList removeObject:promoCode];
        [_rewardRedemptionList removeObject:rewardRedemption];
        
        
        
        [_timerList removeAllObjects];
        [_timerUsedList removeAllObjects];
        [_timeToCountDownList removeAllObjects];
        for(int i=0; i<[_rewardPointList count]; i++)
        {
            RewardRedemption *rewardRedemption = _rewardRedemptionList[i];
            RewardPoint *rewardPoint = _rewardPointList[i];
            NSTimeInterval seconds = [[Utility currentDateTime] timeIntervalSinceDate:rewardPoint.modifiedDate];
            NSInteger timeToCountDown = rewardRedemption.withInPeriod - seconds >= 0?rewardRedemption.withInPeriod - seconds:0;
            if(rewardRedemption.withInPeriod == 0)
            {
                timeToCountDown = 0;
            }
            [_timeToCountDownList addObject:[NSNumber numberWithInteger:timeToCountDown]];
            NSNumber *objIndex = [NSNumber numberWithInt:i];
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer:) userInfo:objIndex repeats:YES];
            [_timerList addObject:timer];
            
            
            
            NSTimeInterval seconds2 = [[Utility setEndOfTheDay:rewardRedemption.usingEndDate] timeIntervalSinceDate:[Utility currentDateTime]];
            seconds2 = seconds2>0?seconds2:0;
            NSTimer *timer2 = [NSTimer scheduledTimerWithTimeInterval:seconds2 target:self selector:@selector(updateTimer2:) userInfo:objIndex repeats:NO];
            [_timerUsedList addObject:timer2];
        }
        
        
        [tbvData reloadData];
    }
}

-(void)updateTimer2:(NSTimer *)timer//---> สำหรับหมดอายุ ตาม enddate , พดหมดอายุก็ย้ายไป ถูกใช้แล้ว ควรจะหยุด timer ตัว countdown ด้วย  ,---> กรณีตัวย้ายไปถูกใช้แล้ว ให้ stop all timer and start new timers
{
    NSInteger index = [timer.userInfo integerValue];
//    [timer invalidate];
    
    
//    NSTimer *timerCountDown = _timerList[index];
//    [timerCountDown invalidate];
    
    
    
    RewardPoint *rewardPoint = _rewardPointList[index];
    PromoCode *promoCode = _promoCodeList[index];
    RewardRedemption *rewardRedemption = _rewardRedemptionList[index];
    
    
    for(NSInteger i=0; i<[_timerList count]; i++)
    {
        NSTimer *timerCountDown = _timerList[i];
        NSTimer *timer2 = _timerUsedList[i];
        
        [timerCountDown invalidate];
        [timer2 invalidate];
    }
    
    
    [_rewardPointUsedList addObject:rewardPoint];
    [_promoCodeUsedList addObject:promoCode];
    [_rewardRedemptionUsedList addObject:rewardRedemption];
    [_rewardPointList removeObject:rewardPoint];
    [_promoCodeList removeObject:promoCode];
    [_rewardRedemptionList removeObject:rewardRedemption];
    
    
    
    [_timerList removeAllObjects];
    [_timerUsedList removeAllObjects];
    [_timeToCountDownList removeAllObjects];
    for(int i=0; i<[_rewardPointList count]; i++)
    {
        RewardRedemption *rewardRedemption = _rewardRedemptionList[i];
        RewardPoint *rewardPoint = _rewardPointList[i];
        NSTimeInterval seconds = [[Utility currentDateTime] timeIntervalSinceDate:rewardPoint.modifiedDate];
        NSInteger timeToCountDown = rewardRedemption.withInPeriod - seconds >= 0?rewardRedemption.withInPeriod - seconds:0;
        if(rewardRedemption.withInPeriod == 0)
        {
            timeToCountDown = 0;
        }
        [_timeToCountDownList addObject:[NSNumber numberWithInteger:timeToCountDown]];
        NSNumber *objIndex = [NSNumber numberWithInt:i];
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer:) userInfo:objIndex repeats:YES];
        [_timerList addObject:timer];
        
        
        
        NSTimeInterval seconds2 = [[Utility setEndOfTheDay:rewardRedemption.usingEndDate] timeIntervalSinceDate:[Utility currentDateTime]];
        seconds2 = seconds2>0?seconds2:0;
        NSTimer *timer2 = [NSTimer scheduledTimerWithTimeInterval:seconds2 target:self selector:@selector(updateTimer2:) userInfo:objIndex repeats:NO];
        [_timerUsedList addObject:timer2];
    }
    
    
    
    [tbvData reloadData];
}

- (void)populateLabelwithTime:(NSInteger)seconds index:(NSInteger)index
{
    if(segConValue.selectedSegmentIndex == 0)
    {
        NSInteger minutes = seconds / 60;
        NSInteger hours = minutes / 60;
        
        seconds -= minutes * 60;
        minutes -= hours * 60;
        
        
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        CustomTableViewCellReward *cell = [tbvData cellForRowAtIndexPath:indexPath];
        RewardRedemption *rewardRedemption = _rewardRedemptionList[index];
        if(rewardRedemption.withInPeriod == 0)
        {
            cell.lblCountDown.text = [NSString stringWithFormat:@"ใช้ได้ 1 ครั้ง ภายใน %@",[Utility dateToString:rewardRedemption.usingEndDate toFormat:@"d MMM yyyy"]];
        }
        else
        {
            cell.lblCountDown.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hours, minutes, seconds];
        }
    }
    
}
@end
