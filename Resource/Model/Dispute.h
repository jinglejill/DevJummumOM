//
//  Dispute.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 12/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dispute : NSObject
@property (nonatomic) NSInteger disputeID;
@property (nonatomic) NSInteger receiptID;
@property (nonatomic) NSInteger disputeReasonID;
@property (nonatomic) float refundAmount;
@property (retain, nonatomic) NSString * detail;
@property (retain, nonatomic) NSString * phoneNo;
@property (nonatomic) NSInteger type;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;



-(Dispute *)initWithReceiptID:(NSInteger)receiptID disputeReasonID:(NSInteger)disputeReasonID refundAmount:(float)refundAmount detail:(NSString *)detail phoneNo:(NSString *)phoneNo type:(NSInteger)type;
+(NSInteger)getNextID;
+(void)addObject:(Dispute *)dispute;
+(void)removeObject:(Dispute *)dispute;
+(void)addList:(NSMutableArray *)disputeList;
+(void)removeList:(NSMutableArray *)disputeList;
+(Dispute *)getDispute:(NSInteger)disputeID;
-(BOOL)editDispute:(Dispute *)editingDispute;
+(Dispute *)copyFrom:(Dispute *)fromDispute to:(Dispute *)toDispute;
+(Dispute *)getDisputeWithReceiptID:(NSInteger)receiptID type:(NSInteger)type;
+(NSMutableArray *)getList;

@end
