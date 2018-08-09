//
//  CustomTableViewCellOrder.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 24/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomTableViewCellOrder.h"

@implementation CustomTableViewCellOrder

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
    self.imgMenuPic.image = [UIImage imageNamed:@"NoImage.jpg"];
    
}
@end
