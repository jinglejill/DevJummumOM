//
//  SharedTableNo.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 18/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedTableNo : NSObject
@property (retain, nonatomic) NSMutableArray *tableNoList;

+ (SharedTableNo *)sharedTableNo;
@end
