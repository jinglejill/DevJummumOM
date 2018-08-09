//
//  HotDealViewController.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 23/4/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "HotDealViewController.h"
#import "CustomTableViewCellPromoBanner.h"
#import "CustomTableViewCellPromoThumbNail.h"
#import "HotDeal.h"
#import "Branch.h"


@interface HotDealViewController ()
{
    NSMutableArray *_hotDealList;
    NSMutableArray *_filterHotDealList;
}
@property (nonatomic)        BOOL           searchBarActive;
@end

@implementation HotDealViewController
static float const SEARCH_BAR_HEIGHT = 56;
static NSString * const reuseIdentifierPromoBanner = @"CustomTableViewCellPromoBanner";
static NSString * const reuseIdentifierPromoThumbNail = @"CustomTableViewCellPromoThumbNail";


@synthesize tbvData;
@synthesize searchBar;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UserAccount *userAccount = [UserAccount getCurrentUserAccount];
    [self.homeModel downloadItems:dbHotDeal withData:userAccount];
    tbvData.delegate = self;
    tbvData.dataSource = self;
    
    searchBar.delegate = self;

    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierPromoBanner bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierPromoBanner];
    }
    {
        UINib *nib = [UINib nibWithNibName:reuseIdentifierPromoThumbNail bundle:nil];
        [tbvData registerNib:nib forCellReuseIdentifier:reuseIdentifierPromoThumbNail];
    }
    
}

///tableview section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return [_filterHotDealList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    HotDeal *hotDeal = _filterHotDealList[section];
    if(hotDeal.branchID == 0)
    {
        CustomTableViewCellPromoBanner *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierPromoBanner];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lblHeader.text = hotDeal.header;
        [cell.lblHeader sizeToFit];
        cell.lblHeaderHeight.constant = cell.lblHeader.frame.size.height>34?34:cell.lblHeader.frame.size.height;
        
        
        
        
        
        cell.lblSubTitle.text = hotDeal.subTitle;
        [cell.lblSubTitle sizeToFit];
        cell.lblSubTitleHeight.constant = cell.lblSubTitle.frame.size.height>29?29:cell.lblSubTitle.frame.size.height;
        
        
        
        NSString *imageFileName = [Utility isStringEmpty:hotDeal.imageUrl]?@"NoImage.jpg":hotDeal.imageUrl;
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
        
        
        return cell;
    }
    else
    {
        CustomTableViewCellPromoThumbNail *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierPromoThumbNail];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lblHeader.text = hotDeal.header;
        [cell.lblHeader sizeToFit];
        cell.lblHeaderHeight.constant = cell.lblHeader.frame.size.height>90?90:cell.lblHeader.frame.size.height;
        
        
        cell.lblSubTitle.text = hotDeal.subTitle;
        [cell.lblSubTitle sizeToFit];
        cell.lblSubTitleHeight.constant = 90-8-cell.lblHeaderHeight.constant<0?0:90-8-cell.lblHeaderHeight.constant;
        
        
        
        NSString *imageFileName = [Utility isStringEmpty:hotDeal.imageUrl]?@"NoImage.jpg":hotDeal.imageUrl;
        [self.homeModel downloadImageWithFileName:imageFileName completionBlock:^(BOOL succeeded, UIImage *image)
         {
             if (succeeded)
             {
                 NSLog(@"succeed");
                 cell.imgVwValue.image = image;                 
             }
         }];
        
        
        return cell;
    }
    
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    HotDeal *hotDeal = _filterHotDealList[section];
    if(hotDeal.branchID == 0)
    {
        HotDeal *hotDeal = _filterHotDealList[section];
        
        CustomTableViewCellPromoBanner *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierPromoBanner];
        cell.lblHeader.text = hotDeal.header;
        [cell.lblHeader sizeToFit];
        cell.lblHeaderHeight.constant = cell.lblHeader.frame.size.height>34?34:cell.lblHeader.frame.size.height;
        
        
        
        
        
        cell.lblSubTitle.text = hotDeal.subTitle;
        [cell.lblSubTitle sizeToFit];
        cell.lblSubTitleHeight.constant = cell.lblSubTitle.frame.size.height>29?29:cell.lblSubTitle.frame.size.height;
        
        
        
        NSString *imageFileName = [Utility isStringEmpty:hotDeal.imageUrl]?@"NoImage.jpg":hotDeal.imageUrl;
        [self.homeModel downloadImageWithFileName:imageFileName completionBlock:^(BOOL succeeded, UIImage *image)
         {
             if (succeeded)
             {
                 NSLog(@"succeed");
                 cell.imgVwValue.image = image;
             }
         }];
        cell.imgVwValueHeight.constant = (cell.frame.size.width -2*16)/16*9;

        
        return 11+cell.lblHeaderHeight.constant+8+cell.lblSubTitleHeight.constant+8+cell.imgVwValueHeight.constant+11;
    }
    else
    {
        return 112;
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
    NSInteger section = indexPath.section;
    NSInteger item = indexPath.item;
    
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

#pragma mark - search

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    if([Utility isStringEmpty:searchText])
    {
        _filterHotDealList = _hotDealList;
        [tbvData reloadData];
    }
    else
    {
        NSPredicate *resultPredicate   = [NSPredicate predicateWithFormat:@"(_branchName contains[c] %@)", searchText];
        _filterHotDealList = [[_hotDealList filteredArrayUsingPredicate:resultPredicate] mutableCopy];
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
        [tbvData reloadData];
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

-(void)itemsDownloaded:(NSArray *)items
{
    _hotDealList = items[0];
    _filterHotDealList = _hotDealList;
    for(HotDeal *item in _filterHotDealList)
    {
        Branch *branch = [Branch getBranch:item.branchID];
        item.branchName = branch.name;
    }
    
    [tbvData reloadData];
}
@end
