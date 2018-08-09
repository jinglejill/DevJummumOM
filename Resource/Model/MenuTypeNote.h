//
//  MenuTypeNote.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 20/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuTypeNote : NSObject
@property (nonatomic) NSInteger menuTypeNoteID;
@property (nonatomic) NSInteger menuTypeID;
@property (nonatomic) NSInteger noteID;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;



-(MenuTypeNote *)initWithMenuTypeID:(NSInteger)menuTypeID noteID:(NSInteger)noteID;
+(NSInteger)getNextID;
+(void)addObject:(MenuTypeNote *)menuTypeNote;
+(void)removeObject:(MenuTypeNote *)menuTypeNote;
+(void)addList:(NSMutableArray *)menuTypeNoteList;
+(void)removeList:(NSMutableArray *)menuTypeNoteList;
+(MenuTypeNote *)getMenuTypeNote:(NSInteger)menuTypeNoteID;
-(BOOL)editMenuTypeNote:(MenuTypeNote *)editingMenuTypeNote;
+(MenuTypeNote *)copyFrom:(MenuTypeNote *)fromMenuTypeNote to:(MenuTypeNote *)toMenuTypeNote;
+(void)setSharedData:(NSMutableArray *)dataList;
+(NSMutableArray *)getMenuTypeNoteList;
+(NSMutableArray *)getNoteListWithMenuTypeID:(NSInteger)menuTypeID;
@end
