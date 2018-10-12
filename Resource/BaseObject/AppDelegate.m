//
//  AppDelegate.m
//  Eventoree
//
//  Created by Thidaporn Kijkamjai on 8/4/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "AppDelegate.h"
#import "LogInViewController.h"
#import "CustomerKitchenViewController.h"
#import "OrderDetailViewController.h"
#import "TosAndPrivacyPolicyViewController.h"
#import "PersonalDataViewController.h"
#import "MeViewController.h"
#import "OpeningTimeViewController.h"
#import "PrinterSettingViewController.h"
#import "PrinterChoosingViewController.h"
#import "ReportViewController.h"
#import "ReportDetailsByDayViewController.h"
#import "RunningReceiptViewController.h"
#import "HomeModel.h"
#import "Utility.h"
#import "PushSync.h"
#import "Receipt.h"
#import "Setting.h"
#import "SharedCurrentUserAccount.h"
#import <objc/runtime.h>
#import <UserNotifications/UserNotifications.h>


#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)



@interface AppDelegate ()
{
    HomeModel *_homeModel;
    NSMutableDictionary *_dicTimer;
}
//printer part
@property (nonatomic) NSInteger selectedIndex;

@property (nonatomic) LanguageIndex selectedLanguage;

- (void)loadParam;
//end printer part
@end

extern BOOL globalRotateFromSeg;



@implementation AppDelegate
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)photoUploaded
{
    
}

void myExceptionHandler(NSException *exception)
{
    
    NSString *stackTrace = [[[exception callStackSymbols] valueForKey:@"description"] componentsJoinedByString:@"\\n"];
    stackTrace = [NSString stringWithFormat:@"%@,%@\\n%@\\n%@",[Utility modifiedUser],[Utility deviceToken],exception.reason,stackTrace];
//    NSLog(@"Stack Trace callStackSymbols: %@", stackTrace);
    
    [[NSUserDefaults standardUserDefaults] setValue:stackTrace forKey:@"exception"];
    
}

//-(void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage
//{
//    NSLog(@"remoteMessageAppData: %@",remoteMessage.appData);
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //printer part
    [NSThread sleepForTimeInterval:1.0];     // 1000mS!!!
    
    _selectedIndex     = 0;
    _selectedLanguage  = LanguageIndexEnglish;
    
    _settingManager = [SettingManager new];
    
    [self loadParam];
    //end printer part
//    NSString *key = [NSString stringWithFormat:@"dismiss verion:1.2"];
//        [[NSUserDefaults standardUserDefaults] setValue:@0 forKey:key];
//

    
    
    
    UIBarButtonItem *barButtonAppearance = [UIBarButtonItem appearance];
    [barButtonAppearance setBackgroundImage:[self imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault]; // Change to your colour
    
    
    

    _homeModel = [[HomeModel alloc]init];
    _homeModel.delegate = self;
    _dicTimer = [[NSMutableDictionary alloc]init];
    
    
    
    globalRotateFromSeg = NO;
    
    // Override point for customization after application launch.
    NSString *strplistPath = [[NSBundle mainBundle] pathForResource:@"Property List" ofType:@"plist"];
    
    // read property list into memory as an NSData  object
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:strplistPath];
    NSError *strerrorDesc = nil;
    NSPropertyListFormat plistFormat;
    
    // convert static property list into dictionary object
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListWithData:plistXML options:NSPropertyListMutableContainersAndLeaves format:&plistFormat error:&strerrorDesc];
    if (!temp)
    {
        NSLog(@"Error reading plist: %@, format: %lu", strerrorDesc, (unsigned long)plistFormat);
    }
    else
    {
        // assign values        
        [Utility setPingAddress:[temp objectForKey:@"PingAddress"]];
        [Utility setDomainName:[temp objectForKey:@"DomainName"]];
        [Utility setSubjectNoConnection:[temp objectForKey:@"SubjectNoConnection"]];
        [Utility setDetailNoConnection:[temp objectForKey:@"DetailNoConnection"]];
        [Utility setDetailNoConnection:[temp objectForKey:@"DetailNoConnection"]];
        [Utility setKey:[temp objectForKey:@"Key"]];
        [Utility setBundleID:[temp objectForKey:@"BundleID"]];
        
        
    }
    
    
    
    //write exception of latest app crash to log file
    NSSetUncaughtExceptionHandler(&myExceptionHandler);
    NSString *stackTrace = [[NSUserDefaults standardUserDefaults] stringForKey:@"exception"];    
    if(!stackTrace)
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"exception"];
    }
    else if(![stackTrace isEqualToString:@""])
    {
        [_homeModel insertItems:dbWriteLog withData:stackTrace actionScreen:@"Logging"];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"exception"];
    }
    
    
    //push notification
    {
//        [FIRApp configure];
        if ([UNUserNotificationCenter class] != nil)//version >= 10
        {
            
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            center.delegate = self;
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error)
             {
                 if( !error )
                 {
                     NSLog( @"Push registration success." );
                 }
                 else
                 {
                     NSLog( @"Push registration FAILED" );
                     NSLog( @"ERROR: %@ - %@", error.localizedFailureReason, error.localizedDescription );
                     NSLog( @"SUGGESTIONS: %@ - %@", error.localizedRecoveryOptions, error.localizedRecoverySuggestion );
                 }
             }];
        }
        else
        {
            UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
            [application registerUserNotificationSettings:settings];
        }
        [application registerForRemoteNotifications];  // required to get the app to do anything at all about push notifications
