//
//  SharedCurrentCredentialsDb.h
//  JummumShop
//
//  Created by Thidaporn Kijkamjai on 21/7/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CredentialsDb.h"


@interface SharedCurrentCredentialsDb : NSObject
@property (retain, nonatomic) CredentialsDb *credentialsDb;

+ (SharedCurrentCredentialsDb *)sharedCurrentCredentialsDb;
@end
