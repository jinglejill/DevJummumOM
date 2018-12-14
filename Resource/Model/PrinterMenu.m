//
//  PrinterMenu.m
//  DevJummumOM
//
//  Created by Thidaporn Kijkamjai on 7/12/2561 BE.
//  Copyright © 2561 Jummum Tech. All rights reserved.
//

#import "PrinterMenu.h"
#import "SharedPrinterMenu.h"
#import "Utility.h"


@implementation PrinterMenu

- (NSDictionary *)dictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
        [self valueForKey:@"printerMenuID"]?[self valueForKey:@"printerMenuID"]:[NSNull null],@"printerMenuID",
        [self valueForKey:@"printerID"]?[self valueForKey:@"printerID"]:[NSNull null],@"printerID",
        [self valueForKey:@"menuID"]?[self valueForKey:@"menuID"]:[NSNull null],@"menuID",
        [self valueForKey:@"modifiedUser"]?[self valueForKey:@"modifiedUser"]:[NSNull null],@"modifiedUser",
        [Utility dateToString:[self valueForKey:@"modifiedDate"] toFormat:@"yyyy-MM-dd HH:mm:ss"],@"modifiedDate",
        nil];
}

-(PrinterMenu *)initWithPrinterID:(NSInteger)printerID menuID:(NSInteger)menuID
{
    self = [super init];
    if(self)
    {
        self.printerMenuID = [PrinterMenu getNextID];
        self.printerID = printerID;
        self.menuID = menuID;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"printerMenuID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedPrinterMenu sharedPrinterMenu].printerMenuList;


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

+(void)addObject:(PrinterMenu *)printerMenu
{
    NSMutableArray *dataList = [SharedPrinterMenu sharedPrinterMenu].printerMenuList;
    [dataList addObject:printerMenu];
}

+(void)removeObject:(PrinterMenu *)printerMenu
{
    NSMutableArray *dataList = [SharedPrinterMenu sharedPrinterMenu].printerMenuList;
    [dataList removeObject:printerMenu];
}

+(void)addList:(NSMutableArray *)printerMenuList
{
    NSMutableArray *dataList = [SharedPrinterMenu sharedPrinterMenu].printerMenuList;
    [dataList addObjectsFromArray:printerMenuList];
}

+(void)removeList:(NSMutableArray *)printerMenuList
{
    NSMutableArray *dataList = [SharedPrinterMenu sharedPrinterMenu].printerMenuList;
    [dataList removeObjectsInArray:printerMenuList];
}

+(PrinterMenu *)getPrinterMenu:(NSInteger)printerMenuID
{
    NSMutableArray *dataList = [SharedPrinterMenu sharedPrinterMenu].printerMenuList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_printerMenuID = %ld",printerMenuID];
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
        ((PrinterMenu *)copy).printerMenuID = self.printerMenuID;
        ((PrinterMenu *)copy).printerID = self.printerID;
        ((PrinterMenu *)copy).menuID = self.menuID;
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
    }
    
    return copy;
}

-(BOOL)editPrinterMenu:(PrinterMenu *)editingPrinterMenu
{
    if(self.printerMenuID == editingPrinterMenu.printerMenuID
    && self.printerID == editingPrinterMenu.printerID
    && self.menuID == editingPrinterMenu.menuID
    )
    {
        return NO;
    }
    return YES;
}

+(PrinterMenu *)copyFrom:(PrinterMenu *)fromPrinterMenu to:(PrinterMenu *)toPrinterMenu
{
    toPrinterMenu.printerMenuID = fromPrinterMenu.printerMenuID;
    toPrinterMenu.printerID = fromPrinterMenu.printerID;
    toPrinterMenu.menuID = fromPrinterMenu.menuID;
    toPrinterMenu.modifiedUser = [Utility modifiedUser];
    toPrinterMenu.modifiedDate = [Utility currentDateTime];
    
    return toPrinterMenu;
}

+(BOOL)hasMenuID:(NSInteger)menuID inPrinter:(Printer *)printer
{
    NSMutableArray *dataList = [SharedPrinterMenu sharedPrinterMenu].printerMenuList;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_printerID = %ld and _menuID = %ld",printer.printerID, menuID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    return [filterArray count] > 0;
}
@end
