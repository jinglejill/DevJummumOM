//
//  SharedBranch.h
//  FFD
//
//  Created by Thidaporn Kijkamjai on 9/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedBranch : NSObject
@property (retain, nonatomic) NSMutableArray *branchList;

+ (SharedBranch *)sharedBranch;
@end
