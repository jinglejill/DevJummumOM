//
//  RewardDetailViewController.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 30/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "RewardDetailViewController.h"
#import "RewardRedemptionViewController.h"
#import "CustomTableViewCellRewardDetail.h"
#import "CustomTableViewCellLabel.h"
#import "PromoCode.h"


@interface RewardDetailViewController ()
{
    RewardPoint *_rewardPointSpent;
    PromoCode *_promoCode;
    NSInteger _expandCollapse;//1=expand,0=collapse
}
@end

@implementation RewardDetailViewController
static NSString * const reuseIdentifierRewardDetail = @"CustomTableViewCellRewardDetail";
static NSString * const reuseIdentifierLabel = @"CustomTableViewCellLabel";



@synthesize tbvData;
@synthesize rewardPoint;
@synthesize rewardRedemption;


-(IBAction)unwindToRewardDetail:(UIStoryboardSegue *)segue
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    _expandCollapse = 1;
    tbvData.delegate = self;
    tbvData.dataSource = self;
    
    
    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierRewardDetail bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierRewardDetail];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierLabel bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierLabel];
    }
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    if(item == 0)
    {
        CustomTableViewCellRewardDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierRewardDetail];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    
        
        
        NSString *imageFileName = [Utility isStringEmpty:rewardRedemption.imageUrl]?@"NoImage.jpg":rewardRedemption.imageUrl;
        [self.homeModel downloadImageWithFileName:imageFileName completionBlock:^(BOOL succeeded, UIImage *image)
         {
             if (succeeded)
             {
                 NSLog(@"succeed");
                 cell.imgVwValue.image = image;
             }
         }];
        cell.imgVwValueHeight.constant = (cell.frame.size.width -2*16)/16*9;
        cell.imgVwValue.contentMode = UIViewContentModeScaleAspectFit;
        
        
        
        cell.lblHeader.text = rewardRedemption.header;
        [cell.lblHeader sizeToFit];
        cell.lblHeaderHeight.constant = cell.lblHeader.frame.size.height;
        
        
        cell.lblSubTitle.text = rewardRedemption.subTitle;
        [cell.lblSubTitle sizeToFit];
        cell.lblSubTitleHeight.constant = cell.lblSubTitle.frame.size.height;
        
        
        cell.lblRemark.text = [NSString stringWithFormat:@"🍄 %ld points",rewardRedemption.point];
        
        
        
        return cell;
    }
    else if(item == 1)
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
        CustomTableViewCellRewardDetail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierRewardDetail];
        
        
        NSString *imageFileName = [Utility isStringEmpty:rewardRedemption.imageUrl]?@"NoImage.jpg":rewardRedemption.imageUrl;
        [self.homeModel downloadImageWithFileName:imageFileName completionBlock:^(BOOL succeeded, UIImage *image)
         {
             if (succeeded)
             {
                 NSLog(@"succeed");
                 cell.imgVwValue.image = image;
             }
         }];
        cell.imgVwValueHeight.constant = (cell.frame.size.width -2*16)/16*9;
        
        
        
        cell.lblHeader.text = rewardRedemption.header;
        [cell.lblHeader sizeToFit];
        cell.lblHeaderHeight.constant = cell.lblHeader.frame.size.height;
        
        
        cell.lblSubTitle.text = rewardRedemption.subTitle;
        [cell.lblSubTitle sizeToFit];
        cell.lblSubTitleHeight.constant = cell.lblSubTitle.frame.size.height;
        
        
        
       
        return 11+cell.imgVwValueHeight.constant+20+cell.lblHeaderHeight.constant+8+cell.lblSubTitleHeight.constant+8+18+11;
    }
    else
    {
        CustomTableViewCellLabel *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierLabel];
        
        
        cell.lblTextLabel.text = rewardRedemption.termsConditions;
        [cell.lblTextLabel sizeToFit];
        cell.lblTextLabelHeight.constant = cell.lblTextLabel.frame.size.height;
        
        return 49+cell.lblTextLabelHeight.constant+20;
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"segRewardRedemption"])
    {
        RewardRedemptionViewController *vc = segue.destinationViewController;
        vc.rewardPoint = rewardPoint;
        vc.rewardRedemption = rewardRedemption;
        vc.rewardPointSpent = _rewardPointSpent;
        vc.promoCode = _promoCode;
    }
}

- (IBAction)redeemReward:(id)sender
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:
     [UIAlertAction actionWithTitle:@"ยืนยันการรับสิทธิ์"
                              style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
      {
          if(rewardPoint.point < rewardRedemption.point)
          {
              [self showAlert:@"จำนวนแต้มสะสมไม่เพียงพอ" message:@""];
          }
          else
          {
              UserAccount *userAccount = [UserAccount getCurrentUserAccount];
              _rewardPointSpent = [[RewardPoint alloc]initWithMemberID:userAccount.userAccountID receiptID:0 point:rewardRedemption.point status:-1 promoCodeID:0];
              [self.homeModel insertItems:dbRewardPoint withData:@[_rewardPointSpent,rewardRedemption] actionScreen:@"insert rewardPointSpent"];
              [self loadingOverlayView];
          }
          
          
          
      }]];
    [alert addAction:
     [UIAlertAction actionWithTitle:@"ยกเลิก"
                              style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
      {
      }]];
    
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToReward" sender:self];
}

-(void)itemsInsertedWithReturnData:(NSArray *)items
{
    [self removeOverlayViews];
    NSMutableArray *promoCodeList = items[0];
    if([promoCodeList count]>0)
    {
        rewardPoint.point -= rewardRedemption.point;
        _promoCode = promoCodeList[0];
        [self performSegueWithIdentifier:@"segRewardRedemption" sender:self];
    }
    else
    {
        [self showAlert:@"จำนวนสิทธิ์ครบแล้ว" message:@""];
    }
}

-(void)expandCollapse:(id)sender
{
    _expandCollapse = !_expandCollapse;
    [tbvData reloadData];
    
//    //reload cell
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
//    CustomTableViewCellLabel *cell = [tbvData cellForRowAtIndexPath:indexPath];
//
//
//    cell.lblTextLabel.text = rewardRedemption.termsConditions;
//    [cell.lblTextLabel sizeToFit];
//    cell.lblTextLabelHeight.constant = _expandCollapse?cell.lblTextLabel.frame.size.height-40:0;
//
//
//
//    UIImage *image = _expandCollapse?[UIImage imageNamed:@"collapse2.png"]:[UIImage imageNamed:@"expand2.png"];
//    [cell.btnValue setBackgroundImage:image forState:UIControlStateNormal];
////    [cell.btnValue addTarget:self action:@selector(expandCollapse:) forControlEvents:UIControlEventTouchUpInside];
}
@end
