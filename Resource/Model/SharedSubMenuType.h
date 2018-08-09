//
//  SharedSubMenuType.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/19/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedSubMenuType : NSObject
@property (retain, nonatomic) NSMutableArray *subMenuTypeList;

+ (SharedSubMenuType *)sharedSubMenuType;
@end
