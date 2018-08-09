//
//  NoteType.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 20/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "NoteType.h"
#import "SharedNoteType.h"
#import "Utility.h"


@implementation NoteType

-(NoteType *)initWithName:(NSString *)name status:(NSInteger)status orderNo:(NSInteger)orderNo
{
    self = [super init];
    if(self)
    {
        self.noteTypeID = [NoteType getNextID];
        self.name = name;
        self.status = status;
        self.orderNo = orderNo;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"noteTypeID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedNoteType sharedNoteType].noteTypeList;
    
    
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

+(void)addObject:(NoteType *)noteType
{
    NSMutableArray *dataList = [SharedNoteType sharedNoteType].noteTypeList;
    [dataList addObject:noteType];
}

+(void)removeObject:(NoteType *)noteType
{
    NSMutableArray *dataList = [SharedNoteType sharedNoteType].noteTypeList;
    [dataList removeObject:noteType];
}

+(void)addList:(NSMutableArray *)noteTypeList
{
    NSMutableArray *dataList = [SharedNoteType sharedNoteType].noteTypeList;
    [dataList addObjectsFromArray:noteTypeList];
}

+(void)removeList:(NSMutableArray *)noteTypeList
{
    NSMutableArray *dataList = [SharedNoteType sharedNoteType].noteTypeList;
    [dataList removeObjectsInArray:noteTypeList];
}

+(NoteType *)getNoteType:(NSInteger)noteTypeID
{
    NSMutableArray *dataList = [SharedNoteType sharedNoteType].noteTypeList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_noteTypeID = %ld",noteTypeID];
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
        ((NoteType *)copy).noteTypeID = self.noteTypeID;
        [copy setName:self.name];
        ((NoteType *)copy).status = self.status;
        ((NoteType *)copy).orderNo = self.orderNo;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        
        
    }
    
    return copy;
}

-(BOOL)editNoteType:(NoteType *)editingNoteType
{
    if(self.noteTypeID == editingNoteType.noteTypeID
       && [self.name isEqualToString:editingNoteType.name]
       && self.status == editingNoteType.status
       && self.orderNo == editingNoteType.orderNo
       )
    {
        return NO;
    }
    return YES;
}

+(NoteType *)copyFrom:(NoteType *)fromNoteType to:(NoteType *)toNoteType
{
    toNoteType.noteTypeID = fromNoteType.noteTypeID;
    toNoteType.name = fromNoteType.name;
    toNoteType.status = fromNoteType.status;
    toNoteType.orderNo = fromNoteType.orderNo;
    toNoteType.modifiedUser = [Utility modifiedUser];
    toNoteType.modifiedDate = [Utility currentDateTime];
    
    return toNoteType;
}

+(void)setSharedData:(NSMutableArray *)dataList
{
    [SharedNoteType sharedNoteType].noteTypeList = dataList;
}

+(NSMutableArray *)getNoteTypeList
{
    NSMutableArray *dataList = [SharedNoteType sharedNoteType].noteTypeList;
    return dataList;
}

+(NSMutableArray *)sort:(NSMutableArray *)noteTypeList
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_orderNo" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"_type" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor,sortDescriptor2, nil];
    NSArray *sortArray = [noteTypeList sortedArrayUsingDescriptors:sortDescriptors];
    return [sortArray mutableCopy];
}
@end
