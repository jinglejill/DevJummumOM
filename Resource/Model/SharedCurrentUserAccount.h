//
//  SharedCurrentUserAccount.h
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/6/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserAccount.h"


@interface SharedCurrentUserAccount : NSObject
@property (retain, nonatomic) UserAccount *userAccount;

+ (SharedCurrentUserAccount *)sharedCurrentUserAccount;
@end
