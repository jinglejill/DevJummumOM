//
//  UserAccount.m
//  SaleAndInventoryManagement
//
//  Created by Thidaporn Kijkamjai on 7/10/2558 BE.
//  Copyright (c) 2558 Thidaporn Kijkamjai. All rights reserved.
//

#import "UserAccount.h"
#import "SharedUserAccount.h"
#import "SharedCurrentUserAccount.h"
#import "Utility.h"


@implementation UserAccount

-(UserAccount *)initWithUsername:(NSString *)username password:(NSString *)password deviceToken:(NSString *)deviceToken fullName:(NSString *)fullName nickName:(NSString *)nickName birthDate:(NSDate *)birthDate email:(NSString *)email phoneNo:(NSString *)phoneNo lineID:(NSString *)lineID roleID:(NSInteger)roleID
{
    self = [super init];
    if(self)
    {
        self.userAccountID = [UserAccount getNextID];
        self.username = username;
        self.password = password;
        self.deviceToken = deviceToken;
        self.fullName = fullName;
        self.nickName = nickName;
        self.birthDate = birthDate;
        self.email = email;
        self.phoneNo = phoneNo;
        self.lineID = lineID;
        self.roleID = roleID;
        self.modifiedUser = [Utility modifiedUser];
        self.modifiedDate = [Utility currentDateTime];
    }
    return self;
}


+(NSInteger)getNextID
{
    NSString *primaryKeyName = @"userAccountID";
    NSString *propertyName = [NSString stringWithFormat:@"_%@",primaryKeyName];
    NSMutableArray *dataList = [SharedUserAccount sharedUserAccount].userAccountList;
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:propertyName ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *sortArray = [dataList sortedArrayUsingDescriptors:sortDescriptors];
    dataList = [sortArray mutableCopy];
    
    if([dataList count] == 0)
    {
        return 1;
    }
    else
    {
        id value = [dataList[0] valueForKey:primaryKeyName];
        NSString *strMaxID = value;
        
        return [strMaxID intValue]+1;
    }
}

+(void)addObject:(UserAccount *)userAccount
{
    NSMutableArray *dataList = [SharedUserAccount sharedUserAccount].userAccountList;
    [dataList addObject:userAccount];
}

+(BOOL) usernameExist:(NSString *)username
{
    UserAccount *userAccount = [UserAccount getUserAccountWithUsername:username];
    if(!userAccount)
    {
        return NO;
    }
    return YES;
}

+(BOOL)isPasswordValidWithUsername:(NSString *)username password:(NSString *)password
{
    NSUInteger fieldHash = [password hash];
    NSString *fieldString = [KeychainWrapper securedSHA256DigestHashForPIN:fieldHash];
    
    
    UserAccount *userAccount = [UserAccount getUserAccountWithUsername:username];
    if([userAccount.password isEqualToString:fieldString])
    {
        return YES;
    }
    return NO;
}

+(UserAccount *)getUserAccount:(NSInteger)userAccountID
{
    NSMutableArray *dataList = [SharedUserAccount sharedUserAccount].userAccountList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_userAccountID = %ld",userAccountID];
    NSArray *filterArray = [dataList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return  filterArray[0];
    }
    return nil;
}

+(UserAccount *)getUserAccountWithUsername:(NSString *)username
{
    NSMutableArray *userAccountList = [SharedUserAccount sharedUserAccount].userAccountList;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_username = %@",username];
    NSArray *filterArray = [userAccountList filteredArrayUsingPredicate:predicate];
    if([filterArray count] > 0)
    {
        return  filterArray[0];
    }
    return nil;
}

+(void)setCurrentUserAccount:(UserAccount *)userAccount
{
    [SharedCurrentUserAccount sharedCurrentUserAccount].userAccount = userAccount;
}

+(UserAccount *)getCurrentUserAccount
{
    return [SharedCurrentUserAccount sharedCurrentUserAccount].userAccount;
}

+(NSString *)getFirstNameWithFullName:(NSString *)fullName
{
    NSArray* component = [fullName componentsSeparatedByString: @" "];
    NSString* firstName = [component objectAtIndex: 0];
    return firstName;
}
@end
