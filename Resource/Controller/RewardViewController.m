//
//  RewardViewController.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 4/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "RewardViewController.h"
#import "RewardDetailViewController.h"
#import "MyRewardViewController.h"
#import "CustomTableViewCellSearchBar.h"
#import "CustomTableViewCellReward.h"
#import "CustomTableViewHeaderButton.h"
#import "RewardPoint.h"
#import "UserAccount.h"
#import "RewardRedemption.h"
#import "Branch.h"
#import "Utility.h"


@interface RewardViewController ()
{
    RewardPoint *_rewardPoint;
    NSMutableArray *_rewardRedemptionList;
    NSMutableArray *_filterRewardRedemptionList;
    RewardRedemption *_rewardRedemption;
}

@property (nonatomic)        BOOL           searchBarActive;
@end

@implementation RewardViewController
static float const SEARCH_BAR_HEIGHT = 56;
static NSString * const reuseIdentifierSearchBar = @"CustomTableViewCellSearchBar";
static NSString * const reuseIdentifierReward = @"CustomTableViewCellReward";
static NSString * const reuseIdentifierHeaderButton = @"CustomTableViewHeaderButton";


@synthesize tbvData;


-(IBAction)unwindToReward:(UIStoryboardSegue *)segue
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    UITableViewCell *cell = [tbvData cellForRowAtIndexPath:indexPath];
    NSInteger point = (int)floor(_rewardPoint.point);
    cell.detailTextLabel.text = [NSString stringWithFormat:@"🍄 %ld points",point];
}

-(void)loadView
{
    [super loadView];
    [self loadingOverlayView];
    UserAccount *userAccount = [UserAccount getCurrentUserAccount];
    [self.homeModel downloadItems:dbRewardPoint withData:userAccount];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tbvData.delegate = self;
    tbvData.dataSource = self;

    
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierSearchBar bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierSearchBar];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierReward bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierReward];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierHeaderButton bundle:nil];
        [tbvData registerNib:nib forHeaderFooterViewReuseIdentifier:reuseIdentifierHeaderButton];
    }
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 3;
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if(section == 0)
    {
        return 1;
    }
    else if(section == 1)
    {
        return 2;
    }
    else
    {
        return [_filterRewardRedemptionList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    if(section == 0)
    {
        CustomTableViewCellSearchBar *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierSearchBar];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.sbText.delegate = self;
        cell.sbText.tag = 300;
        cell.sbText.placeholder = @"ค้นหา Reward";
        
        
        return cell;
    }
    else if(section == 1)
    {
        if(item == 0)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            }
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"แต้มสะสม";
            cell.textLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
            NSInteger point = (int)floor(_rewardPoint.point);
            cell.detailTextLabel.text = [NSString stringWithFormat:@"🍄 %ld points",point];
            
            cell.detailTextLabel.textColor = mGreen;
            
            
            return cell;
        }
        else
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            }
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"รางวัลของฉัน";
            cell.textLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
            
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            
            
            return cell;
        }
    }
    else
    {
        CustomTableViewCellReward *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierReward];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        RewardRedemption *rewardRedemption = _filterRewardRedemptionList[item];
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
        
        
        cell.lblCountDownTop.constant = 0;
        cell.lblCountDownHeight.constant = 0;
        
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if(section == 0)
    {
        return SEARCH_BAR_HEIGHT;
    }
    else if(section == 1)
    {
        return 44;
    }
    else if(section == 2)
    {
        return 112;
    }
    return 44;
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
//    return section == 0?0:35;
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
    if(section == 1 && item == 1)
    {
        [self performSegueWithIdentifier:@"segMyReward" sender:self];
    }
    else if(section == 2)
    {
        _rewardRedemption = _filterRewardRedemptionList[item];
        [self performSegueWithIdentifier:@"segRewardDetail" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"segRewardDetail"])
    {
        RewardDetailViewController *vc = segue.destinationViewController;
        vc.rewardPoint = _rewardPoint;
        vc.rewardRedemption = _rewardRedemption;
    }
    else if([segue.identifier isEqualToString:@"segMyReward"])
    {
        MyRewardViewController *vc = segue.destinationViewController;
        vc.rewardPoint = _rewardPoint;
    }
}

- (IBAction)goBack:(id)sender
{
    [self performSegueWithIdentifier:@"segUnwindToMe" sender:self];
}

-(void)itemsDownloaded:(NSArray *)items
{
    [self removeOverlayViews];
    NSMutableArray *rewardPointList = items[0];
    _rewardPoint = rewardPointList[0];
    
    
    _rewardRedemptionList = [items[1] mutableCopy];
    _filterRewardRedemptionList = _rewardRedemptionList;
    for(RewardRedemption *item in _filterRewardRedemptionList)
    {
        Branch *branch = [Branch getBranch:item.branchID];
        item.branchName = branch.name;
    }
    [tbvData reloadData];
}

#pragma mark - search

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    if([Utility isStringEmpty:searchText])
    {
        _filterRewardRedemptionList = _rewardRedemptionList;
        NSRange range = NSMakeRange(2, 1);
        NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
        [tbvData reloadSections:section withRowAnimation:UITableViewRowAnimationNone];

    }
    else
    {
        NSPredicate *resultPredicate   = [NSPredicate predicateWithFormat:@"(_branchName contains[c] %@)", searchText];
        _filterRewardRedemptionList = [[_rewardRedemptionList filteredArrayUsingPredicate:resultPredicate] mutableCopy];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // user did type something, check our datasource for text that looks the same
    if (searchText.length>0)
    {
        // search and reload data source
        self.searchBarActive = YES;
        [self filterContentForSearchText:searchText scope:@""];
        NSRange range = NSMakeRange(2, 1);
        NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
        [tbvData reloadSections:section withRowAnimation:UITableViewRowAnimationNone];

    }
    else
    {
        // if text length == 0
        // we will consider the searchbar is not active
        self.searchBarActive = NO;
        [self cancelSearching];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self cancelSearching];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchBarActive = YES;
    [self.view endEditing:YES];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // we used here to set self.searchBarActive = YES
    // but we'll not do that any more... it made problems
    // it's better to set self.searchBarActive = YES when user typed something
    //    [self.searchBar setShowsCancelButton:YES animated:YES];
    UISearchBar *sbText = [self.view viewWithTag:300];
    [sbText setShowsCancelButton:YES animated:YES];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // this method is being called when search btn in the keyboard tapped
    // we set searchBarActive = NO
    // but no need to reloadCollectionView
    //    self.searchBarActive = NO;
    
    //    [self.searchBar setShowsCancelButton:NO animated:YES];
    UISearchBar *sbText = [self.view viewWithTag:300];
    [sbText setShowsCancelButton:NO animated:YES];
}
-(void)cancelSearching
{
    UISearchBar *sbText = [self.view viewWithTag:300];
    self.searchBarActive = NO;
    [sbText resignFirstResponder];
    sbText.text  = @"";
    [self filterContentForSearchText:sbText.text scope:@""];
    
}

@end
