//
//  HomeModel.m
//  SaleAndInventoryManagement
//
//  Created by Thidaporn Kijkamjai on 7/9/2558 BE.
//  Copyright (c) 2558 Thidaporn Kijkamjai. All rights reserved.
//
#import <objc/runtime.h>
#import "HomeModel.h"
#import "Utility.h"
#import "PushSync.h"
#import "LogIn.h"
#import "UserAccount.h"
#import "Branch.h"
#import "Menu.h"
#import "Pic.h"
#import "MenuPic.h"
#import "Receipt.h"
#import "OrderTaking.h"
#import "OrderNote.h"
#import "UserPromotionUsed.h"
#import "RewardPoint.h"
#import "FacebookComment.h"
#import "HotDeal.h"
#import "RewardRedemption.h"
#import "PromoCode.h"
#import "Message.h"
#import "UserRewardRedemptionUsed.h"
#import "DisputeReason.h"
#import "Dispute.h"
#import "CredentialsDb.h"
#import "ReceiptPrint.h"
//#import "TestPassword.h"


@interface HomeModel()
{
    NSMutableData *_downloadedData;
    BOOL _downloadSuccess;
}
@end
@implementation HomeModel
@synthesize propCurrentDB;
@synthesize propCurrentDBInsert;
@synthesize propCurrentDBUpdate;


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if(!error)
    {
        NSLog(@"Download is Successful");
        switch (propCurrentDB) {
            case dbMasterWithProgressBar:
            case dbMaster:
                if(!_downloadSuccess)//กรณีไม่มี content length จึงไม่รู้ว่า datadownload/downloadsize = 1 -> _downloadSuccess จึงไม่ถูก set เป็น yes
                {
                    NSLog(@"content length = -1");
                    [self prepareData];
                }
                break;
                
                
            default:
                break;
        }
    }
    else
    {
        NSLog(@"Error %@",[error userInfo]);
        if (self.delegate)
        {
            [self.delegate connectionFail];
        }
    }
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)dataRaw;
{
    NSArray *arrClassName;
    switch (propCurrentDB)
    {
        case dbMaster:
        case dbMasterWithProgressBar:
        {
            [_dataToDownload appendData:dataRaw];
            if(propCurrentDB == dbMasterWithProgressBar)
            {
                if(self.delegate)
                {
                    [self.delegate downloadProgress:[_dataToDownload length ]/_downloadSize];
                }
            }
            
            
            if([ _dataToDownload length ]/_downloadSize == 1.0f)
            {
                _downloadSuccess = YES;
                [self prepareData];
            }
        }
            break;
        case dbMenuList:
        {
            arrClassName = @[@"Menu",@"MenuType",@"MenuTypeNote",@"Note",@"NoteType",@"SubMenuType",@"SpecialPriceProgram"];
        }
            break;
        case dbCustomerTable:
        {
            arrClassName = @[@"CustomerTable"];
        }
            break;
        case dbReceiptSummary:
        {
            arrClassName = @[@"Receipt",@"OrderTaking",@"OrderNote"];
        }
            break;
        case dbPromotion:
        {
            arrClassName = @[@"Promotion",@"Message",@"Message"];
        }
            break;
        case dbUserAccount:
        {
            arrClassName = @[@"UserAccount"];
        }
            break;
        case dbRewardPoint:
        {
            arrClassName = @[@"RewardPoint",@"RewardRedemption"];
        }
            break;
        case dbHotDeal:
        {
            arrClassName = @[@"HotDeal"];
        }
            break;
        case dbRewardPointSpent:
        {
            arrClassName = @[@"RewardPoint",@"PromoCode",@"RewardRedemption"];
        }
            break;
        case dbRewardPointSpentMore:
        {
            arrClassName = @[@"RewardPoint",@"PromoCode",@"RewardRedemption"];
        }
            break;
        case dbRewardPointSpentUsed:
        {
            arrClassName = @[@"RewardPoint",@"PromoCode",@"RewardRedemption"];
        }
        break;
        case dbRewardPointSpentUsedMore:
        {
            arrClassName = @[@"RewardPoint",@"PromoCode",@"RewardRedemption"];
        }
        break;
        case dbReceipt:
        {
            arrClassName = @[@"Receipt"];
        }
            break;
        case dbReceiptWithModifiedDate:
        {
            arrClassName = @[@"Receipt",@"Dispute"];
        }
        break;
        case dbDisputeReasonList:
        {
            arrClassName = @[@"DisputeReason"];
        }
            break;
        case dbDisputeList:
        {
            arrClassName = @[@"Dispute"];
        }
        break;
        case dbCredentialsDb:
        {
            arrClassName = @[@"CredentialsDb"];
        }
            break;
        case dbJummumReceipt:
        case dbReceiptMaxModifiedDate:
        case dbJummumReceiptTapNotification:
        case dbJummumReceiptTapNotificationIssue:
        {
            arrClassName = @[@"Receipt",@"OrderTaking",@"OrderNote",@"Dispute"];
        }
            break;
        case dbBranch:
        {
            arrClassName = @[@"Branch"];
        }
            break;
        case dbOpeningTimeText:
        {
            arrClassName = @[@"Message"];
        }
            break;
        case dbSetting:
        {
            arrClassName = @[@"Setting"];
        }
            break;
        default:
            break;
    }
    if(propCurrentDB != dbMaster && propCurrentDB != dbMasterWithProgressBar)
    {
        [_dataToDownload appendData:dataRaw];
        if([ _dataToDownload length ]/_downloadSize == 1.0f)
        {
            NSMutableArray *arrItem = [[NSMutableArray alloc] init];
            
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:_dataToDownload options:NSJSONReadingAllowFragments error:nil];
            
            if(!jsonArray)
            {
                return;
            }
            for(int i=0; i<[jsonArray count]; i++)
            {
                //arrdatatemp <= arrdata
                NSMutableArray *arrDataTemp = [[NSMutableArray alloc]init];
                NSArray *arrData = jsonArray[i];
                for(int j=0; j< arrData.count; j++)
                {
                    NSDictionary *jsonElement = arrData[j];
                    NSObject *object = [[NSClassFromString([Utility getMasterClassName:i from:arrClassName]) alloc] init];
                    
                    unsigned int propertyCount = 0;
                    objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
                    
                    for (unsigned int i = 0; i < propertyCount; ++i)
                    {
                        objc_property_t property = properties[i];
                        const char * name = property_getName(property);
                        NSString *key = [NSString stringWithUTF8String:name];
                        
                        
                        NSString *dbColumnName = [Utility makeFirstLetterUpperCase:key];
                        if(!jsonElement[dbColumnName])
                        {
                            continue;
                        }
                        
                        
                        if([Utility isDateColumn:dbColumnName])
                        {
                            NSDate *date = [Utility stringToDate:jsonElement[dbColumnName] fromFormat:@"yyyy-MM-dd HH:mm:ss"];
                            if(!date)
                            {
                                date = [Utility stringToDate:jsonElement[dbColumnName] fromFormat:@"yyyy-MM-dd"];
                            }
                            [object setValue:date forKey:key];
                        }
                        else
                        {
                            [object setValue:jsonElement[dbColumnName] forKey:key];
                        }
                    }
                    [arrDataTemp addObject:object];
                }
                [arrItem addObject:arrDataTemp];
            }
            
            // Ready to notify delegate that data is ready and pass back items
            if (self.delegate)
            {
                if(propCurrentDB == dbJummumReceipt || propCurrentDB == dbJummumReceiptTapNotification || propCurrentDB == dbJummumReceiptTapNotificationIssue || propCurrentDB == dbCredentialsDb || propCurrentDB == dbOpeningTimeText || propCurrentDB == dbSetting)
                {
                    [self.delegate itemsDownloaded:arrItem manager:self];
                }
                else
                {
                    [self.delegate itemsDownloaded:arrItem];
                }
            }
        }
    }
}

