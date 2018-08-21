//
//  SharedDevice.h
//  DevJummumOM
//
//  Created by Thidaporn Kijkamjai on 21/8/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedDevice : NSObject
@property (retain, nonatomic) NSMutableArray *deviceList;

+ (SharedDevice *)sharedDevice;

@end
