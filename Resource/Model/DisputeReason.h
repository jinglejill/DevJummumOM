//
//  DisputeReason.h
//  Jummum2
//
//  Created by Thidaporn Kijkamjai on 12/5/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DisputeReason : NSObject
@property (nonatomic) NSInteger disputeReasonID;
@property (retain, nonatomic) NSString * text;
@property (nonatomic) NSInteger type;
@property (nonatomic) NSInteger status;
@property (nonatomic) NSInteger orderNo;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;



-(DisputeReason *)initWithText:(NSString *)text type:(NSInteger)type status:(NSInteger)status orderNo:(NSInteger)orderNo;
+(NSInteger)getNextID;
+(void)addObject:(DisputeReason *)disputeReason;
+(void)removeObject:(DisputeReason *)disputeReason;
+(void)addList:(NSMutableArray *)disputeReasonList;
+(void)removeList:(NSMutableArray *)disputeReasonList;
+(DisputeReason *)getDisputeReason:(NSInteger)disputeReasonID;
-(BOOL)editDisputeReason:(DisputeReason *)editingDisputeReason;
+(DisputeReason *)copyFrom:(DisputeReason *)fromDisputeReason to:(DisputeReason *)toDisputeReason;
+(DisputeReason *)getDisputeReasonWithText:(NSString *)text;
+(void)setSharedData:(NSMutableArray *)dataList;


@end