-(void)prepareData
{
    NSLog(@"start prepare data");
    NSMutableArray *arrItem = [[NSMutableArray alloc] init];
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:_dataToDownload options:NSJSONReadingAllowFragments error:nil];
    
    
    //check loaded data ให้ไม่ต้องใส่ data แล้ว ไปบอก delegate ว่าให้ show alert error occur, please try again
    if([jsonArray count] == 0)
    {
        if (self.delegate)
        {
            [self.delegate itemsDownloaded:arrItem];
        }
        return;
    }
    else if([jsonArray count] == 1)
    {
        NSArray *arrData = jsonArray[0];
        NSDictionary *jsonElement = arrData[0];
        
        if(jsonElement[@"Expired"])
        {
            if([jsonElement[@"Expired"] isEqualToString:@"1"])
            {
                if (self.delegate)
                {
                    [self.delegate applicationExpired];
                }
                return;
            }
        }
    }
    for(int i=0; i<[jsonArray count]; i++)
    {
        //arrdatatemp <= arrdata
        NSMutableArray *arrDataTemp = [[NSMutableArray alloc]init];
        NSArray *arrData = jsonArray[i];
        for(int j=0; j< arrData.count; j++)
        {
            NSDictionary *jsonElement = arrData[j];
            NSObject *object = [[NSClassFromString([Utility getMasterClassName:i]) alloc] init];
            
            unsigned int propertyCount = 0;
            objc_property_t * properties = class_copyPropertyList([object class], &propertyCount);
            
            for (unsigned int i = 0; i < propertyCount; ++i)
            {
                objc_property_t property = properties[i];
                const char * name = property_getName(property);
                NSString *key = [NSString stringWithUTF8String:name];
                
                
                NSString *dbColumnName = [Utility makeFirstLetterUpperCase:key];
                if(!jsonElement[dbColumnName])
                {
                    continue;
                }
                
                if([Utility isDateColumn:dbColumnName])
                {
                    NSDate *date = [Utility stringToDate:jsonElement[dbColumnName] fromFormat:@"yyyy-MM-dd HH:mm:ss"];
                    [object setValue:date forKey:key];
                }
                else
                {
                    [object setValue:jsonElement[dbColumnName] forKey:key];
                }
            }
            [arrDataTemp addObject:object];
        }
        [arrItem addObject:arrDataTemp];
    }
    NSLog(@"end prepare data");
    
    // Ready to notify delegate that data is ready and pass back items
    if (self.delegate)
    {
        [self.delegate itemsDownloaded:arrItem manager:self];
//        [self.delegate itemsDownloaded:arrItem];
    }
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    completionHandler(NSURLSessionResponseAllow);
    
    switch (propCurrentDB) {
        case dbMasterWithProgressBar:
        {
            if(self.delegate)
            {
                [self.delegate downloadProgress:0.0f];
            }
        }
            break;
        default:
            break;
    }
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    NSLog(@"expected content length httpResponse: %ld", (long)[httpResponse expectedContentLength]);
    
    NSLog(@"expected content length response: %lld",[response expectedContentLength]);
    _downloadSize=[response expectedContentLength];
    _dataToDownload=[[NSMutableData alloc]init];
}

- (void)downloadItems:(enum enumDB)currentDB
{
    propCurrentDB = currentDB;
    NSURL *url;
    NSString *noteDataString = @"";
    switch (currentDB)
    {
        case dbMaster:
        {
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlMasterGet]]];
        }
            break;
        case dbMasterWithProgressBar:
        {
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlMasterGet]]];
        }
            break;
        case dbOpeningTimeText:
        {
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlOpeningTimeTextGet]]];
        }
            break;
        default:
        break;
    }
    

    noteDataString = [NSString stringWithFormat:@"%@&modifiedDeviceToken=%@&modifiedUser=%@&branchID=%ld",noteDataString,[Utility deviceToken],[Utility modifiedUser],[Utility branchID]];
    
    

    NSLog(@"url: %@",url);
    NSLog(@"notedatastring: %@",noteDataString);
    
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate:self delegateQueue: [NSOperationQueue mainQueue]];
    
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[noteDataString dataUsingEncoding:NSUTF8StringEncoding]];
    [urlRequest setValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:urlRequest];
    
    [dataTask resume];
}

