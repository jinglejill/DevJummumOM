//
//  SharedMenuPic.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 19/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedMenuPic : NSObject
@property (retain, nonatomic) NSMutableArray *menuPicList;

+ (SharedMenuPic *)sharedMenuPic;

@end
