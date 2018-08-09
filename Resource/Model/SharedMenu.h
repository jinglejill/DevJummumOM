//
//  SharedMenu.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 27/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedMenu : NSObject
@property (retain, nonatomic) NSMutableArray *menuList;

+ (SharedMenu *)sharedMenu;
@end