- (void)downloadItems:(enum enumDB)currentDB withData:(NSObject *)data
{
    propCurrentDB = currentDB;
    NSURL *url;
    NSString *noteDataString = @"";
    switch (currentDB)
    {
        case dbMenuList:
        {
            noteDataString = [NSString stringWithFormat:@"dbNameBranch=%@",(NSString *)data];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlMenuGetList]]];
        }
            break;
        case dbCustomerTable:
        {
            noteDataString = [NSString stringWithFormat:@"dbNameBranch=%@",(NSString *)data];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlCustomerTableGetList]]];
        }
        break;
        case dbReceiptSummary:
        {
            NSArray *dataList = (NSArray *)data;
            Receipt *receipt = dataList[0];
            CredentialsDb *credentialDb = dataList[1];
            NSString *strReceiptDate = [Utility dateToString:receipt.receiptDate toFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            
            noteDataString = [NSString stringWithFormat:@"receiptDate=%@&receiptID=%ld&branchID=%ld&status=%ld",strReceiptDate,receipt.receiptID,credentialDb.branchID,receipt.status];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlReceiptSummaryGetList]]];
            
        }
            break;
        case dbPromotion:
        {
            NSArray *dataList = (NSArray *)data;
            NSString *strVoucherCode = dataList[0];
            UserAccount *userAccount = dataList[1];
            Branch *branch = dataList[2];
            float totalAmount = [dataList[3] floatValue];
            noteDataString = [NSString stringWithFormat:@"voucherCode=%@&userAccountID=%ld&mainBranchID=%ld&totalAmount=%f",strVoucherCode,userAccount.userAccountID,branch.mainBranchID,totalAmount];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlPromotionGetList]]];
        }
            break;
        case dbUserAccount:
        {
            noteDataString = [NSString stringWithFormat:@"username=%@",(NSString *)data];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlUserAccountGet]]];
        }
            break;
        case dbRewardPoint:
        {
            UserAccount *userAccount = (UserAccount *)data;
            noteDataString = [NSString stringWithFormat:@"memberID=%ld",userAccount.userAccountID];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlRewardPointGet]]];
        }
            break;
        case dbRewardPointSpent:
        {
            UserAccount *userAccount = (UserAccount *)data;
            noteDataString = [NSString stringWithFormat:@"memberID=%ld",userAccount.userAccountID];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlRewardPointSpentGetList]]];
        }
            break;
        case dbRewardPointSpentMore:
        {
            NSArray *dataList = (NSArray *)data;
            RewardPoint *rewardPoint = (RewardPoint *)dataList[0];
            UserAccount *userAccount = (UserAccount *)dataList[1];
            noteDataString = [NSString stringWithFormat:@"modifiedDate=%@&rewardPointID=%ld&memberID=%ld",rewardPoint.modifiedDate,rewardPoint.rewardPointID,userAccount.userAccountID];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlRewardPointSpentMoreGetList]]];
        }
            break;
        case dbRewardPointSpentUsed:
        {
            UserAccount *userAccount = (UserAccount *)data;
            noteDataString = [NSString stringWithFormat:@"memberID=%ld",userAccount.userAccountID];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlRewardPointSpentUsedGetList]]];
        }
        break;
        case dbRewardPointSpentUsedMore:
        {
            NSArray *dataList = (NSArray *)data;
            RewardPoint *rewardPoint = (RewardPoint *)dataList[0];
            UserAccount *userAccount = (UserAccount *)dataList[1];
            noteDataString = [NSString stringWithFormat:@"modifiedDate=%@&rewardPointID=%ld&memberID=%ld",rewardPoint.modifiedDate,rewardPoint.rewardPointID,userAccount.userAccountID];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlRewardPointSpentUsedMoreGetList]]];
        }
        break;
        case dbHotDeal:
        {
            UserAccount *userAccount = (UserAccount *)data;
            noteDataString = [NSString stringWithFormat:@"memberID=%ld",userAccount.userAccountID];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlHotDealGetList]]];
        }
            break;
        case dbReceiptMaxModifiedDate:
        {
            NSArray *dataList = (NSArray *)data;
            CredentialsDb *credentialsDb = dataList[0];
            NSDate *maxReceiptModifiedDate = dataList[1];
            noteDataString = [NSString stringWithFormat:@"branchID=%ld&modifiedDate=%@",credentialsDb.branchID,maxReceiptModifiedDate];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlReceiptMaxModifiedDateGetList]]];
        }
            break;
        case dbReceiptWithModifiedDate:
        {
            Receipt *receipt = (Receipt *)data;
            
            noteDataString = [Utility getNoteDataString:receipt];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlReceiptWithModifiedDateGet]]];
        }
            break;
        case dbReceipt:
        {
            Receipt *receipt = (Receipt *)data;
            
            noteDataString = [Utility getNoteDataString:receipt];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlReceiptGet]]];
        }
            break;
        case dbDisputeReasonList:
        {
            NSNumber *objType = (NSNumber *)data;
            noteDataString = [NSString stringWithFormat:@"type=%ld",[objType integerValue]];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlDisputeReasonGetList]]];
        }
            break;
        case dbDisputeList:
        {
            Receipt *receipt = (Receipt *)data;
            noteDataString = [NSString stringWithFormat:@"receiptID=%ld&status=%ld",receipt.receiptID,receipt.status];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlDisputeGetList]]];
        }
            break;
        case dbCredentialsDb:
        {
            NSString *username = (NSString *)data;
            noteDataString = [NSString stringWithFormat:@"username=%@",username];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlCredentialsDbGet]]];
            
        }
            break;
        case dbJummumReceipt:
//        case dbJummumReceiptPrint:
//        case dbJummumReceiptUpdate:
        case dbJummumReceiptTapNotification:
        case dbJummumReceiptTapNotificationIssue:
        {
            NSNumber *receiptID = (NSNumber *)data;
            
            noteDataString = [NSString stringWithFormat:@"receiptID=%ld&branchID=%ld",[receiptID integerValue],[Utility branchID]];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlJummumReceiptGetList]]];
        }
            break;
        case dbBranch:
        {
            NSString *dbName = (NSString *)data;
            noteDataString = [NSString stringWithFormat:@"dbName=%@",dbName];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlBranchGet]]];
        }
        break;
        case dbSetting:
        {
            NSNumber *settingID = (NSNumber *)data;
            
            noteDataString = [NSString stringWithFormat:@"settingID=%ld",[settingID integerValue]];
            url = [NSURL URLWithString:[Utility appendRandomParam:[Utility url:urlSettingGet]]];
        }
            break;
        default:
            break;
    }
    noteDataString = [NSString stringWithFormat:@"%@&modifiedDeviceToken=%@&modifiedUser=%@&branchID=%ld",noteDataString,[Utility deviceToken],[Utility modifiedUser],[Utility branchID]];
    NSLog(@"url: %@",url);
    NSLog(@"notedatastring: %@",noteDataString);
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate:self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[noteDataString dataUsingEncoding:NSUTF8StringEncoding]];
    [urlRequest setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:urlRequest];
    [dataTask resume];
}

