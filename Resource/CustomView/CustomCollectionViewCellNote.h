//
//  CustomCollectionViewCellNote.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 11/15/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewCellNote : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIButton *btnCheckBox;
@property (strong, nonatomic) IBOutlet UILabel *lblNoteName;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;

@end
