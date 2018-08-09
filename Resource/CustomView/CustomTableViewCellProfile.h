//
//  CustomTableViewCellProfile.h
//  JummumShop
//
//  Created by Thidaporn Kijkamjai on 5/6/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellProfile : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgValue;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;

@property (strong, nonatomic) IBOutlet UIView *vwContent;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *singleTapGestureRecognizer;

@end
