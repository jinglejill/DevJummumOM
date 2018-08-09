//
//  CustomTableViewCellQuantity.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 23/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellQuantity : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextField *txtQuantity;
@property (strong, nonatomic) IBOutlet UIStepper *stpValue;


@end
