//
//  SharedCurrentBranch.h
//  DevJummumOM
//
//  Created by Thidaporn Kijkamjai on 17/9/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Branch.h"


@interface SharedCurrentBranch : NSObject
@property (retain, nonatomic) Branch *branch;

+ (SharedCurrentBranch *)sharedCurrentBranch;
@end
