//
//  CustomTableViewCellLabelTextView.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 13/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellLabelTextView : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UITextView *txvValue;

@end