- (void)insertItems:(enum enumDB)currentDB withData:(NSObject *)data actionScreen:(NSString *)actionScreen
{
    propCurrentDBInsert = currentDB;
    NSURL * url;
    NSString *noteDataString;
    switch (currentDB)
    {
        case dbWriteLog:
        {
            noteDataString = [NSString stringWithFormat:@"stackTrace=%@",(NSString *)data];
            url = [NSURL URLWithString:[Utility url:urlWriteLog]];
        }
            break;
        case dbDevice:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlDeviceInsert]];
        }
            break;
        case dbLogIn:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlLogInInsert]];
        }
            break;
        case dbLogInUserAccount:
        {
            NSArray *dataList = (NSArray *)data;
            LogIn *logIn = dataList[0];
            UserAccount *userAccount = dataList[1];
            
            
            noteDataString = [Utility getNoteDataString:logIn];
            noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:userAccount]];
            url = [NSURL URLWithString:[Utility url:urlLogInUserAccountInsert]];
        }
            break;
        case dbMenu:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlMenuInsert]];
        }
            break;
        case dbMenuList:
        {
            NSMutableArray *menuList = (NSMutableArray *)data;
            NSInteger countMenu = 0;
            
            noteDataString = [NSString stringWithFormat:@"countMenu=%ld",[menuList count]];
            for(Menu *item in menuList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countMenu]];
                countMenu++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlMenuInsertList]];
        }
            break;
        case dbPic:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlPicInsert]];
        }
            break;
        case dbPicList:
        {
            NSMutableArray *picList = (NSMutableArray *)data;
            NSInteger countPic = 0;
            
            noteDataString = [NSString stringWithFormat:@"countPic=%ld",[picList count]];
            for(Pic *item in picList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countPic]];
                countPic++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlPicInsertList]];
        }
            break;
        case dbMenuPic:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlMenuPicInsert]];
        }
            break;
        case dbMenuPicList:
        {
            NSMutableArray *menuPicList = (NSMutableArray *)data;
            NSInteger countMenuPic = 0;
            
            noteDataString = [NSString stringWithFormat:@"countMenuPic=%ld",[menuPicList count]];
            for(MenuPic *item in menuPicList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countMenuPic]];
                countMenuPic++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlMenuPicInsertList]];
        }
            break;
        case dbOmiseCheckOut:
        {
            NSArray *dataList = (NSArray *)data;
            NSString *omiseToken = dataList[0];
            NSInteger amount = [dataList[1] integerValue];
            Receipt *receipt = dataList[2];
            NSMutableArray *orderTakingList = dataList[3];
            NSMutableArray *orderNoteList = dataList[4];
            NSObject *userPromotionOrRewardRedemptionUsed = dataList[5];
            NSInteger type = [userPromotionOrRewardRedemptionUsed isMemberOfClass:[UserPromotionUsed class]]?1:2;
            
            
            noteDataString = [NSString stringWithFormat:@"omiseToken=%@&amount=%ld&type=%ld",omiseToken,(long)amount,type];
            noteDataString = [NSString stringWithFormat:@"%@&countOtOrderTaking=%ld&countOnOrderNote=%ld",noteDataString,(unsigned long)[orderTakingList count],[orderNoteList count]];
            noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:receipt]];
            noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:userPromotionOrRewardRedemptionUsed withPrefix:@"pr"]];
            for(int i=0; i<[orderTakingList count]; i++)
            {
                OrderTaking *orderTaking = orderTakingList[i];
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:orderTaking withPrefix:@"ot" runningNo:i]];
            }
            for(int i=0; i<[orderNoteList count]; i++)
            {
                OrderNote *orderNote = orderNoteList[i];
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:orderNote withPrefix:@"on" runningNo:i]];
            }
            
            
            url = [NSURL URLWithString:[Utility url:urlOmiseCheckOut]];
        }
            break;
        case dbFacebookComment:
        {
            NSMutableArray *facebookCommentList = (NSMutableArray *)data;
            NSInteger countFacebookComment = 0;
            
            noteDataString = [NSString stringWithFormat:@"countFacebookComment=%ld",[facebookCommentList count]];
            for(FacebookComment *item in facebookCommentList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo3Digit:countFacebookComment]];
                countFacebookComment++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlFacebookComment]];
        }
            break;
        case dbUserAccountValidate:
        {
            NSArray *dataList = (NSArray *)data;
            UserAccount *userAccount = dataList[0];
            LogIn *logIn = dataList[1];
            noteDataString = [Utility getNoteDataString:userAccount];
            noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:logIn]];
            url = [NSURL URLWithString:[Utility url:urlUserAccountValidate]];
        }
            break;
        case dbUserAccount:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlUserAccountInsert]];
        }
            break;
        case dbUserAccountForgotPassword:
        {
            noteDataString = [NSString stringWithFormat:@"username=%@",(NSString *)data];
            url = [NSURL URLWithString:[Utility url:urlUserAccountForgotPasswordInsert]];
        }
            break;
        case dbRewardPoint:
        {
            NSArray *dataList = (NSArray *)data;
            RewardPoint *rewardPoint = dataList[0];
            RewardRedemption *rewardRedemption = dataList[1];
            noteDataString = [Utility getNoteDataString:rewardPoint];
            noteDataString = [NSString stringWithFormat:@"%@&rewardRedemptionID=%ld",noteDataString,rewardRedemption.rewardRedemptionID];
//            noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:rewardRedemption withPrefix:@"rr"]];
            url = [NSURL URLWithString:[Utility url:urlRewardPointInsert]];
        }
            break;
        case dbRewardPointList:
        {
            NSMutableArray *rewardPointList = (NSMutableArray *)data;
            NSInteger countRewardPoint = 0;
            
            noteDataString = [NSString stringWithFormat:@"countRewardPoint=%ld",[rewardPointList count]];
            for(RewardPoint *item in rewardPointList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countRewardPoint]];
                countRewardPoint++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlRewardPointInsertList]];
        }
            break;
        case dbPushReminder:
        {
            NSArray *dataList = (NSArray *)data;
            Branch *branch = dataList[0];
            Receipt *receipt = dataList[1];
            
            noteDataString = [NSString stringWithFormat:@"branchID=%ld&receiptID=%ld",branch.branchID,receipt.receiptID];
            url = [NSURL URLWithString:[Utility url:urlPushReminder]];
        }
            break;
        case dbHotDeal:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlHotDealInsert]];
        }
            break;
        case dbHotDealList:
        {
            NSMutableArray *hotDealList = (NSMutableArray *)data;
            NSInteger countHotDeal = 0;
            
            noteDataString = [NSString stringWithFormat:@"countHotDeal=%ld",[hotDealList count]];
            for(HotDeal *item in hotDealList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countHotDeal]];
                countHotDeal++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlHotDealInsertList]];
        }
            break;
        case dbRewardRedemption:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlRewardRedemptionInsert]];
        }
            break;
        case dbRewardRedemptionList:
        {
            NSMutableArray *rewardRedemptionList = (NSMutableArray *)data;
            NSInteger countRewardRedemption = 0;
            
            noteDataString = [NSString stringWithFormat:@"countRewardRedemption=%ld",[rewardRedemptionList count]];
            for(RewardRedemption *item in rewardRedemptionList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countRewardRedemption]];
                countRewardRedemption++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlRewardRedemptionInsertList]];
        }
            break;
        case dbPromoCode:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlPromoCodeInsert]];
        }
            break;
        case dbPromoCodeList:
        {
            NSMutableArray *promoCodeList = (NSMutableArray *)data;
            NSInteger countPromoCode = 0;
            
            noteDataString = [NSString stringWithFormat:@"countPromoCode=%ld",[promoCodeList count]];
            for(PromoCode *item in promoCodeList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countPromoCode]];
                countPromoCode++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlPromoCodeInsertList]];
        }
            break;
        case dbUserRewardRedemptionUsed:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlUserRewardRedemptionUsedInsert]];
        }
        break;
        case dbUserRewardRedemptionUsedList:
        {
            NSMutableArray *userRewardRedemptionUsedList = (NSMutableArray *)data;
            NSInteger countUserRewardRedemptionUsed = 0;
            
            noteDataString = [NSString stringWithFormat:@"countUserRewardRedemptionUsed=%ld",[userRewardRedemptionUsedList count]];
            for(UserRewardRedemptionUsed *item in userRewardRedemptionUsedList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countUserRewardRedemptionUsed]];
                countUserRewardRedemptionUsed++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlUserRewardRedemptionUsedInsertList]];
        }
        break;
        case dbDisputeReason:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlDisputeReasonInsert]];
        }
            break;
        case dbDisputeReasonList:
        {
            NSMutableArray *disputeReasonList = (NSMutableArray *)data;
            NSInteger countDisputeReason = 0;
            
            noteDataString = [NSString stringWithFormat:@"countDisputeReason=%ld",[disputeReasonList count]];
            for(DisputeReason *item in disputeReasonList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countDisputeReason]];
                countDisputeReason++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlDisputeReasonInsertList]];
        }
            break;
        case dbDispute:
        {
            NSArray *dataList = (NSArray *)data;
            Dispute *dispute = dataList[0];
            NSNumber *branchID = dataList[1];
            noteDataString = [Utility getNoteDataString:dispute];
            noteDataString = [NSString stringWithFormat:@"%@&branchID=%ld",noteDataString,[branchID integerValue]];
            url = [NSURL URLWithString:[Utility url:urlDisputeInsert]];
        }
            break;
        case dbDisputeCancel:
        {
            NSArray *dataList = (NSArray *)data;
            Dispute *dispute = dataList[0];
            NSNumber *branchID = dataList[1];
            noteDataString = [Utility getNoteDataString:dispute];
            noteDataString = [NSString stringWithFormat:@"%@&branchID=%ld",noteDataString,[branchID integerValue]];
            url = [NSURL URLWithString:[Utility url:urlDisputeCancelInsert]];
        }
            break;
        case dbDisputeList:
        {
            NSMutableArray *disputeList = (NSMutableArray *)data;
            NSInteger countDispute = 0;
            
            noteDataString = [NSString stringWithFormat:@"countDispute=%ld",[disputeList count]];
            for(Dispute *item in disputeList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countDispute]];
                countDispute++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlDisputeInsertList]];
        }
            break;
        case dbCredentials:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlCredentialsValidate]];
        }
            break;
        case dbReceiptPrintList:
        {
            NSMutableArray *receiptPrintList = (NSMutableArray *)data;
            NSInteger countReceiptPrint = 0;
            
            noteDataString = [NSString stringWithFormat:@"countReceiptPrint=%ld",[receiptPrintList count]];
            for(ReceiptPrint *item in receiptPrintList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countReceiptPrint]];
                countReceiptPrint++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlReceiptPrintInsertList]];
        }
            break;
        default:
            break;
    }
    noteDataString = [NSString stringWithFormat:@"%@&modifiedDeviceToken=%@&modifiedUser=%@&branchID=%ld&actionScreen=%@",noteDataString,[Utility deviceToken],[Utility modifiedUser],[Utility branchID],actionScreen];
    NSLog(@"url: %@",url);
    NSLog(@"notedatastring: %@",noteDataString);
    
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[noteDataString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLSessionDataTask * dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *dataRaw, NSURLResponse *header, NSError *error) {
        
        if(!error || (error && error.code == -1005))//-1005 คือ1. ตอน push notification ไม่ได้ และ2. ตอน enterbackground ตอน transaction ยังไม่เสร็จ พอ enter foreground มันจะไม่ return data มาให้
        {
            switch (propCurrentDB)
            {
                default:
                {
                    if(!dataRaw)
                    {
                        //data parameter is nil
                        NSLog(@"Error: %@", [error debugDescription]);
                        return ;
                    }
                    
                    NSDictionary *json = [NSJSONSerialization
                                          JSONObjectWithData:dataRaw
                                          options:kNilOptions error:&error];
                    NSString *status = json[@"status"];
                    NSString *strReturnID = json[@"returnID"];
                    NSArray *dataJson = json[@"dataJson"];
                    NSString *strTableName = json[@"tableName"];
                    if([status isEqual:@"1"])
                    {
                        NSLog(@"insert success");
                        if(strReturnID)
                        {
                            if (self.delegate)
                            {
                                [self.delegate itemsInsertedWithReturnID:strReturnID];
                            }
                        }
                        else if(strTableName)
                        {
                            NSArray *arrClassName;
                            if([strTableName isEqualToString:@"UserAccountValidate"] || [strTableName isEqualToString:@"LogInUserAccount"])
                            {
                                if([dataJson count] == 1)
                                {
                                    arrClassName = @[@"UserAccount"];
                                }
                                else
                                {
                                    arrClassName = @[@"UserAccount",@"Setting",@"CustomerTable",@"MenuType",@"Menu",@"NoteType",@"Note",@"Receipt",@"OrderTaking",@"OrderNote",@"Dispute",@"DisputeReason",@"Branch"];
                                }
                            }
                            else if([strTableName isEqualToString:@"UserAccountForgotPassword"])
                            {
                                arrClassName = @[@"UserAccount"];
                            }
                            else if([strTableName isEqualToString:@"OmiseCheckOut"])
                            {
                                arrClassName = @[@"Receipt",@"OrderTaking",@"OrderNote"];
                            }
                            else if([strTableName isEqualToString:@"RewardPoint"])
                            {
                                arrClassName = @[@"PromoCode"];
                            }
                            else if([strTableName isEqualToString:@"Receipt"])
                            {
                                arrClassName = @[@"Receipt",@"Dispute"];
                            }
                            
                            NSArray *items = [Utility jsonToArray:dataJson arrClassName:arrClassName];
                            if(self.delegate)
                            {
                                [self.delegate itemsInsertedWithReturnData:items];
                            }
                        }
                        else
                        {
                            if(self.delegate)
                            {
                                if(propCurrentDBInsert == dbCredentials || propCurrentDBInsert == dbDevice)
                                {
                                    NSMutableArray *dataList = [[NSMutableArray alloc]init];
                                    [self.delegate itemsInsertedWithManager:self items:dataList];
                                }
                                else
                                {
                                    [self.delegate itemsInserted];
                                }
                            }
                        }
                    }
                    else if([status isEqual:@"2"])
                    {
                        //alertMsg
                        if(self.delegate)
                        {
                            if(propCurrentDBInsert == dbCredentials)
                            {
                                NSString *msg = json[@"msg"];
                                NSMutableArray *dataList = [[NSMutableArray alloc]init];
                                NSMutableArray *messgeList = [[NSMutableArray alloc]init];
                                Message *message = [[Message alloc]init];
                                message.text = msg;
                                [messgeList addObject:message];
                                [dataList addObject:messgeList];
                                [self.delegate itemsInsertedWithManager:self items:dataList];
                                NSLog(@"msg: %@", msg);
                            }
                            else
                            {
                                NSString *msg = json[@"msg"];
                                [self.delegate alertMsg:msg];
                                NSLog(@"msg: %@", msg);
                            }
                            
                            NSLog(@"status: %@", status);
                        }                                        
                    }
                    else
                    {
                        //Error
                        NSLog(@"insert fail: %ld",currentDB);
                        NSLog(@"%@", status);
                        if (self.delegate)
                        {
                            [self.delegate itemsFail];
                        }
                    }
                }
                    break;
            }
        }
        else
        {
            if (self.delegate)
            {
                [self.delegate itemsFail];
                //                [self.delegate connectionFail];
            }
            
            NSLog(@"Error: %@", [error debugDescription]);
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }];
    
    [dataTask resume];
}

