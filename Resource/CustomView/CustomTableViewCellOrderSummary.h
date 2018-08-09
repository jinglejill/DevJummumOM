//
//  CustomTableViewCellOrderSummary.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 11/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellOrderSummary : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblQuantity;
@property (strong, nonatomic) IBOutlet UILabel *lblMenuName;
@property (strong, nonatomic) IBOutlet UILabel *lblNote;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalAmount;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblMenuNameHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lblNoteHeight;

@end
