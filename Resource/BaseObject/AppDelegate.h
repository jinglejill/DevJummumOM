//
//  AppDelegate.h
//  Eventoree
//
//  Created by Thidaporn Kijkamjai on 8/4/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
@import UserNotifications;


#define SYSTEM_VERSION_EQUAL_TO(ver)                 ([[[UIDevice currentDevice] systemVersion] compare:ver options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(ver)             ([[[UIDevice currentDevice] systemVersion] compare:ver options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(ver) ([[[UIDevice currentDevice] systemVersion] compare:ver options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(ver)                ([[[UIDevice currentDevice] systemVersion] compare:ver options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(ver)    ([[[UIDevice currentDevice] systemVersion] compare:ver options:NSNumericSearch] != NSOrderedDescending)

#define IS_IPHONE() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPAD()   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

typedef NS_ENUM(NSInteger, LanguageIndex) {
    LanguageIndexEnglish = 0,
    LanguageIndexJapanese,
    LanguageIndexFrench,
    LanguageIndexPortuguese,
    LanguageIndexSpanish,
    LanguageIndexGerman,
    LanguageIndexRussian,
    LanguageIndexSimplifiedChinese,
    LanguageIndexTraditionalChinese
};

typedef NS_ENUM(NSInteger, PaperSizeIndex) {
    PaperSizeIndexTwoInch = 384,
    PaperSizeIndexThreeInch = 576,
    PaperSizeIndexFourInch = 832,
    PaperSizeIndexEscPosThreeInch = 512,
    PaperSizeIndexDotImpactThreeInch = 210
};



@interface AppDelegate : UIResponder <UIApplicationDelegate,HomeModelProtocol,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIWindow *alertWindow;
@property (nonatomic, strong) UINavigationController *navController;
@property (nonatomic, strong) UIViewController *vc;



@end