- (void)updateItems:(enum enumDB)currentDB withData:(NSObject *)data actionScreen:(NSString *)actionScreen
{
    propCurrentDBUpdate = currentDB;
    NSURL * url;
    NSString *noteDataString;
    
    switch (currentDB)
    {
        case dbPushSyncUpdateTimeSynced:
        {
            NSMutableArray *pushSyncList = (NSMutableArray *)data;
            NSInteger countPushSync = 0;
            
            noteDataString = [NSString stringWithFormat:@"countPushSync=%ld",[pushSyncList count]];
            for(PushSync *item in pushSyncList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countPushSync]];
                countPushSync++;
            }
            url = [NSURL URLWithString:[Utility url:urlPushSyncUpdateTimeSynced]];
        }
            break;
        case dbPushSyncUpdateByDeviceToken:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlPushSyncUpdateByDeviceToken]];
        }
            break;
        case dbMenu:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlMenuUpdate]];
        }
            break;
        case dbMenuList:
        {
            NSMutableArray *menuList = (NSMutableArray *)data;
            NSInteger countMenu = 0;
            
            noteDataString = [NSString stringWithFormat:@"countMenu=%ld",[menuList count]];
            for(Menu *item in menuList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countMenu]];
                countMenu++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlMenuUpdateList]];
        }
            break;
        case dbPic:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlPicUpdate]];
        }
            break;
        case dbPicList:
        {
            NSMutableArray *picList = (NSMutableArray *)data;
            NSInteger countPic = 0;
            
            noteDataString = [NSString stringWithFormat:@"countPic=%ld",[picList count]];
            for(Pic *item in picList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countPic]];
                countPic++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlPicUpdateList]];
        }
            break;
        case dbMenuPic:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlMenuPicUpdate]];
        }
            break;
        case dbMenuPicList:
        {
            NSMutableArray *menuPicList = (NSMutableArray *)data;
            NSInteger countMenuPic = 0;
            
            noteDataString = [NSString stringWithFormat:@"countMenuPic=%ld",[menuPicList count]];
            for(MenuPic *item in menuPicList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countMenuPic]];
                countMenuPic++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlMenuPicUpdateList]];
        }
            break;
        case dbRewardPoint:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlRewardPointUpdate]];
        }
            break;
        case dbRewardPointList:
        {
            NSMutableArray *rewardPointList = (NSMutableArray *)data;
            NSInteger countRewardPoint = 0;
            
            noteDataString = [NSString stringWithFormat:@"countRewardPoint=%ld",[rewardPointList count]];
            for(RewardPoint *item in rewardPointList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countRewardPoint]];
                countRewardPoint++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlRewardPointUpdateList]];
        }
            break;
        case dbHotDeal:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlHotDealUpdate]];
        }
            break;
        case dbHotDealList:
        {
            NSMutableArray *hotDealList = (NSMutableArray *)data;
            NSInteger countHotDeal = 0;
            
            noteDataString = [NSString stringWithFormat:@"countHotDeal=%ld",[hotDealList count]];
            for(HotDeal *item in hotDealList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countHotDeal]];
                countHotDeal++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlHotDealUpdateList]];
        }
            break;
        case dbRewardRedemption:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlRewardRedemptionUpdate]];
        }
            break;
        case dbRewardRedemptionList:
        {
            NSMutableArray *rewardRedemptionList = (NSMutableArray *)data;
            NSInteger countRewardRedemption = 0;
            
            noteDataString = [NSString stringWithFormat:@"countRewardRedemption=%ld",[rewardRedemptionList count]];
            for(RewardRedemption *item in rewardRedemptionList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countRewardRedemption]];
                countRewardRedemption++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlRewardRedemptionUpdateList]];
        }
            break;
        case dbPromoCode:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlPromoCodeUpdate]];
        }
            break;
        case dbPromoCodeList:
        {
            NSMutableArray *promoCodeList = (NSMutableArray *)data;
            NSInteger countPromoCode = 0;
            
            noteDataString = [NSString stringWithFormat:@"countPromoCode=%ld",[promoCodeList count]];
            for(PromoCode *item in promoCodeList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countPromoCode]];
                countPromoCode++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlPromoCodeUpdateList]];
        }
            break;
        case dbUserRewardRedemptionUsed:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlUserRewardRedemptionUsedUpdate]];
        }
        break;
        case dbUserRewardRedemptionUsedList:
        {
            NSMutableArray *userRewardRedemptionUsedList = (NSMutableArray *)data;
            NSInteger countUserRewardRedemptionUsed = 0;
            
            noteDataString = [NSString stringWithFormat:@"countUserRewardRedemptionUsed=%ld",[userRewardRedemptionUsedList count]];
            for(UserRewardRedemptionUsed *item in userRewardRedemptionUsedList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countUserRewardRedemptionUsed]];
                countUserRewardRedemptionUsed++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlUserRewardRedemptionUsedUpdateList]];
        }
        break;
        case dbDisputeReason:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlDisputeReasonUpdate]];
        }
            break;
        case dbDisputeReasonList:
        {
            NSMutableArray *disputeReasonList = (NSMutableArray *)data;
            NSInteger countDisputeReason = 0;
            
            noteDataString = [NSString stringWithFormat:@"countDisputeReason=%ld",[disputeReasonList count]];
            for(DisputeReason *item in disputeReasonList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countDisputeReason]];
                countDisputeReason++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlDisputeReasonUpdateList]];
        }
            break;
        case dbDispute:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlDisputeUpdate]];
        }
            break;
        case dbDisputeList:
        {
            NSMutableArray *disputeList = (NSMutableArray *)data;
            NSInteger countDispute = 0;
            
            noteDataString = [NSString stringWithFormat:@"countDispute=%ld",[disputeList count]];
            for(Dispute *item in disputeList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countDispute]];
                countDispute++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlDisputeUpdateList]];
        }
            break;
        case dbReceipt:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlReceiptUpdate]];
        }
        break;
        case dbJummumReceipt:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlJummumReceiptUpdate]];
        }
            break;
        case dbJummumReceiptSendToKitchen:
        case dbJummumReceiptDelivered:
        {
            NSArray *dataList =  (NSArray *)data;
            Receipt *receipt = dataList[0];
//            NSDate *maxModifiedDate = dataList[1];
            noteDataString = [Utility getNoteDataString:receipt];
//            noteDataString = [NSString stringWithFormat:@"%@&maxModifiedDate=%@",noteDataString,maxModifiedDate];
            url = [NSURL URLWithString:[Utility url:urlJummumReceiptSendToKitchen]];
        }
        break;
        case dbSetting:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlSettingUpdate]];
        }
        default:
            break;
    }
    
    
    noteDataString = [NSString stringWithFormat:@"%@&modifiedDeviceToken=%@&modifiedUser=%@&branchID=%ld&actionScreen=%@",noteDataString,[Utility deviceToken],[Utility modifiedUser],[Utility branchID],actionScreen];
    NSLog(@"url: %@",url);
    NSLog(@"notedatastring: %@",noteDataString);
    
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[noteDataString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *dataRaw, NSURLResponse *header, NSError *error) {
        
        if(!error || (error && error.code == -1005))//-1005 คือตอน push notification ไม่ได้
        {
            if(!dataRaw)
            {
                //data parameter is nil
                NSLog(@"Error: %@", [error debugDescription]);
                return ;
            }
            
            NSDictionary *json = [NSJSONSerialization
                                  JSONObjectWithData:dataRaw
                                  options:kNilOptions error:&error];
            NSString *status = json[@"status"];
            NSArray *dataJson = json[@"dataJson"];
            NSString *strTableName = json[@"tableName"];
            
            if([status isEqual:@"1"])
            {
                NSLog(@"update success");
                if(strTableName)
                {
                    NSArray *arrClassName;
                    if([strTableName isEqualToString:@"ReceiptSendToKitchen"])
                    {
//                        arrClassName = @[@"Message",@"Receipt",@"Receipt"];
                        arrClassName = @[@"Message",@"Receipt"];
                    }
                    else if([strTableName isEqualToString:@"Receipt"])
                    {
                        arrClassName = @[@"Receipt"];
                    }
                    else if([strTableName isEqualToString:@"Setting"])
                    {
                        arrClassName = @[@"Setting"];
                    }
                    
                    NSArray *items = [Utility jsonToArray:dataJson arrClassName:arrClassName];
                    if(self.delegate)
                    {
                        [self.delegate itemsUpdatedWithManager:self items:items];
                    }
                }
                else
                {
                    if(propCurrentDBUpdate == dbAlarmUpdate || propCurrentDBUpdate == dbAlarm)
                    {
                        if(self.delegate)
                        {
                            [self.delegate itemsUpdatedWithManager:self];
                        }
                    }
                    else
                    {
                        if(self.delegate)
                        {
                            [self.delegate itemsUpdated];
                        }
                    }
                    
                }
            }
            else if([status isEqual:@"2"])
            {
                NSString *alert = json[@"alert"];
                if (self.delegate)
                {
                    [self.delegate itemsUpdated:alert];
                }
            }
            else
            {
                //Error
                NSLog(@"update fail");
                NSLog(@"%@", status);
                if (self.delegate)
                {
                    [self.delegate itemsFail];
                }
            }
        }
        else
        {
            if (self.delegate)
            {
                [self.delegate itemsFail];
                //                [self.delegate connectionFail];
            }
            NSLog(@"Error: %@", [error debugDescription]);
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }];
    
    [dataTask resume];
}

