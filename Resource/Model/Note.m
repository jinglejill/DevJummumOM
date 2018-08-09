//
//  Note.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 20/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "Note.h"
#import "SharedNote.h"
#import "Utility.h"


@implementation Note

-(Note *)initWithName:(NSString *)name price:(float)price noteTypeID:(NSInteger)noteTypeID type:(NSInteger)type status:(NSInteger)status orderNo:(NSInteger)orderNo
{
    self = [super init];
    if(self)
    {
        self.noteID = [Note getNextID];
        self.name = name;
        self.price = price;
        self.noteTypeID = noteTypeID;
        self.type = type;
        self.status = status;
        self.orderNo = orderNo;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"noteID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedNote sharedNote].noteList;
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:propertyName ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [dataList sortedArrayUsingDescriptors:sortDescriptors];
    dataList = [sortArray mutableCopy];
    
    if([dataList count] == 0)
    {
        return -1;
    }
    else
    {
        id value = [dataList[0] valueForKey:primaryKeyName];
        if([value integerValue]>0)
        {
            return -1;
        }
        else
        {
            return [value integerValue]-1;
        }
    }
}

+(void)addObject:(Note *)note
{
    NSMutableArray *dataList = [SharedNote sharedNote].noteList;
    [dataList addObject:note];
}

+(void)removeObject:(Note *)note
{
    NSMutableArray *dataList = [SharedNote sharedNote].noteList;
    [dataList removeObject:note];
}

+(void)addList:(NSMutableArray *)noteList
{
    NSMutableArray *dataList = [SharedNote sharedNote].noteList;
    [dataList addObjectsFromArray:noteList];
}

+(void)removeList:(NSMutableArray *)noteList
{
    NSMutableArray *dataList = [SharedNote sharedNote].noteList;
    [dataList removeObjectsInArray:noteList];
}

+(Note *)getNote:(NSInteger)noteID
{
    NSMutableArray *dataList = [SharedNote sharedNote].noteList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_noteID = %ld",noteID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

-(id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        ((Note *)copy).noteID = self.noteID;
        [copy setName:self.name];
        ((Note *)copy).price = self.price;
        ((Note *)copy).noteTypeID = self.noteTypeID;
        ((Note *)copy).type = self.type;
        ((Note *)copy).status = self.status;
        ((Note *)copy).orderNo = self.orderNo;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        
        
    }
    
    return copy;
}

-(BOOL)editNote:(Note *)editingNote
{
    if(self.noteID == editingNote.noteID
       && [self.name isEqualToString:editingNote.name]
       && self.price == editingNote.price
       && self.noteTypeID == editingNote.noteTypeID
       && self.type == editingNote.type
       && self.status == editingNote.status
       && self.orderNo == editingNote.orderNo
       )
    {
        return NO;
    }
    return YES;
}

+(Note *)copyFrom:(Note *)fromNote to:(Note *)toNote
{
    toNote.noteID = fromNote.noteID;
    toNote.name = fromNote.name;
    toNote.price = fromNote.price;
    toNote.noteTypeID = fromNote.noteTypeID;
    toNote.type = fromNote.type;
    toNote.status = fromNote.status;
    toNote.orderNo = fromNote.orderNo;
    toNote.modifiedUser = [Utility modifiedUser];
    toNote.modifiedDate = [Utility currentDateTime];
    
    return toNote;
}

+(void)setSharedData:(NSMutableArray *)dataList
{
    [SharedNote sharedNote].noteList = dataList;
}


+(NSMutableArray *)getNoteList
{
    NSMutableArray *dataList = [SharedNote sharedNote].noteList;
    return dataList;
}

+(NSMutableArray *)getNoteListWithStatus:(NSInteger)status noteList:(NSMutableArray *)noteList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_status = %ld",status];
    NSArray *filterArray = [noteList filteredArrayUsingPredicate:predicate];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [filterArray sortedArrayUsingDescriptors:sortDescriptors];
    
    return [sortArray mutableCopy];
}

+(NSMutableArray *)getNoteListWithNoteTypeID:(NSInteger)noteTypeID type:(NSInteger)type noteList:(NSMutableArray *)noteList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_noteTypeID = %ld and _type = %ld",noteTypeID,type];
    NSArray *filterArray = [noteList filteredArrayUsingPredicate:predicate];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [filterArray sortedArrayUsingDescriptors:sortDescriptors];
    
    return [sortArray mutableCopy];
}

+(NSMutableArray *)getNoteListWithNoteTypeID:(NSInteger)noteTypeID noteList:(NSMutableArray *)noteList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_noteTypeID = %ld",noteTypeID];
    NSArray *filterArray = [noteList filteredArrayUsingPredicate:predicate];
    
    
    return [filterArray mutableCopy];
}

@end
