//
//  MainTabBarController.h
//  Eventoree
//
//  Created by Thidaporn Kijkamjai on 8/4/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CredentialsDb.h"


@interface MainTabBarController : UITabBarController
@property (strong, nonatomic) CredentialsDb *credentialsDb;
@end
