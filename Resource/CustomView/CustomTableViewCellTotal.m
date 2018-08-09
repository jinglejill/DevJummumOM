//
//  CustomTableViewCellTotal.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 25/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomTableViewCellTotal.h"
#import "Utility.h"


@implementation CustomTableViewCellTotal

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
    [super prepareForReuse];
    //    NSLog(@"reuse");
    
    self.lblTitle.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    self.lblAmount.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    self.lblAmount.textColor = mGreen;
}
@end
