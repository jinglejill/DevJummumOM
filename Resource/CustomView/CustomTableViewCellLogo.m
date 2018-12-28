//
//  CustomTableViewCellLogo.m
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 7/7/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomTableViewCellLogo.h"

@implementation CustomTableViewCellLogo

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    self.imgVwValue.image = [UIImage imageNamed:@"NoImage.jpg"];
}
@end
