//
//  SharedCurrentMenu.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 12/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedCurrentMenu : NSObject
@property (retain, nonatomic) NSMutableArray *menuList;

+ (SharedCurrentMenu *)SharedCurrentMenu;
@end
