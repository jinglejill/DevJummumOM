//
//  CustomTableViewCellOrder.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 24/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellOrder : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgMenuPic;
@property (strong, nonatomic) IBOutlet UILabel *lblMenuName;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblQuantity;
@property (strong, nonatomic) IBOutlet UITableView *tbvNote;
@property (strong, nonatomic) IBOutlet UIButton *btnAddQuantity;
@property (strong, nonatomic) IBOutlet UIButton *btnDeleteQuantity;
@property (strong, nonatomic) IBOutlet UIImageView *imgExpandCollapse;


@property (nonatomic) NSInteger stepperValue;
@end
