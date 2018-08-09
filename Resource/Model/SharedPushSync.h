//
//  SharedPushSync.h
//  SAIM_UPDATING
//
//  Created by Thidaporn Kijkamjai on 5/19/2559 BE.
//  Copyright © 2559 Thidaporn Kijkamjai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedPushSync : NSObject
@property (retain, nonatomic) NSMutableArray * pushSyncList;
+ (SharedPushSync *)sharedPushSync;
@end
