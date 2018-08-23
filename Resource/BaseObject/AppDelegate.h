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
@import Firebase;
@import FirebaseInstanceID;


//printer part
#import <StarIO_Extension/StarIoExt.h>
#import "ModelCapability.h"

#import "SettingManager.h"

#import "PrinterSetting.h"

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
    LanguageIndexTraditionalChinese,
    LanguageIndexCJKUnifiedIdeograph
};
//end printer part


@interface AppDelegate : UIResponder <UIApplicationDelegate,HomeModelProtocol,UNUserNotificationCenterDelegate,FIRMessagingDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIWindow *alertWindow;
@property (nonatomic, strong) UINavigationController *navController;
@property (nonatomic, strong) UIViewController *vc;


//printer part
@property (nonatomic) SettingManager *settingManager;

+ (NSString *)getPortName;

+ (void)setPortName:(NSString *)portName;

+ (NSString *)getPortSettings;

+ (void)setPortSettings:(NSString *)portSettings;

+ (NSString *)getModelName;

+ (void)setModelName:(NSString *)modelName;

+ (NSString *)getMacAddress;

+ (void)setMacAddress:(NSString *)macAddress;

+ (StarIoExtEmulation)getEmulation;

+ (void)setEmulation:(StarIoExtEmulation)emulation;

+ (BOOL)getCashDrawerOpenActiveHigh;

+ (void)setCashDrawerOpenActiveHigh:(BOOL)activeHigh;

+ (NSInteger)getAllReceiptsSettings;

+ (void)setAllReceiptsSettings:(NSInteger)allReceiptsSettings;

+ (NSInteger)getSelectedIndex;

+ (void)setSelectedIndex:(NSInteger)index;

+ (LanguageIndex)getSelectedLanguage;

+ (void)setSelectedLanguage:(LanguageIndex)index;

+ (PaperSizeIndex)getSelectedPaperSize;

+ (void)setSelectedPaperSize:(PaperSizeIndex)index;

+ (ModelIndex)getSelectedModelIndex;

+ (void)setSelectedModelIndex:(ModelIndex)modelIndex;
//end printer part

@end


