//
//  CustomTableViewCellProfile.m
//  JummumShop
//
//  Created by Thidaporn Kijkamjai on 5/6/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomTableViewCellProfile.h"

@implementation CustomTableViewCellProfile
@synthesize singleTapGestureRecognizer;

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self)
    {
        singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]init];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
