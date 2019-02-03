//
//  NoteType.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 20/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteType : NSObject
@property (nonatomic) NSInteger noteTypeID;
@property (retain, nonatomic) NSString * name;
@property (nonatomic) NSInteger status;
@property (nonatomic) NSInteger orderNo;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;




@property (nonatomic) NSInteger type;


-(NoteType *)initWithName:(NSString *)name status:(NSInteger)status orderNo:(NSInteger)orderNo;
+(NSInteger)getNextID;
+(void)addObject:(NoteType *)noteType;
+(void)removeObject:(NoteType *)noteType;
+(void)addList:(NSMutableArray *)noteTypeList;
+(void)removeList:(NSMutableArray *)noteTypeList;
+(NoteType *)getNoteType:(NSInteger)noteTypeID;
-(BOOL)editNoteType:(NoteType *)editingNoteType;
+(NoteType *)copyFrom:(NoteType *)fromNoteType to:(NoteType *)toNoteType;
+(void)setSharedData:(NSMutableArray *)dataList;
+(NSMutableArray *)getNoteTypeList;
+(NSMutableArray *)sort:(NSMutableArray *)noteTypeList;
+(void)removeAllObjects;
@end
