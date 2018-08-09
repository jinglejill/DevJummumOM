//
//  SharedSetting.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/28/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedSetting : NSObject
@property (retain, nonatomic) NSMutableArray *settingList;

+ (SharedSetting *)sharedSetting;
@end
