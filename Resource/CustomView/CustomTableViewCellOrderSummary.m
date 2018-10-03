//
//  CustomTableViewCellOrderSummary.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 11/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomTableViewCellOrderSummary.h"
#import "Utility.h"


@implementation CustomTableViewCellOrderSummary

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
    
- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.lblQuantity.textColor = cSystem1;
    self.lblMenuName.textColor = cSystem4;
    self.lblNote.textColor = cSystem4;
}

@end
