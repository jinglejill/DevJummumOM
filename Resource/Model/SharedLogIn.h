//
//  SharedLogIn.h
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/6/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedLogIn : NSObject
@property (retain, nonatomic) NSMutableArray *logInList;

+ (SharedLogIn *)sharedLogIn;
@end