- (void)deleteItems:(enum enumDB)currentDB withData:(NSObject *)data actionScreen:(NSString *)actionScreen
{
    propCurrentDB = currentDB;
    NSURL * url;
    NSString *noteDataString;
    
    switch (currentDB)
    {
        case dbMenu:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlMenuDelete]];
        }
            break;
        case dbMenuList:
        {
            NSMutableArray *menuList = (NSMutableArray *)data;
            NSInteger countMenu = 0;
            
            noteDataString = [NSString stringWithFormat:@"countMenu=%ld",[menuList count]];
            for(Menu *item in menuList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countMenu]];
                countMenu++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlMenuDeleteList]];
        }
            break;
        case dbPic:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlPicDelete]];
        }
            break;
        case dbPicList:
        {
            NSMutableArray *picList = (NSMutableArray *)data;
            NSInteger countPic = 0;
            
            noteDataString = [NSString stringWithFormat:@"countPic=%ld",[picList count]];
            for(Pic *item in picList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countPic]];
                countPic++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlPicDeleteList]];
        }
            break;
        case dbMenuPic:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlMenuPicDelete]];
        }
            break;
        case dbMenuPicList:
        {
            NSMutableArray *menuPicList = (NSMutableArray *)data;
            NSInteger countMenuPic = 0;
            
            noteDataString = [NSString stringWithFormat:@"countMenuPic=%ld",[menuPicList count]];
            for(MenuPic *item in menuPicList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countMenuPic]];
                countMenuPic++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlMenuPicDeleteList]];
        }
            break;
        case dbRewardPoint:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlRewardPointDelete]];
        }
            break;
        case dbRewardPointList:
        {
            NSMutableArray *rewardPointList = (NSMutableArray *)data;
            NSInteger countRewardPoint = 0;
            
            noteDataString = [NSString stringWithFormat:@"countRewardPoint=%ld",[rewardPointList count]];
            for(RewardPoint *item in rewardPointList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countRewardPoint]];
                countRewardPoint++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlRewardPointDeleteList]];
        }
            break;
        case dbHotDeal:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlHotDealDelete]];
        }
            break;
        case dbHotDealList:
        {
            NSMutableArray *hotDealList = (NSMutableArray *)data;
            NSInteger countHotDeal = 0;
            
            noteDataString = [NSString stringWithFormat:@"countHotDeal=%ld",[hotDealList count]];
            for(HotDeal *item in hotDealList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countHotDeal]];
                countHotDeal++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlHotDealDeleteList]];
        }
            break;
        case dbRewardRedemption:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlRewardRedemptionDelete]];
        }
            break;
        case dbRewardRedemptionList:
        {
            NSMutableArray *rewardRedemptionList = (NSMutableArray *)data;
            NSInteger countRewardRedemption = 0;
            
            noteDataString = [NSString stringWithFormat:@"countRewardRedemption=%ld",[rewardRedemptionList count]];
            for(RewardRedemption *item in rewardRedemptionList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countRewardRedemption]];
                countRewardRedemption++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlRewardRedemptionDeleteList]];
        }
            break;
        case dbPromoCode:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlPromoCodeDelete]];
        }
            break;
        case dbPromoCodeList:
        {
            NSMutableArray *promoCodeList = (NSMutableArray *)data;
            NSInteger countPromoCode = 0;
            
            noteDataString = [NSString stringWithFormat:@"countPromoCode=%ld",[promoCodeList count]];
            for(PromoCode *item in promoCodeList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countPromoCode]];
                countPromoCode++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlPromoCodeDeleteList]];
        }
            break;
        case dbUserRewardRedemptionUsed:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlUserRewardRedemptionUsedDelete]];
        }
        break;
        case dbUserRewardRedemptionUsedList:
        {
            NSMutableArray *userRewardRedemptionUsedList = (NSMutableArray *)data;
            NSInteger countUserRewardRedemptionUsed = 0;
            
            noteDataString = [NSString stringWithFormat:@"countUserRewardRedemptionUsed=%ld",[userRewardRedemptionUsedList count]];
            for(UserRewardRedemptionUsed *item in userRewardRedemptionUsedList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countUserRewardRedemptionUsed]];
                countUserRewardRedemptionUsed++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlUserRewardRedemptionUsedDeleteList]];
        }
        break;
        case dbDisputeReason:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlDisputeReasonDelete]];
        }
            break;
        case dbDisputeReasonList:
        {
            NSMutableArray *disputeReasonList = (NSMutableArray *)data;
            NSInteger countDisputeReason = 0;
            
            noteDataString = [NSString stringWithFormat:@"countDisputeReason=%ld",[disputeReasonList count]];
            for(DisputeReason *item in disputeReasonList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countDisputeReason]];
                countDisputeReason++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlDisputeReasonDeleteList]];
        }
            break;
        case dbDispute:
        {
            noteDataString = [Utility getNoteDataString:data];
            url = [NSURL URLWithString:[Utility url:urlDisputeDelete]];
        }
            break;
        case dbDisputeList:
        {
            NSMutableArray *disputeList = (NSMutableArray *)data;
            NSInteger countDispute = 0;
            
            noteDataString = [NSString stringWithFormat:@"countDispute=%ld",[disputeList count]];
            for(Dispute *item in disputeList)
            {
                noteDataString = [NSString stringWithFormat:@"%@&%@",noteDataString,[Utility getNoteDataString:item withRunningNo:countDispute]];
                countDispute++;
            }
            
            url = [NSURL URLWithString:[Utility url:urlDisputeDeleteList]];
        }
            break;

        default:
            break;
    }
    
    
    noteDataString = [NSString stringWithFormat:@"%@&modifiedDeviceToken=%@&modifiedUser=%@&branchID=%ld&actionScreen=%@",noteDataString,[Utility deviceToken],[Utility modifiedUser],[Utility branchID],actionScreen];
    NSLog(@"url: %@",url);
    NSLog(@"notedatastring: %@",noteDataString);
    
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[noteDataString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *dataRaw, NSURLResponse *header, NSError *error) {
        if(!error || (error && error.code == -1005))//-1005 คือตอน push notification ไม่ได้
        {
            if(!dataRaw)
            {
                //data parameter is nil
                NSLog(@"Error: %@", [error debugDescription]);
                return ;
            }
            
            NSDictionary *json = [NSJSONSerialization
                                  JSONObjectWithData:dataRaw
                                  options:kNilOptions error:&error];
            NSString *status = json[@"status"];
            if([status isEqual:@"1"])
            {
                NSLog(@"delete success");
            }
            else
            {
                //Error
                NSLog(@"delete fail");
                NSLog(@"%@", status);
                if (self.delegate)
                {
                    [self.delegate itemsFail];
                }
            }
        }
        else
        {
            if (self.delegate)
            {
                [self.delegate itemsFail];
                //                [self.delegate connectionFail];
            }
            NSLog(@"Error: %@", [error debugDescription]);
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }];
    
    [dataTask resume];
}

