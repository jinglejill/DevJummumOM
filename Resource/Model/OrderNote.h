//
//  OrderNote.h
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/13/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderNote : NSObject
@property (nonatomic) NSInteger orderNoteID;
@property (nonatomic) NSInteger orderTakingID;
@property (nonatomic) NSInteger noteID;
@property (nonatomic) float quantity;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;


@property (nonatomic) NSInteger branchID;


- (NSDictionary *)dictionary;
-(OrderNote *)initWithOrderTakingID:(NSInteger)orderTakingID noteID:(NSInteger)noteID quantity:(float)quantity;
+(NSInteger)getNextID;
+(void)addObject:(OrderNote *)orderNote;
+(void)addList:(NSMutableArray *)orderNoteList;
+(void)removeObject:(OrderNote *)orderNote;
+(void)removeList:(NSMutableArray *)orderNoteList;
+(OrderNote *)getOrderNote:(NSInteger)orderNoteID;
+(OrderNote *)getOrderNoteWithOrderTakingID:(NSInteger)orderTakingID noteID:(NSInteger)noteID;
+(NSMutableArray *)getNoteListWithOrderTakingID:(NSInteger)orderTakingID;
+(NSMutableArray *)getOrderNoteListWithOrderTakingID:(NSInteger)orderTakingID;
+(NSMutableArray *)getOrderNoteListWithCustomerTableID:(NSInteger)customerTableID;
+(NSString *)getNoteNameListInTextWithOrderTakingID:(NSInteger)orderTakingID noteType:(NSInteger)noteType;
+(NSString *)getNoteIDListInTextWithOrderTakingID:(NSInteger)orderTakingID;
+(float)getSumNotePriceWithOrderTakingID:(NSInteger)orderTakingID;
+(OrderNote *)getOrderNoteWithNoteID:(NSInteger)noteID orderNoteList:(NSMutableArray *)orderNoteList;
+(NSMutableArray *)getNoteListWithOrderTakingID:(NSInteger)orderTakingID noteType:(NSInteger)noteType;
+(NSMutableArray *)getOrderNoteListWithOrderTakingList:(NSMutableArray *)orderTakingList;
+(void)removeAllObjects;
+(NSMutableArray *)getOrderNoteList;
+(NSMutableArray *)getNoteListWithOrderTakingID:(NSInteger)orderTakingID noteType:(NSInteger)noteType branchID:(NSInteger)branchID;
@end
