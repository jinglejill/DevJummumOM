//
//  Pic.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 19/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "Pic.h"
#import "SharedPic.h"
#import "Utility.h"


@implementation Pic

-(Pic *)initWithUrl:(NSString *)url
{
    self = [super init];
    if(self)
    {
        self.picID = [Pic getNextID];
        self.url = url;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"picID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedPic sharedPic].picList;
    
    
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

+(void)addObject:(Pic *)pic
{
    NSMutableArray *dataList = [SharedPic sharedPic].picList;
    [dataList addObject:pic];
}

+(void)removeObject:(Pic *)pic
{
    NSMutableArray *dataList = [SharedPic sharedPic].picList;
    [dataList removeObject:pic];
}

+(void)addList:(NSMutableArray *)picList
{
    NSMutableArray *dataList = [SharedPic sharedPic].picList;
    [dataList addObjectsFromArray:picList];
}

+(void)removeList:(NSMutableArray *)picList
{
    NSMutableArray *dataList = [SharedPic sharedPic].picList;
    [dataList removeObjectsInArray:picList];
}

+(Pic *)getPic:(NSInteger)picID
{
    NSMutableArray *dataList = [SharedPic sharedPic].picList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_picID = %ld",picID];
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
        ((Pic *)copy).picID = self.picID;
        [copy setUrl:self.url];
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        
        
    }
    
    return copy;
}

-(BOOL)editPic:(Pic *)editingPic
{
    if(self.picID == editingPic.picID
       && [self.url isEqualToString:editingPic.url]
       )
    {
        return NO;
    }
    return YES;
}

+(Pic *)copyFrom:(Pic *)fromPic to:(Pic *)toPic
{
    toPic.picID = fromPic.picID;
    toPic.url = fromPic.url;
    toPic.modifiedUser = [Utility modifiedUser];
    toPic.modifiedDate = [Utility currentDateTime];
    
    return toPic;
}
@end
