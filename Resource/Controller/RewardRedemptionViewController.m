//
//  RewardRedemptionViewController.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 1/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "RewardRedemptionViewController.h"
#import "CustomTableViewCellRedemption.h"
#import "CustomTableViewCellLabel.h"

@interface RewardRedemptionViewController ()
{
    NSTimer *timer;
    NSInteger _timeToCountDown;
    NSInteger _expandCollapse;//1=expand,0=collapse
}

@end

@implementation RewardRedemptionViewController
static NSString * const reuseIdentifierRedemption = @"CustomTableViewCellRedemption";
static NSString * const reuseIdentifierLabel = @"CustomTableViewCellLabel";


@synthesize lblCountDown;
@synthesize tbvData;
@synthesize rewardPoint;
@synthesize rewardRedemption;
@synthesize rewardPointSpent;
@synthesize promoCode;
@synthesize fromMenuMyReward;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tbvData.delegate = self;
    tbvData.dataSource = self;
    
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierRedemption bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierRedemption];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabel bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierLabel];
    }
    
    
    if(rewardRedemption.withInPeriod == 0)
    {
        lblCountDown.text = [NSString stringWithFormat:@"ใช้ได้ 1 ครั้ง ภายใน %@",[Utility dateToString:rewardRedemption.usingEndDate toFormat:@"d MMM yyyy"]];
    }
    else
    {
        NSTimeInterval seconds = [[Utility currentDateTime] timeIntervalSinceDate:rewardPointSpent.modifiedDate];
        _timeToCountDown = rewardRedemption.withInPeriod - seconds >= 0?rewardRedemption.withInPeriod - seconds:0;
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
    }
    
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    if(item == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        
        
        cell.textLabel.text = @"แต้มคงเหลือ";
        cell.textLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
        NSInteger point = floor(rewardPoint.point);
        cell.detailTextLabel.text = [NSString stringWithFormat:@"🍄 %ld points",point];
        
        cell.detailTextLabel.textColor = mGreen;
        
        return cell;
    }
    else if(item == 1)
    {
        CustomTableViewCellRedemption *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierRedemption];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.lblHeader.text = rewardRedemption.header;
        [cell.lblHeader sizeToFit];
        cell.lblHeaderHeight.constant = cell.lblHeader.frame.size.height;
        
        
        cell.lblSubTitle.text = rewardRedemption.subTitle;
        [cell.lblSubTitle sizeToFit];
        cell.lblSubTitleHeight.constant = cell.lblSubTitle.frame.size.height;
        
        
        cell.lblRemark.text = [NSString stringWithFormat:@"🍄 %ld points",rewardRedemption.point];
        cell.lblRedeemDate.text = [Utility dateToString:rewardPointSpent.modifiedDate toFormat:@"d MMM yyyy HH:mm"];
        cell.lblPromoCode.text = promoCode.code;
        cell.imgQrCode.image = [self generateQRCodeWithString:promoCode.code scale:5];
        
        
        
        return cell;
    }
    else if(item == 2)
    {
        CustomTableViewCellLabel *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.lblTextLabel.text = rewardRedemption.termsConditions;
        [cell.lblTextLabel sizeToFit];
//        cell.lblTextLabelHeight.constant = _expandCollapse?cell.lblTextLabel.frame.size.height-40:0;
        cell.lblTextLabelHeight.constant = _expandCollapse?cell.lblTextLabel.frame.size.height:0;
        
        
        
        UIImage *image = _expandCollapse?[UIImage imageNamed:@"collapse2.png"]:[UIImage imageNamed:@"expand2.png"];
        [cell.btnValue setBackgroundImage:image forState:UIControlStateNormal];
        [cell.btnValue addTarget:self action:@selector(expandCollapse:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = indexPath.item;
    
    if(item == 0)
    {
        return 44;
    }
    else if(item == 1)
    {
        CustomTableViewCellRedemption *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierRedemption];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.lblHeader.text = rewardRedemption.header;
        [cell.lblHeader sizeToFit];
        cell.lblHeaderHeight.constant = cell.lblHeader.frame.size.height;
        
        
        cell.lblSubTitle.text = rewardRedemption.subTitle;
        [cell.lblSubTitle sizeToFit];
        cell.lblSubTitleHeight.constant = cell.lblSubTitle.frame.size.height;
        
        
        
        return 20+cell.lblHeaderHeight.constant+8+cell.lblSubTitleHeight.constant+8+266-71;
    }
    else if(item == 2)
    {
        CustomTableViewCellLabel *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabel];
        
        
        cell.lblTextLabel.text = rewardRedemption.termsConditions;
        [cell.lblTextLabel sizeToFit];
        cell.lblTextLabelHeight.constant = cell.lblTextLabel.frame.size.height;
        
        
        return 49+cell.lblTextLabelHeight.constant+20;
//        return _expandCollapse?49+cell.lblTextLabelHeight.constant+20:cell.lblTextLabelHeight.constant;
    }
    
    
    return 0;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
    [cell setSeparatorInset:UIEdgeInsetsMake(16, 16, 16, 16)];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (IBAction)goBack:(id)sender
{
    if(fromMenuMyReward)
    {
        [self performSegueWithIdentifier:@"segUnwindToMyReward" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"segUnwindToReward" sender:self];
    }
    
}

-(void)updateTimer:(NSTimer *)timer {
    _timeToCountDown -= 1;
    _timeToCountDown = _timeToCountDown<0?0:_timeToCountDown;
    [self populateLabelwithTime:_timeToCountDown];
    if(_timeToCountDown == 0)
        [timer invalidate];
}

- (void)populateLabelwithTime:(NSInteger)seconds
{
    
    NSInteger minutes = seconds / 60;
    NSInteger hours = minutes / 60;
    
    seconds -= minutes * 60;
    minutes -= hours * 60;

    
    lblCountDown.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hours, minutes, seconds];
}

-(void)expandCollapse:(id)sender
{
    _expandCollapse = !_expandCollapse;
    [tbvData reloadData];    
}
@end
