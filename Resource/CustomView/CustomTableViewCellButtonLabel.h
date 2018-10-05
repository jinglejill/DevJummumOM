//
//  CustomTableViewCellButtonLabel.h
//  DevJummumOM
//
//  Created by Thidaporn Kijkamjai on 3/10/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellButtonLabel : UITableViewCell
    @property (strong, nonatomic) IBOutlet UIButton *btnValue;
    @property (strong, nonatomic) IBOutlet UILabel *lblValue;
    @property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
    
@end