//        [FIRMessaging messaging].delegate = self;
    }
    

    
    
    #if (TARGET_OS_SIMULATOR)
        NSString *token = @"simulator";
        [[NSUserDefaults standardUserDefaults] setValue:token forKey:TOKEN];
    #endif


    
    return YES;
}

#ifdef __IPHONE_9_0
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary *)options {

   
    return YES;
}
#else
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];

    return YES;
}
#endif


-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    
    //Called when a notification is delivered to a foreground app.
    NSDictionary *userInfo = notification.request.content.userInfo;
    NSLog(@"notification is delivered to a foreground app: %@", userInfo);
    
    ////////
    //Get current vc
    CustomViewController *currentVc;
    CustomViewController *parentViewController = (CustomViewController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    
    while (parentViewController.presentedViewController != nil && ![parentViewController.presentedViewController isKindOfClass:[UIAlertController class]])
    {
        parentViewController = (CustomViewController *)parentViewController.presentedViewController;
    }
    if([parentViewController isKindOfClass:[UITabBarController class]])
    {
        currentVc = ((UITabBarController *)parentViewController).selectedViewController;
    }
    else
    {
        currentVc = parentViewController;
    }
    
    
    
    
    ////////
    
    if([userInfo objectForKey:@"localNoti"])
    {
        //Get current vc
        CustomViewController *currentVc;
        CustomViewController *parentViewController = (CustomViewController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
        
        while (parentViewController.presentedViewController != nil && ![parentViewController.presentedViewController isKindOfClass:[UIAlertController class]])
        {
            parentViewController = (CustomViewController *)parentViewController.presentedViewController;
        }
        if([parentViewController isKindOfClass:[UITabBarController class]])
        {
            currentVc = ((UITabBarController *)parentViewController).selectedViewController;
        }
        else
        {
            currentVc = parentViewController;
        }
        
        
        
        if([currentVc isKindOfClass:[CustomerKitchenViewController class]])
        {
            NSDictionary *myAps = [userInfo objectForKey:@"aps"];
            NSString *strReceiptID = [NSString stringWithFormat:@"%@",[myAps valueForKey:@"receiptID"]];
            
            NSTimer *timer = [_dicTimer valueForKey:strReceiptID];
            [timer invalidate];
        }
        else if([currentVc isKindOfClass:[OrderDetailViewController class]])
        {
            NSDictionary *myAps = [userInfo objectForKey:@"aps"];
            NSString *strReceiptID = [NSString stringWithFormat:@"%@",[myAps valueForKey:@"receiptID"]];
            
            
            OrderDetailViewController *vc = (OrderDetailViewController *)currentVc;
            if(vc.receipt.receiptID == [strReceiptID integerValue])
            {
                NSTimer *timer = [_dicTimer valueForKey:strReceiptID];
                [timer invalidate];
            }
        }
    }
    else
    {
        //customer send noti -> update status = cancel&dispute, printKitchenBill = pay order
        //shop another device send noti -> processing, delivered move to processed and delivered tab
        //shop another device send noti -> clear move to clear tab
        //updateStatus move to issue tab
        //reminder not use anymore, use local noti instead
        NSDictionary *myAps = [userInfo objectForKey:@"aps"];
        NSString *categoryIdentifier = [myAps objectForKey:@"category"];
        if([categoryIdentifier isEqualToString:@"updateStatus"] || [categoryIdentifier isEqualToString:@"printKitchenBill"] || [categoryIdentifier isEqualToString:@"processing"] || [categoryIdentifier isEqualToString:@"delivered"] || [categoryIdentifier isEqualToString:@"clear"])
        {
            if(![currentVc isKindOfClass:[CustomerKitchenViewController class]] && ![currentVc isKindOfClass:[OrderDetailViewController class]])
            {
                completionHandler(UNNotificationPresentationOptionAlert);
            }
            NSDictionary *data = [myAps objectForKey:@"data"];
            NSNumber *receiptID = [data objectForKey:@"receiptID"];
            _homeModel = [[HomeModel alloc]init];
            _homeModel.delegate = self;
            [_homeModel downloadItems:dbJummumReceipt withData:receiptID];
        }
        else if([categoryIdentifier isEqualToString:@"buffetEnded"])
        {
            if(![currentVc isKindOfClass:[RunningReceiptViewController class]])
            {
                completionHandler(UNNotificationPresentationOptionAlert);
            }
    
            NSDictionary *data = [myAps objectForKey:@"data"];
            NSNumber *receiptID = [data objectForKey:@"receiptID"];
            _homeModel = [[HomeModel alloc]init];
            _homeModel.delegate = self;
            [_homeModel downloadItems:dbReceiptBuffetEndedGet withData:receiptID];
        }
        else if([categoryIdentifier isEqualToString:@"openingTime"])
        {
            NSDictionary *data = [myAps objectForKey:@"data"];
            NSNumber *settingID = [data objectForKey:@"settingID"];
            _homeModel = [[HomeModel alloc]init];
            _homeModel.delegate = self;
            [_homeModel downloadItems:dbSetting withData:settingID];
        }
    }
}


-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
{
    
    //Called to let your app know which action was selected by the user for a given notification.
    
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    NSDictionary *myAps = [userInfo objectForKey:@"aps"];
    NSString *categoryIdentifier = [myAps objectForKey:@"category"];
    NSLog(@"action was selected by the user for a given notification: %@", userInfo);
    
    if([userInfo objectForKey:@"localNoti"])
    {
        //Get current vc
        CustomViewController *currentVc;
        CustomViewController *parentViewController = (CustomViewController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
        
        while (parentViewController.presentedViewController != nil && ![parentViewController.presentedViewController isKindOfClass:[UIAlertController class]])
        {
            parentViewController = (CustomViewController *)parentViewController.presentedViewController;
        }
        if([parentViewController isKindOfClass:[UITabBarController class]])
        {
            currentVc = ((UITabBarController *)parentViewController).selectedViewController;
        }
        else
        {
            currentVc = parentViewController;
        }
        
        
        
        if([currentVc isKindOfClass:[CustomerKitchenViewController class]])
        {
            CustomerKitchenViewController *vc = (CustomerKitchenViewController *)currentVc;
            [vc reloadTableViewNewOrderTab];
        }
        else if([currentVc isKindOfClass:[OrderDetailViewController class]] || [currentVc isKindOfClass:[PersonalDataViewController class]] || [currentVc isKindOfClass:[TosAndPrivacyPolicyViewController class]])
        {
            CustomViewController *vc = (CustomViewController *)currentVc;
            vc.newOrderComing = 1;
            [vc performSegueWithIdentifier:@"segUnwindToCustomerKitchen" sender:self];
        }
        else if([currentVc isKindOfClass:[MeViewController class]])
        {
            MeViewController *vc = (MeViewController *)currentVc;
            [vc.tabBarController setSelectedIndex:0];
            CustomerKitchenViewController *customerKitchenVc = vc.tabBarController.selectedViewController;
            [customerKitchenVc reloadTableViewNewOrderTab];
        }
        
        
        //stop local noti
        NSDictionary *myAps = [userInfo objectForKey:@"aps"];
        NSString *strReceiptID = [NSString stringWithFormat:@"%@",[myAps valueForKey:@"receiptID"]];
        
        NSTimer *timer = [_dicTimer valueForKey:strReceiptID];
        [timer invalidate];
    }
    else
    {
        if([categoryIdentifier isEqualToString:@"updateStatus"])
        {
            NSDictionary *data = [myAps objectForKey:@"data"];
            NSNumber *receiptID = [data objectForKey:@"receiptID"];
            _homeModel = [[HomeModel alloc]init];
            _homeModel.delegate = self;
            [_homeModel downloadItems:dbJummumReceiptTapNotificationIssue withData:receiptID];
        }
        else if([categoryIdentifier isEqualToString:@"printKitchenBill"] || [categoryIdentifier isEqualToString:@"reminder"])
        {
            NSDictionary *data = [myAps objectForKey:@"data"];
            NSNumber *receiptID = [data objectForKey:@"receiptID"];
            _homeModel = [[HomeModel alloc]init];
            _homeModel.delegate = self;
            [_homeModel downloadItems:dbJummumReceiptTapNotification withData:receiptID];
        }
        else if([categoryIdentifier isEqualToString:@"processing"])
        {
            NSDictionary *data = [myAps objectForKey:@"data"];
            NSNumber *receiptID = [data objectForKey:@"receiptID"];
            _homeModel = [[HomeModel alloc]init];
            _homeModel.delegate = self;
            [_homeModel downloadItems:dbJummumReceiptTapNotificationProcessing withData:receiptID];
        }
        else if([categoryIdentifier isEqualToString:@"delivered"])
        {
            NSDictionary *data = [myAps objectForKey:@"data"];
            NSNumber *receiptID = [data objectForKey:@"receiptID"];
            _homeModel = [[HomeModel alloc]init];
            _homeModel.delegate = self;
            [_homeModel downloadItems:dbJummumReceiptTapNotificationDelivered withData:receiptID];
        }
        else if([categoryIdentifier isEqualToString:@"clear"])
        {
            NSDictionary *data = [myAps objectForKey:@"data"];
            NSNumber *receiptID = [data objectForKey:@"receiptID"];
            _homeModel = [[HomeModel alloc]init];
            _homeModel.delegate = self;
            [_homeModel downloadItems:dbJummumReceiptTapNotificationClear withData:receiptID];
        }
        else if([categoryIdentifier isEqualToString:@"buffetEnded"])
        {
            NSDictionary *data = [myAps objectForKey:@"data"];
            NSNumber *receiptID = [data objectForKey:@"receiptID"];
            _homeModel = [[HomeModel alloc]init];
            _homeModel.delegate = self;
            [_homeModel downloadItems:dbReceiptBuffetEndedTapGet withData:receiptID];
        }
    }
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"token---%@", token);
    
    
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
//    NSLog(@"FCM registration token: %@", fcmToken);
//    // Notify about received token.
//    NSDictionary *dataDict = [NSDictionary dictionaryWithObject:fcmToken forKey:@"token"];
//    [[NSNotificationCenter defaultCenter] postNotificationName:
//     @"FCMToken" object:nil userInfo:dataDict];
//    // TODO: If necessary send token to application server.
//    // Note: This callback is fired at each app startup and whenever a new token is generated.
//}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //    NSLog([error localizedDescription]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"didReceiveRemoteNotification: %@", userInfo);

    
    NSDictionary *myAps = [userInfo objectForKey:@"aps"];
    NSString *categoryIdentifier = [myAps objectForKey:@"category"];
    if([categoryIdentifier isEqualToString:@"updateStatus"] || [categoryIdentifier isEqualToString:@"printKitchenBill"] || [categoryIdentifier isEqualToString:@"reminder"] || [categoryIdentifier isEqualToString:@"processing"] || [categoryIdentifier isEqualToString:@"delivered"] || [categoryIdentifier isEqualToString:@"clear"])
    {
        NSDictionary *myAps = [userInfo objectForKey:@"aps"];
        NSDictionary *data = [myAps objectForKey:@"data"];
        NSNumber *receiptID = [data objectForKey:@"receiptID"];
        _homeModel = [[HomeModel alloc]init];
        _homeModel.delegate = self;
        [_homeModel downloadItems:dbJummumReceipt withData:receiptID];
        completionHandler(UIBackgroundFetchResultNewData);
    }
    else if([categoryIdentifier isEqualToString:@"openingTime"])
    {
        NSDictionary *data = [myAps objectForKey:@"data"];
        NSNumber *settingID = [data objectForKey:@"settingID"];
        _homeModel = [[HomeModel alloc]init];
        _homeModel.delegate = self;
        [_homeModel downloadItems:dbSetting withData:settingID];
        completionHandler(UIBackgroundFetchResultNewData);
    }
    
    
    
    if([categoryIdentifier isEqualToString:@"printKitchenBill"])
    {
        float reminderInterval = [[Setting getSettingValueWithKeyName:@"reminderInterval"] floatValue];
        [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:reminderInterval target:self selector:@selector(updateTimer:) userInfo:myAps repeats:YES];///test 5 sec
        NSString *strReceiptID = [NSString stringWithFormat:@"%@",[myAps valueForKey:@"receiptID"]];
        [_dicTimer setValue:timer forKey:strReceiptID];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
    
    
//    if (application.applicationState == UIApplicationStateBackground)

//    if(application.applicationState == UIApplicationStateInactive)
//    {
//
//        NSLog(@"Inactive");
//
//        //Show the view with the content of the push
//
//        completionHandler(UIBackgroundFetchResultNewData);
//
//    }
//    else if (application.applicationState == UIApplicationStateBackground)
//    {
//
//        NSLog(@"Background");
//
//        //Refresh the local model
//
//        completionHandler(UIBackgroundFetchResultNewData);
//    }
//    else
//    {
//
//        NSLog(@"Active");
//
//        //Show an in-app banner
//
//        completionHandler(UIBackgroundFetchResultNewData);
//    }
}

-(void)updateTimer:(NSTimer *)timer
{
    NSDictionary *myAps = timer.userInfo;
    NSLog(@"timer current time: %@", [NSDate date]);
    
    NSString *strReceiptID = [myAps valueForKey:@"receiptID"];
    //check receipt status == 2
    Receipt *receipt = [Receipt getReceipt:[strReceiptID integerValue]];
    NSInteger statusEqualTwo = receipt.status == 2;
    if(statusEqualTwo)
    {
        [self generateLocalNotification:myAps];
    }
    else
    {
        [timer invalidate];
    }
}

- (void)generateLocalNotification:(NSDictionary *)myAps
{
    
    NSString *msg = [NSString stringWithFormat:@"%@",[myAps valueForKey:@"alert"]];
    UNMutableNotificationContent *localNotification = [UNMutableNotificationContent new];
    //    localNotification.title = [NSString localizedUserNotificationStringForKey:@"Time for a run!" arguments:nil];
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
    [userInfo setValue:myAps forKey:@"aps"];
    [userInfo setValue:@"1" forKey:@"localNoti"];
    localNotification.userInfo = userInfo;
    localNotification.body = [NSString localizedUserNotificationStringForKey:msg arguments:nil];
    localNotification.sound = [UNNotificationSound defaultSound];
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    
    
    //    localNotification.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] +1);
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"Time for a run!" content:localNotification trigger:trigger];
    
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"Notification created");
    }];
}

