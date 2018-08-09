//
//  CustomTableViewCellNote.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 23/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CustomTableViewCellNote.h"

@implementation CustomTableViewCellNote
@synthesize longPressGestureRecognizer;
@synthesize doubleTapGestureRecognizer;
@synthesize singleTapGestureRecognizer;


- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]init];
        doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]init];
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
