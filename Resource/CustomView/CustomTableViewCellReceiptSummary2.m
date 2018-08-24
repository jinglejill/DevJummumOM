//
//  CustomTableViewCellReceiptSummary2.m
//  DevJummumOM
//
//  Created by Thidaporn Kijkamjai on 24/8/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "CustomTableViewCellReceiptSummary2.h"

@implementation CustomTableViewCellReceiptSummary2

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
    
    self.indicator.alpha = 0;
    [self.indicator stopAnimating];
    self.indicator.hidden = YES;
    self.btnOrderItAgain.enabled = YES;
}
@end
