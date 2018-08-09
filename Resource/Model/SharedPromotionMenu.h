//
//  SharedPromotionMenu.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 20/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedPromotionMenu : NSObject
@property (retain, nonatomic) NSMutableArray *promotionMenuList;

+ (SharedPromotionMenu *)sharedPromotionMenu;
@end
