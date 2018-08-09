//
//  MenuTypeNote.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 20/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "MenuTypeNote.h"
#import "Note.h"
#import "SharedMenuTypeNote.h"
#import "Utility.h"


@implementation MenuTypeNote

-(MenuTypeNote *)initWithMenuTypeID:(NSInteger)menuTypeID noteID:(NSInteger)noteID
{
    self = [super init];
    if(self)
    {
        self.menuTypeNoteID = [MenuTypeNote getNextID];
        self.menuTypeID = menuTypeID;
        self.noteID = noteID;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"menuTypeNoteID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedMenuTypeNote sharedMenuTypeNote].menuTypeNoteList;
    
    
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

+(void)addObject:(MenuTypeNote *)menuTypeNote
{
    NSMutableArray *dataList = [SharedMenuTypeNote sharedMenuTypeNote].menuTypeNoteList;
    [dataList addObject:menuTypeNote];
}

+(void)removeObject:(MenuTypeNote *)menuTypeNote
{
    NSMutableArray *dataList = [SharedMenuTypeNote sharedMenuTypeNote].menuTypeNoteList;
    [dataList removeObject:menuTypeNote];
}

+(void)addList:(NSMutableArray *)menuTypeNoteList
{
    NSMutableArray *dataList = [SharedMenuTypeNote sharedMenuTypeNote].menuTypeNoteList;
    [dataList addObjectsFromArray:menuTypeNoteList];
}

+(void)removeList:(NSMutableArray *)menuTypeNoteList
{
    NSMutableArray *dataList = [SharedMenuTypeNote sharedMenuTypeNote].menuTypeNoteList;
    [dataList removeObjectsInArray:menuTypeNoteList];
}

+(MenuTypeNote *)getMenuTypeNote:(NSInteger)menuTypeNoteID
{
    NSMutableArray *dataList = [SharedMenuTypeNote sharedMenuTypeNote].menuTypeNoteList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_menuTypeNoteID = %ld",menuTypeNoteID];
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
        ((MenuTypeNote *)copy).menuTypeNoteID = self.menuTypeNoteID;
        ((MenuTypeNote *)copy).menuTypeID = self.menuTypeID;
        ((MenuTypeNote *)copy).noteID = self.noteID;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        
        
    }
    
    return copy;
}

-(BOOL)editMenuTypeNote:(MenuTypeNote *)editingMenuTypeNote
{
    if(self.menuTypeNoteID == editingMenuTypeNote.menuTypeNoteID
       && self.menuTypeID == editingMenuTypeNote.menuTypeID
       && self.noteID == editingMenuTypeNote.noteID
       )
    {
        return NO;
    }
    return YES;
}

+(MenuTypeNote *)copyFrom:(MenuTypeNote *)fromMenuTypeNote to:(MenuTypeNote *)toMenuTypeNote
{
    toMenuTypeNote.menuTypeNoteID = fromMenuTypeNote.menuTypeNoteID;
    toMenuTypeNote.menuTypeID = fromMenuTypeNote.menuTypeID;
    toMenuTypeNote.noteID = fromMenuTypeNote.noteID;
    toMenuTypeNote.modifiedUser = [Utility modifiedUser];
    toMenuTypeNote.modifiedDate = [Utility currentDateTime];
    
    return toMenuTypeNote;
}

+(void)setSharedData:(NSMutableArray *)dataList
{
    [SharedMenuTypeNote sharedMenuTypeNote].menuTypeNoteList = dataList;
}


+(NSMutableArray *)getMenuTypeNoteList
{
    NSMutableArray *dataList = [SharedMenuTypeNote sharedMenuTypeNote].menuTypeNoteList;
    return dataList;
}

+(NSMutableArray *)getNoteListWithMenuTypeID:(NSInteger)menuTypeID
{
    NSMutableArray *dataList = [SharedMenuTypeNote sharedMenuTypeNote].menuTypeNoteList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_menuTypeID = %ld",menuTypeID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    
    
    NSMutableArray *noteList = [[NSMutableArray alloc]init];
    for(MenuTypeNote *item in filterArray)
    {
        Note *note = [Note getNote:item.noteID];
        [noteList addObject:note];
    }
    
    
    noteList = [Note getNoteListWithStatus:1 noteList:noteList];
    return noteList;
}
@end
