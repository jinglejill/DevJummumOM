//
//  GprinterReceiptCheckCommand.h
//  GprinterSDK
//
//  Created by ShaoDan on 2017/9/16.
//  Copyright © 2017年 Gainscha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GprinterReceiptCheckCommand : NSObject

//连接connection
-(instancetype)OpenPort:(NSString*)host port:(UInt16)port timeout:(NSTimeInterval)timeout;
//断开disconnect
- (void)ClosePort;

//查询机型Inquiry model
-(void)SearchTheModelNum;

//查询打印机状态Query printer status
-(void)SearchPrinterStatus:(int)n;

//发送请求send request
- (void)SendToPrinter;

//接收打印机的数据Receive printer data
@property (nonatomic, strong) NSMutableData *sendrData;
//返回的机型号
@property(nonatomic,strong)NSString *ModeStr;


//判断
@property(assign,nonatomic)BOOL isSearchMode;
@property (assign,nonatomic)int numOfStatus;




@end