-(void)sendEmail:(NSString *)toAddress withSubject:(NSString *)subject andBody:(NSString *)body
{
    NSString *bodyPercentEscape = [Utility percentEscapeString:body];
    NSString *noteDataString = [NSString stringWithFormat:@"toAddress=%@&subject=%@&body=%@", toAddress,subject,bodyPercentEscape];
    noteDataString = [NSString stringWithFormat:@"%@&modifiedDeviceToken=%@&modifiedUser=%@&branchID=%ld",noteDataString,[Utility deviceToken],[Utility modifiedUser],[Utility branchID]];
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:[Utility url:urlSendEmail]];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[noteDataString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *dataRaw, NSURLResponse *header, NSError *error) {
        
        if(!error || (error && error.code == -1005))
        {
            if(!dataRaw)
            {
                //data parameter is nil
                NSLog(@"Error: %@", [error debugDescription]);
                [self.delegate removeOverlayViewConnectionFail];
                return ;
            }
            
            NSDictionary *json = [NSJSONSerialization
                                  JSONObjectWithData:dataRaw
                                  options:kNilOptions error:&error];
            NSString *status = json[@"status"];
            if([status isEqual:@"1"])
            {
                
            }
            else
            {
                //Error
                NSLog(@"send email fail");
                NSLog(@"%@", status);
                if (self.delegate)
                {
                    [self.delegate itemsFail];
                }
            }
        }
        else
        {
            if (self.delegate)
            {
                [self.delegate connectionFail];
            }
            NSLog(@"Error: %@", [error debugDescription]);
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }];
    
    [dataTask resume];
}