- (void)itemsUpdated
{
    
}

- (void)itemsInserted
{
    
}

- (void)itemsDeleted
{
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //Get current vc
    CustomViewController *currentVc;
    CustomViewController *parentViewController = (CustomViewController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    
    while (parentViewController.presentedViewController != nil && ![parentViewController.presentedViewController isKindOfClass:[UIAlertController class]])
    {
        parentViewController = (CustomViewController *)parentViewController.presentedViewController;
    }
    if([parentViewController isKindOfClass:[UITabBarController class]])
    {
        currentVc = ((UITabBarController *)parentViewController).selectedViewController;
    }
    else
    {
        currentVc = parentViewController;
    }
    
    
    
    if([currentVc isKindOfClass:[CustomerKitchenViewController class]])
    {
        CustomerKitchenViewController *vc = (CustomerKitchenViewController *)currentVc;
        [vc refresh:nil];
    }
    else if([currentVc isKindOfClass:[OrderDetailViewController class]])
    {
        OrderDetailViewController *vc = (OrderDetailViewController *)currentVc;
        [vc refresh:nil];
    }
    else if([currentVc isKindOfClass:[RunningReceiptViewController class]])
    {
        RunningReceiptViewController *vc = (RunningReceiptViewController *)currentVc;
        [vc refresh:nil];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(void)itemsDownloaded:(NSArray *)items manager:(NSObject *)objHomeModel
{
    HomeModel *homeModel = (HomeModel *)objHomeModel;
    if(homeModel.propCurrentDB == dbJummumReceipt)
    {
        [Utility updateSharedObject:items];
        
        
        //Get current vc
        CustomViewController *currentVc;
        CustomViewController *parentViewController = (CustomViewController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
        
        while (parentViewController.presentedViewController != nil && ![parentViewController.presentedViewController isKindOfClass:[UIAlertController class]])
        {
            parentViewController = (CustomViewController *)parentViewController.presentedViewController;
        }
        if([parentViewController isKindOfClass:[UITabBarController class]])
        {
            currentVc = ((UITabBarController *)parentViewController).selectedViewController;
        }
        else
        {
            currentVc = parentViewController;
        }
        
        
        
        if([currentVc isKindOfClass:[CustomerKitchenViewController class]])
        {
            CustomerKitchenViewController *vc = (CustomerKitchenViewController *)currentVc;
            [vc reloadTableView];
        }
        else if([currentVc isKindOfClass:[OrderDetailViewController class]])
        {
            OrderDetailViewController *vc = (OrderDetailViewController *)currentVc;
            [vc reloadTableView];
        }
        else if([currentVc isKindOfClass:[RunningReceiptViewController class]])
        {
            RunningReceiptViewController *vc = (RunningReceiptViewController *)currentVc;
            [vc reloadTableView];
        }
    }
    else if(homeModel.propCurrentDB == dbReceiptBuffetEndedGet)
    {
        [Utility updateSharedObject:items];
        NSMutableArray *receiptList = items[0];
        Receipt *receipt = receiptList[0];
        
        //Get current vc
        CustomViewController *currentVc;
        CustomViewController *parentViewController = (CustomViewController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
        
        while (parentViewController.presentedViewController != nil && ![parentViewController.presentedViewController isKindOfClass:[UIAlertController class]])
        {
            parentViewController = (CustomViewController *)parentViewController.presentedViewController;
        }
        if([parentViewController isKindOfClass:[UITabBarController class]])
        {
            currentVc = ((UITabBarController *)parentViewController).selectedViewController;
        }
        else
        {
            currentVc = parentViewController;
        }
        
        
        
        if([currentVc isKindOfClass:[RunningReceiptViewController class]])
        {
            RunningReceiptViewController *vc = (RunningReceiptViewController *)currentVc;
            vc.selectedReceipt = receipt;
            [vc reloadTableView];
        }
    }
    else if(homeModel.propCurrentDB == dbReceiptBuffetEndedTapGet)
    {
        [Utility updateSharedObject:items];
        NSMutableArray *receiptList = items[0];
        Receipt *receipt = receiptList[0];
        
        //Get current vc
        CustomViewController *currentVc;
        CustomViewController *parentViewController = (CustomViewController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
        
        while (parentViewController.presentedViewController != nil && ![parentViewController.presentedViewController isKindOfClass:[UIAlertController class]])
        {
            parentViewController = (CustomViewController *)parentViewController.presentedViewController;
        }
        if([parentViewController isKindOfClass:[UITabBarController class]])
        {
            currentVc = ((UITabBarController *)parentViewController).selectedViewController;
        }
        else
        {
            currentVc = parentViewController;
        }
        
        
        
        if([currentVc isKindOfClass:[RunningReceiptViewController class]])
        {
            RunningReceiptViewController *vc = (RunningReceiptViewController *)currentVc;
            vc.selectedReceipt = receipt;
            [vc reloadTableView];
        }
        else if([currentVc isKindOfClass:[CustomerKitchenViewController class]] || [currentVc isKindOfClass:[MeViewController class]])
        {
            currentVc.tabBarController.selectedIndex = 1;
            RunningReceiptViewController *vc = currentVc.tabBarController.selectedViewController;
            vc.selectedReceipt = receipt;
            [vc reloadTableView];
        }
        else
        {
            currentVc.showRunningReceipt = 1;
            currentVc.selectedReceipt = receipt;
            [currentVc performSegueWithIdentifier:@"segUnwindToMainTabBar" sender:self];
        }
    }
    else if(homeModel.propCurrentDB == dbJummumReceiptTapNotification)
    {
        [Utility updateSharedObject:items];
        
        
        
        //Get current vc
        CustomViewController *currentVc;
        CustomViewController *parentViewController = (CustomViewController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
        
        while (parentViewController.presentedViewController != nil && ![parentViewController.presentedViewController isKindOfClass:[UIAlertController class]])
        {
            parentViewController = (CustomViewController *)parentViewController.presentedViewController;
        }
        if([parentViewController isKindOfClass:[UITabBarController class]])
        {
            currentVc = ((UITabBarController *)parentViewController).selectedViewController;
        }
        else
        {
            currentVc = parentViewController;
        }
        
        
        
        if([currentVc isKindOfClass:[CustomerKitchenViewController class]])
        {
            CustomerKitchenViewController *vc = (CustomerKitchenViewController *)currentVc;
            [vc reloadTableViewNewOrderTab];
        }
        else if([currentVc isKindOfClass:[OrderDetailViewController class]] || [currentVc isKindOfClass:[PersonalDataViewController class]] || [currentVc isKindOfClass:[TosAndPrivacyPolicyViewController class]] || [currentVc isKindOfClass:[PrinterSettingViewController class]] || [currentVc isKindOfClass:[PrinterChoosingViewController class]] || [currentVc isKindOfClass:[ReportViewController class]] || [currentVc isKindOfClass:[ReportDetailsByDayViewController class]])
        {
            CustomViewController *vc = (CustomViewController *)currentVc;
            vc.newOrderComing = 1;
            [vc performSegueWithIdentifier:@"segUnwindToCustomerKitchen" sender:self];
        }
        else if([currentVc isKindOfClass:[MeViewController class]])
        {
            MeViewController *vc = (MeViewController *)currentVc;
            [vc.tabBarController setSelectedIndex:0];
            CustomerKitchenViewController *customerKitchenVc = vc.tabBarController.selectedViewController;
            [customerKitchenVc reloadTableViewNewOrderTab];
        }
    }
    else if(homeModel.propCurrentDB == dbJummumReceiptTapNotificationIssue)
    {
        [Utility updateSharedObject:items];
        
        
        //Get current vc
        CustomViewController *currentVc;
        CustomViewController *parentViewController = (CustomViewController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
        
        while (parentViewController.presentedViewController != nil && ![parentViewController.presentedViewController isKindOfClass:[UIAlertController class]])
        {
            parentViewController = (CustomViewController *)parentViewController.presentedViewController;
        }
        if([parentViewController isKindOfClass:[UITabBarController class]])
        {
            currentVc = ((UITabBarController *)parentViewController).selectedViewController;
        }
        else
        {
            currentVc = parentViewController;
        }
        
        
        
        if([currentVc isKindOfClass:[CustomerKitchenViewController class]])
        {
            CustomerKitchenViewController *vc = (CustomerKitchenViewController *)currentVc;
            [vc reloadTableViewIssueTab];
        }
        else if([currentVc isKindOfClass:[OrderDetailViewController class]] || [currentVc isKindOfClass:[PersonalDataViewController class]] || [currentVc isKindOfClass:[TosAndPrivacyPolicyViewController class]] || [currentVc isKindOfClass:[PrinterSettingViewController class]] || [currentVc isKindOfClass:[PrinterChoosingViewController class]] || [currentVc isKindOfClass:[ReportViewController class]] || [currentVc isKindOfClass:[ReportDetailsByDayViewController class]])
        {
            CustomViewController *vc = (CustomViewController *)currentVc;
            vc.issueComing = 1;
            [vc performSegueWithIdentifier:@"segUnwindToCustomerKitchen" sender:self];
        }
        else if([currentVc isKindOfClass:[MeViewController class]])
        {
            MeViewController *vc = (MeViewController *)currentVc;
            [vc.tabBarController setSelectedIndex:0];
            CustomerKitchenViewController *customerKitchenVc = vc.tabBarController.selectedViewController;
            [customerKitchenVc reloadTableViewIssueTab];
        }
    }
    else if(homeModel.propCurrentDB == dbJummumReceiptTapNotificationProcessing)
    {
        [Utility updateSharedObject:items];
        
        
        //Get current vc
        CustomViewController *currentVc;
        CustomViewController *parentViewController = (CustomViewController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
        
        while (parentViewController.presentedViewController != nil && ![parentViewController.presentedViewController isKindOfClass:[UIAlertController class]])
        {
            parentViewController = (CustomViewController *)parentViewController.presentedViewController;
        }
        if([parentViewController isKindOfClass:[UITabBarController class]])
        {
            currentVc = ((UITabBarController *)parentViewController).selectedViewController;
        }
        else
        {
            currentVc = parentViewController;
        }
        
        
        
        if([currentVc isKindOfClass:[CustomerKitchenViewController class]])
        {
            CustomerKitchenViewController *vc = (CustomerKitchenViewController *)currentVc;
            [vc reloadTableViewProcessingTab];
        }
        else if([currentVc isKindOfClass:[OrderDetailViewController class]] || [currentVc isKindOfClass:[PersonalDataViewController class]] || [currentVc isKindOfClass:[TosAndPrivacyPolicyViewController class]] || [currentVc isKindOfClass:[PrinterSettingViewController class]] || [currentVc isKindOfClass:[PrinterChoosingViewController class]] || [currentVc isKindOfClass:[ReportViewController class]] || [currentVc isKindOfClass:[ReportDetailsByDayViewController class]])
        {
            CustomViewController *vc = (CustomViewController *)currentVc;
            vc.issueComing = 1;
            [vc performSegueWithIdentifier:@"segUnwindToCustomerKitchen" sender:self];
        }
        else if([currentVc isKindOfClass:[MeViewController class]])
        {
            MeViewController *vc = (MeViewController *)currentVc;
            [vc.tabBarController setSelectedIndex:0];
            CustomerKitchenViewController *customerKitchenVc = vc.tabBarController.selectedViewController;
            [customerKitchenVc reloadTableViewProcessingTab];
        }
    }
    else if(homeModel.propCurrentDB == dbJummumReceiptTapNotificationDelivered)
    {
        [Utility updateSharedObject:items];
        
        
        //Get current vc
        CustomViewController *currentVc;
        CustomViewController *parentViewController = (CustomViewController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
        
        while (parentViewController.presentedViewController != nil && ![parentViewController.presentedViewController isKindOfClass:[UIAlertController class]])
        {
            parentViewController = (CustomViewController *)parentViewController.presentedViewController;
        }
        if([parentViewController isKindOfClass:[UITabBarController class]])
        {
            currentVc = ((UITabBarController *)parentViewController).selectedViewController;
        }
        else
        {
            currentVc = parentViewController;
        }
        
        
        
        if([currentVc isKindOfClass:[CustomerKitchenViewController class]])
        {
            CustomerKitchenViewController *vc = (CustomerKitchenViewController *)currentVc;
            [vc reloadTableViewDeliveredTab];
        }
        else if([currentVc isKindOfClass:[OrderDetailViewController class]] || [currentVc isKindOfClass:[PersonalDataViewController class]] || [currentVc isKindOfClass:[TosAndPrivacyPolicyViewController class]] || [currentVc isKindOfClass:[PrinterSettingViewController class]] || [currentVc isKindOfClass:[PrinterChoosingViewController class]] || [currentVc isKindOfClass:[ReportViewController class]] || [currentVc isKindOfClass:[ReportDetailsByDayViewController class]])
        {
            CustomViewController *vc = (CustomViewController *)currentVc;
            vc.issueComing = 1;
            [vc performSegueWithIdentifier:@"segUnwindToCustomerKitchen" sender:self];
        }
        else if([currentVc isKindOfClass:[MeViewController class]])
        {
            MeViewController *vc = (MeViewController *)currentVc;
            [vc.tabBarController setSelectedIndex:0];
            CustomerKitchenViewController *customerKitchenVc = vc.tabBarController.selectedViewController;
            [customerKitchenVc reloadTableViewDeliveredTab];
        }
    }
    else if(homeModel.propCurrentDB == dbJummumReceiptTapNotificationClear)
    {
        [Utility updateSharedObject:items];
        
        
        //Get current vc
        CustomViewController *currentVc;
        CustomViewController *parentViewController = (CustomViewController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
        
        while (parentViewController.presentedViewController != nil && ![parentViewController.presentedViewController isKindOfClass:[UIAlertController class]])
        {
            parentViewController = (CustomViewController *)parentViewController.presentedViewController;
        }
        if([parentViewController isKindOfClass:[UITabBarController class]])
        {
            currentVc = ((UITabBarController *)parentViewController).selectedViewController;
        }
        else
        {
            currentVc = parentViewController;
        }
        
        
        if([currentVc isKindOfClass:[CustomerKitchenViewController class]])
        {
            CustomerKitchenViewController *vc = (CustomerKitchenViewController *)currentVc;
            [vc reloadTableViewClearTab];
        }
        else if([currentVc isKindOfClass:[OrderDetailViewController class]] || [currentVc isKindOfClass:[PersonalDataViewController class]] || [currentVc isKindOfClass:[TosAndPrivacyPolicyViewController class]] || [currentVc isKindOfClass:[PrinterSettingViewController class]] || [currentVc isKindOfClass:[PrinterChoosingViewController class]] || [currentVc isKindOfClass:[ReportViewController class]] || [currentVc isKindOfClass:[ReportDetailsByDayViewController class]])
        {
            CustomViewController *vc = (CustomViewController *)currentVc;
            vc.issueComing = 1;
            [vc performSegueWithIdentifier:@"segUnwindToCustomerKitchen" sender:self];
        }
        else if([currentVc isKindOfClass:[MeViewController class]])
        {
            MeViewController *vc = (MeViewController *)currentVc;
            [vc.tabBarController setSelectedIndex:0];
            CustomerKitchenViewController *customerKitchenVc = vc.tabBarController.selectedViewController;
            [customerKitchenVc reloadTableViewClearTab];
        }
    }
    else if(homeModel.propCurrentDB == dbSetting)
    {
        [Utility updateSharedObject:items];
        
        
        //Get current vc
        CustomViewController *currentVc;
        CustomViewController *parentViewController = (CustomViewController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
        
        while (parentViewController.presentedViewController != nil && ![parentViewController.presentedViewController isKindOfClass:[UIAlertController class]])
        {
            parentViewController = (CustomViewController *)parentViewController.presentedViewController;
        }
        if([parentViewController isKindOfClass:[UITabBarController class]])
        {
            currentVc = ((UITabBarController *)parentViewController).selectedViewController;
        }
        else
        {
            currentVc = parentViewController;
        }
        
        
        
        if([currentVc isKindOfClass:[OpeningTimeViewController class]])
        {
            OpeningTimeViewController *vc = (OpeningTimeViewController *)currentVc;
            [vc reloadTableView];
        }        
    }
}

- (void)itemsFail
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:[Utility getErrorOccurTitle]
                                                                   message:[Utility getErrorOccurMessage]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [self alertMsg:@"database transaction fail"];
                                    }];
    
    [alert addAction:defaultAction];
    
    
    
    //Get current vc
    CustomViewController *currentVc;
    CustomViewController *parentViewController = (CustomViewController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    
    while (parentViewController.presentedViewController != nil && ![parentViewController.presentedViewController isKindOfClass:[UIAlertController class]])
    {
        parentViewController = (CustomViewController *)parentViewController.presentedViewController;
    }
    if([parentViewController isKindOfClass:[UITabBarController class]])
    {
        currentVc = ((UITabBarController *)parentViewController).selectedViewController;
    }
    else
    {
        currentVc = parentViewController;
    }
    
    
    //present alertController
    [currentVc removeOverlayViews];
    [currentVc presentViewController:alert animated:YES completion:nil];
}

- (void) connectionFail
{
    //เอา font มาใส่
    NSString *title = [Utility subjectNoConnection];
    NSString *message = [Utility detailNoConnection];
    
    
    
    //Get current vc
    CustomViewController *currentVc;
    CustomViewController *parentViewController = (CustomViewController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    
    
    
    while (parentViewController.presentedViewController != nil && ![parentViewController.presentedViewController isKindOfClass:[UIAlertController class]])
    {
        parentViewController = (CustomViewController *)parentViewController.presentedViewController;
    }
    if([parentViewController isKindOfClass:[UITabBarController class]])
    {
        currentVc = ((UITabBarController *)parentViewController).selectedViewController;
    }
    else
    {
        currentVc = parentViewController;
    }
    
    
    //present alertController
    [currentVc removeOverlayViews];
    [currentVc showAlert:title message:message];
}

- (void)alertMsg:(NSString *)msg
{
    NSString *title = @"";
    NSString *message = msg;
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *attrStringTitle = [[NSMutableAttributedString alloc] initWithString:title];
    [attrStringTitle addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:@"Prompt-SemiBold" size:17]
                            range:NSMakeRange(0, title.length)];
    [attrStringTitle addAttribute:NSForegroundColorAttributeName
                            value:cSystem4
                            range:NSMakeRange(0, title.length)];
    [alert setValue:attrStringTitle forKey:@"attributedTitle"];
    
    
    NSMutableAttributedString *attrStringMsg = [[NSMutableAttributedString alloc] initWithString:message];
    [attrStringMsg addAttribute:NSFontAttributeName
                          value:[UIFont fontWithName:@"Prompt-Regular" size:15]
                          range:NSMakeRange(0, message.length)];
    [attrStringTitle addAttribute:NSForegroundColorAttributeName
                            value:cSystem4
                            range:NSMakeRange(0, title.length)];
    [alert setValue:attrStringMsg forKey:@"attributedMessage"];
    
    
    
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                    }];
    
    [alert addAction:defaultAction];
    
    
    
    //Get current vc
    CustomViewController *currentVc;
    CustomViewController *parentViewController = (CustomViewController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    
    while (parentViewController.presentedViewController != nil && ![parentViewController.presentedViewController isKindOfClass:[UIAlertController class]])
    {
        parentViewController = (CustomViewController *)parentViewController.presentedViewController;
    }
    if([parentViewController isKindOfClass:[UITabBarController class]])
    {
        currentVc = ((UITabBarController *)parentViewController).selectedViewController;
    }
    else
    {
        currentVc = parentViewController;
    }
    
    
    //present alertController
    [currentVc removeOverlayViews];
    [currentVc presentViewController:alert animated:YES completion:nil];
    
    
    
    
    UIFont *font = [UIFont fontWithName:@"Prompt-SemiBold" size:15];
    UIColor *color = cSystem1;
    NSDictionary *attribute = @{NSForegroundColorAttributeName:color ,NSFontAttributeName: font};
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"OK" attributes:attribute];
    
    UILabel *label = [[defaultAction valueForKey:@"__representer"] valueForKey:@"label"];
    label.attributedText = attrString;
}

//printer part
- (void)loadParam {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    [delegate.settingManager load];
}

+ (NSString *)getPortName {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    return delegate.settingManager.settings[0].portName;
}

+ (void)setPortName:(NSString *)portName {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    delegate.settingManager.settings[0].portName = portName;
    [delegate.settingManager save];
}

+ (NSString *)getPortSettings {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    return delegate.settingManager.settings[0].portSettings;
}

+ (void)setPortSettings:(NSString *)portSettings {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    delegate.settingManager.settings[0].portSettings = portSettings;
    [delegate.settingManager save];
}

+ (NSString *)getModelName {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    return delegate.settingManager.settings[0].modelName;
}

+ (void)setModelName:(NSString *)modelName {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    delegate.settingManager.settings[0].modelName = modelName;
    [delegate.settingManager save];
}

+ (NSString *)getMacAddress {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    return delegate.settingManager.settings[0].macAddress;
}

+ (void)setMacAddress:(NSString *)macAddress {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    delegate.settingManager.settings[0].macAddress = macAddress;
    [delegate.settingManager save];
}

+ (StarIoExtEmulation)getEmulation {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    return delegate.settingManager.settings[0].emulation;
}

+ (void)setEmulation:(StarIoExtEmulation)emulation {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    delegate.settingManager.settings[0].emulation = emulation;
    [delegate.settingManager save];
}

+ (BOOL)getCashDrawerOpenActiveHigh {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    return delegate.settingManager.settings[0].cashDrawerOpenActiveHigh;
}

+ (void)setCashDrawerOpenActiveHigh:(BOOL)activeHigh {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    delegate.settingManager.settings[0].cashDrawerOpenActiveHigh = activeHigh;
    [delegate.settingManager save];
}

+ (NSInteger)getAllReceiptsSettings {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    return delegate.settingManager.settings[0].allReceiptsSettings;
}

+ (void)setAllReceiptsSettings:(NSInteger)allReceiptsSettings {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    delegate.settingManager.settings[0].allReceiptsSettings = allReceiptsSettings;
    [delegate.settingManager save];
}

+ (NSInteger)getSelectedIndex {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    return delegate.selectedIndex;
}

+ (void)setSelectedIndex:(NSInteger)index {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    delegate.selectedIndex = index;
}

+ (LanguageIndex)getSelectedLanguage {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    return delegate.selectedLanguage;
}

+ (void)setSelectedLanguage:(LanguageIndex)index {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    delegate.selectedLanguage = index;
}

+ (PaperSizeIndex)getSelectedPaperSize {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    return delegate.settingManager.settings[0].selectedPaperSize;
}

+ (void)setSelectedPaperSize:(PaperSizeIndex)index {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    delegate.settingManager.settings[0].selectedPaperSize = index;
    [delegate.settingManager save];
}

+ (ModelIndex)getSelectedModelIndex {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    return delegate.settingManager.settings[0].selectedModelIndex;
}

+ (void)setSelectedModelIndex:(ModelIndex)modelIndex {
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    delegate.settingManager.settings[0].selectedModelIndex = modelIndex;
    [delegate.settingManager save];
}
//end printer part
@end
        
