//
//  Printer.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 24/1/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "Printer.h"
#import "SharedPrinter.h"
#import "Utility.h"
#import "MenuType.h"


@implementation Printer

-(Printer *)initWithCode:(NSString *)code name:(NSString *)name menuTypeIDListInText:(NSString *)menuTypeIDListInText model:(NSString *)model portName:(NSString *)portName macAddress:(NSString *)macAddress
{
    self = [super init];
    if(self)
    {
        self.printerID = [Printer getNextID];
        self.code = code;
        self.name = name;
        self.menuTypeIDListInText = menuTypeIDListInText;
        self.model = model;
        self.portName = portName;
        self.macAddress = macAddress;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}

+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"printerID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedPrinter sharedPrinter].printerList;
    
    
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

+(void)addObject:(Printer *)printer
{
    NSMutableArray *dataList = [SharedPrinter sharedPrinter].printerList;
    [dataList addObject:printer];
}

+(void)removeObject:(Printer *)printer
{
    NSMutableArray *dataList = [SharedPrinter sharedPrinter].printerList;
    [dataList removeObject:printer];
}

+(void)addList:(NSMutableArray *)printerList
{
    NSMutableArray *dataList = [SharedPrinter sharedPrinter].printerList;
    [dataList addObjectsFromArray:printerList];
}

+(void)removeList:(NSMutableArray *)printerList
{
    NSMutableArray *dataList = [SharedPrinter sharedPrinter].printerList;
    [dataList removeObjectsInArray:printerList];
}

-(id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        ((Printer *)copy).printerID = self.printerID;
        [copy setCode:self.code];
        [copy setName:self.name];
        [copy setMenuTypeIDListInText:self.menuTypeIDListInText];
        [copy setModel:self.model];
        [copy setPortName:self.portName];
        [copy setMacAddress:self.macAddress];
        [copy setModifiedUser:[Utility modifiedUser]];
        [copy setModifiedDate:[Utility currentDateTime]];
        
        
    }
    
    return copy;
}

+(Printer *)getPrinter:(NSInteger)printerID
{
    NSMutableArray *dataList = [SharedPrinter sharedPrinter].printerList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_printerID = %ld",printerID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(Printer *)getPrinterWithCode:(NSString *)code
{
    NSMutableArray *dataList = [SharedPrinter sharedPrinter].printerList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_code = %@",code];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSMutableArray *)getPrinterList
{
    NSMutableArray *dataList = [SharedPrinter sharedPrinter].printerList;
    return dataList;
}

+(Printer *)getPrinterWithName:(NSString *)name
{
    NSMutableArray *dataList = [SharedPrinter sharedPrinter].printerList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_name = %@",name];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return filterArray[0];
    }
    return nil;
}

+(NSString *)getMenuTypeListInTextWithPrinter:(Printer *)printer
{
    NSString *menuTypeListInText = @"";
    NSArray* menuTypeIDList = [printer.menuTypeIDListInText componentsSeparatedByString: @","];
    int i=0;
    for(NSString *item in menuTypeIDList)
    {
        MenuType *menuType = [MenuType getMenuType:[item integerValue]];
        if(i == 0)
        {
            menuTypeListInText = menuType.name;
        }
        else
        {
            menuTypeListInText = [NSString stringWithFormat:@"%@,%@",menuTypeListInText,menuType.name];
        }
        
        i++;
    }
    return menuTypeListInText;
}

+(NSMutableArray *)getMenuTypeListOtherThanPrinter:(Printer *)printer
{
    NSMutableArray *menuTypeList = [[NSMutableArray alloc]init];
    NSMutableArray *dataList = [SharedPrinter sharedPrinter].printerList;
    for(Printer *item in dataList)
    {
        if(item.printerID != printer.printerID)
        {
            NSArray* menuTypeIDList = [item.menuTypeIDListInText componentsSeparatedByString: @","];
            for(NSString *strMenuTypeID in menuTypeIDList)
            {
                MenuType *menuType = [MenuType getMenuType:[strMenuTypeID integerValue]];
                if(menuType)
                {
                    [menuTypeList addObject:menuType];
                }                
            }
        }
    }
    return menuTypeList;
}

+(NSMutableArray *)getMenuTypeListWithPrinter:(Printer *)printer
{
    NSMutableArray *menuTypeList = [[NSMutableArray alloc]init];
    NSArray* menuTypeIDList = [printer.menuTypeIDListInText componentsSeparatedByString: @","];
    for(NSString *strMenuTypeID in menuTypeIDList)
    {
        MenuType *menuType = [MenuType getMenuType:[strMenuTypeID integerValue]];
        if(menuType)
        {
            [menuTypeList addObject:menuType];
        }
    }
    return menuTypeList;
}
@end