-(void)uploadPhoto:(NSData *)imageData fileName:(NSString *)fileName
{
    if (imageData != nil)
    {
        NSString *noteDataString = @"";
        noteDataString = [NSString stringWithFormat:@"%@&modifiedDeviceToken=%@&modifiedUser=%@&branchID=%ld",noteDataString,[Utility deviceToken],[Utility modifiedUser],[Utility branchID]];
        
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
        
        NSURL * url = [NSURL URLWithString:[Utility url:urlUploadPhoto]];
        NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
        [urlRequest setHTTPMethod:@"POST"];
        //        [urlRequest setHTTPBody:[noteDataString dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        NSMutableData *body = [NSMutableData data];
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [urlRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        
        NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
        [_params setObject:[Utility modifiedUser] forKey:@"modifiedUser"];
        [_params setObject:[Utility deviceToken] forKey:@"modifiedDeviceToken"];
        [_params setObject:[Utility dbName] forKey:@"dbName"];
        for (NSString *param in _params)
        {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@.jpg\"\r\n",fileName] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [body appendData:[noteDataString dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [urlRequest setHTTPBody:body];
        
        NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *dataRaw, NSURLResponse *header, NSError *error) {
            if(error && error.code != -1005)
            {
                if (self.delegate)
                {
                    [self.delegate connectionFail];
                }
                NSLog(@"Error: %@", [error debugDescription]);
                NSLog(@"Error: %@", [error localizedDescription]);
            }
        }];
        
        [dataTask resume];
    }
}

- (void)downloadImageWithFileName:(NSString *)fileName completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSString* escapeString = [Utility percentEscapeString:fileName];
    NSString *noteDataString = [NSString stringWithFormat:@"imageFileName=%@",escapeString];
    noteDataString = [NSString stringWithFormat:@"%@&modifiedDeviceToken=%@&modifiedUser=%@&branchID=%ld",noteDataString,[Utility deviceToken],[Utility modifiedUser],[Utility branchID]];
    NSURL * url = [NSURL URLWithString:[Utility url:urlDownloadPhoto]];
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[noteDataString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *dataRaw, NSURLResponse *header, NSError *error) {
        if(error)
        {
            completionBlock(NO,nil);
        }
        else
        {
            NSDictionary *json = [NSJSONSerialization
                                  JSONObjectWithData:dataRaw
                                  options:kNilOptions error:&error];
            
            
            NSString *base64String = json[@"base64String"];
            if(json && base64String && ![base64String isEqualToString:@""])
            {
                NSData *nsDataEncrypted = [[NSData alloc] initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
                
                UIImage *image = [[UIImage alloc] initWithData:nsDataEncrypted];
                completionBlock(YES,image);
            }
            else
            {
                completionBlock(NO,nil);
            }
        }
    }];
    
    [dataTask resume];
}
- (void)downloadFileWithFileName:(NSString *)fileName completionBlock:(void (^)(BOOL succeeded, NSData *data))completionBlock
{
    NSString* escapeString = [Utility percentEscapeString:fileName];
    NSString *noteDataString = [NSString stringWithFormat:@"fileName=%@",escapeString];
    noteDataString = [NSString stringWithFormat:@"%@&modifiedDeviceToken=%@&modifiedUser=%@&branchID=%ld",noteDataString,[Utility deviceToken],[Utility modifiedUser],[Utility branchID]];
    NSURL * url = [NSURL URLWithString:[Utility url:urlDownloadFile]];
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[noteDataString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *dataRaw, NSURLResponse *header, NSError *error) {
        if(error != nil)
        {
            completionBlock(NO,nil);
        }
        else
        {
            NSDictionary *json = [NSJSONSerialization
                                  JSONObjectWithData:dataRaw
                                  options:kNilOptions error:&error];
            
            
            NSString *base64String = json[@"base64String"];
            if(json && base64String && ![base64String isEqualToString:@""])
            {
                NSData *nsDataEncrypted = [[NSData alloc] initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
                
                completionBlock(YES,nsDataEncrypted);
            }
            else
            {
                completionBlock(NO,nil);
            }
        }
    }];
    
    [dataTask resume];
}

@end

