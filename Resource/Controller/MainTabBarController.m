//
//  MainTabBarController.m
//  Eventoree
//
//  Created by Thidaporn Kijkamjai on 8/4/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "MainTabBarController.h"
#import "CustomerKitchenViewController.h"
#import "RunningReceiptViewController.h"
#import "Setting.h"
#import "Receipt.h"


@interface MainTabBarController ()
{
    BOOL _switchToRunningReceiptTab;
    Receipt *_selectedReceipt;
}
@end

@implementation MainTabBarController


-(IBAction)unwindToMainTabBar:(UIStoryboardSegue *)segue
{
    CustomViewController *vc = segue.sourceViewController;
    _switchToRunningReceiptTab = 1;
    _selectedReceipt = vc.selectedReceipt;
    [self viewDidAppear:NO];
    NSLog(@"unwindToMainTabBar");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Prompt-Regular" size:11.0f]} forState:UIControlStateNormal];
    
    [[UITabBar appearance] setBarTintColor:cSystem3];
    
    
    BOOL hasBuffetMenu = [[Setting getSettingValueWithKeyName:@"hasBuffetMenu"] boolValue];
    if(!hasBuffetMenu)
    {
        NSMutableArray *items = [NSMutableArray arrayWithArray:self.viewControllers];
        [items removeObjectAtIndex:1];
        [self setViewControllers:items animated:NO];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear mainTabBar");
    [super viewDidAppear:animated];
    
    if(_switchToRunningReceiptTab)
    {
        _switchToRunningReceiptTab = 0;
        self.selectedIndex = 1;
        
        
        RunningReceiptViewController *vc = (RunningReceiptViewController *)self.selectedViewController;
        vc.selectedReceipt = _selectedReceipt;
        [vc reloadTableView];
    }
}
@end
