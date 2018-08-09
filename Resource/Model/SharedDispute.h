//
//  SharedDispute.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 12/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedDispute : NSObject
@property (retain, nonatomic) NSMutableArray *disputeList;

+ (SharedDispute *)sharedDispute;
@end
