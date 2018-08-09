//
//  SharedMenuType.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 20/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedMenuType : NSObject
@property (retain, nonatomic) NSMutableArray *menuTypeList;

+ (SharedMenuType *)sharedMenuType;
@end
