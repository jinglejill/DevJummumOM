//
//  CustomCollectionReusableView.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/20/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionReusableView : UICollectionReusableView
@property (strong, nonatomic) IBOutlet UILabel *lblHeaderName;
@property (strong, nonatomic) IBOutlet UIView *vwTopLine;
@property (strong, nonatomic) IBOutlet UIView *vwBottomLine;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressGestureRecognizer;
@end
