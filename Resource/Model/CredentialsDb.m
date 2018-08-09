//
//  CredentialsDb.m
//  FFD
//
//  Created by Thidaporn Kijkamjai on 6/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CredentialsDb.h"
#import "SharedCurrentCredentialsDb.h"
#import "Utility.h"


@implementation CredentialsDb

+(NSString *)getNameWithDbName:(NSString *)dbName credentialsDbList:(NSMutableArray *)credentialsDbList
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_dbName = %@",dbName];
    NSArray *filterArray = [credentialsDbList filteredArrayUsingPredicate:predicate];
    if([filterArray count]>0)
    {
        CredentialsDb *credentialsDb = filterArray[0];
        return credentialsDb.name;
    }
    return @"";
}

+(NSInteger)getSelectedIndexWithDbName:(NSString *)dbName credentialsDbList:(NSMutableArray *)credentialsDbList
{
    if(!dbName)
    {
        return 0;
    }
    int i = 0;
    for(CredentialsDb *item in credentialsDbList)
    {
        if([item.dbName isEqualToString:dbName])
        {
            return i;
        }
        i++;
    }
    return i;
}

+(void)setCurrentCredentialsDb:(CredentialsDb *)credentialsDb
{
    [SharedCurrentCredentialsDb sharedCurrentCredentialsDb].credentialsDb = credentialsDb;
}

+(CredentialsDb *)getCurrentCredentialsDb
{
    CredentialsDb *credentialsDb = [SharedCurrentCredentialsDb sharedCurrentCredentialsDb].credentialsDb;
    return credentialsDb;
}
@end
