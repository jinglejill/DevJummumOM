//
//  CustomTableViewCellNote.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 23/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellNote : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblDishNo;
@property (strong, nonatomic) IBOutlet UITextField *txtNote;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalNotePrice;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *doubleTapGestureRecognizer;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *singleTapGestureRecognizer;
@property (strong, nonatomic) IBOutlet UIButton *btnDelete;
@property (strong, nonatomic) IBOutlet UIButton *btnTakeAway;
@end
