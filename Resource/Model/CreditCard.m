//
//  CreditCard.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 10/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "CreditCard.h"
#import "UserAccount.h"


@implementation CreditCard

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.firstName forKey:@"firstName"];
    [aCoder encodeObject:self.lastName forKey:@"lastName"];
    [aCoder encodeObject:self.creditCardNo forKey:@"creditCardNo"];
    [aCoder encodeObject:[self valueForKey:@"month"] forKey:@"month"];
    [aCoder encodeObject:[self valueForKey:@"year"] forKey:@"year"];
    [aCoder encodeObject:self.ccv forKey:@"ccv"];
    [aCoder encodeObject:[self valueForKey:@"saveCard"] forKey:@"saveCard"];
    [aCoder encodeObject:[self valueForKey:@"primaryCard"] forKey:@"primaryCard"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.firstName = [aDecoder decodeObjectForKey:@"firstName"];
        self.lastName = [aDecoder decodeObjectForKey:@"lastName"];
        self.creditCardNo = [aDecoder decodeObjectForKey:@"creditCardNo"];
        [self setValue:[aDecoder decodeObjectForKey:@"month"] forKey:@"month"];
        [self setValue:[aDecoder decodeObjectForKey:@"year"] forKey:@"year"];
        self.ccv = [aDecoder decodeObjectForKey:@"ccv"];
        [self setValue:[aDecoder decodeObjectForKey:@"saveCard"] forKey:@"saveCard"];
        [self setValue:[aDecoder decodeObjectForKey:@"primaryCard"] forKey:@"primaryCard"];
    }
    return self;
}

+(NSMutableArray *)clearPrimaryCard:(NSMutableArray *)creditCardList
{
    NSMutableArray *newCreditCardList = [[NSMutableArray alloc]init];
    for(NSData *encodedObject in creditCardList)
    {
        CreditCard *creditCard = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
        creditCard.primaryCard = 0;
        

        NSData *newEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:creditCard];
        [newCreditCardList addObject:newEncodedObject];
    }
    return newCreditCardList;
}

+(CreditCard *)getPrimaryCard:(NSMutableArray *)creditCardList
{
    for(NSData *encodedObject in creditCardList)
    {
        CreditCard *creditCard = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
        if(creditCard.primaryCard)
        {
            return creditCard;
        }
    }
    return nil;
    
}

+(BOOL)updatePrimaryCard:(CreditCard *)creditCard creditCardList:(NSMutableArray *)creditCardList
{
    NSInteger exist = 0;
    NSMutableArray *newCreditCardList = [[NSMutableArray alloc]init];
    
    for(NSData *encodedObject in creditCardList)
    {
        CreditCard *item = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
        if([item.firstName isEqualToString:creditCard.firstName] && [item.lastName isEqualToString:creditCard.lastName] && [item.creditCardNo isEqualToString:creditCard.creditCardNo] && (item.month == creditCard.month) && (item.year == creditCard.year) && [item.ccv isEqualToString:creditCard.ccv])
        {
            exist = 1;
            item.primaryCard = 1;
        }
        else
        {
            item.primaryCard = 0;
        }
        
        
        NSData *newEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:item];
        [newCreditCardList addObject:newEncodedObject];
    }
    
    
    
    
    if(!exist)
    {
        creditCard.primaryCard = 1;
        NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:creditCard];
        
        [newCreditCardList addObject:encodedObject];
    }
    
    UserAccount *userAccount = [UserAccount getCurrentUserAccount];
    NSMutableDictionary *dicCreditCard = [[[NSUserDefaults standardUserDefaults] objectForKey:@"creditCard"] mutableCopy];
    if(!dicCreditCard)
    {
        dicCreditCard = [[NSMutableDictionary alloc]init];
    }
    [dicCreditCard setObject:newCreditCardList forKey:userAccount.username];
    [[NSUserDefaults standardUserDefaults] setObject:[dicCreditCard copy] forKey:@"creditCard"];
    
    
    return exist;
}

+(BOOL)clearPrimaryCard:(CreditCard *)creditCard creditCardList:(NSMutableArray *)creditCardList
{
    NSInteger exist = 0;
    NSMutableArray *newCreditCardList = [[NSMutableArray alloc]init];
    
    for(NSData *encodedObject in creditCardList)
    {
        CreditCard *item = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
        if([item.firstName isEqualToString:creditCard.firstName] && [item.lastName isEqualToString:creditCard.lastName] && [item.creditCardNo isEqualToString:creditCard.creditCardNo] && (item.month == creditCard.month) && (item.year == creditCard.year) && [item.ccv isEqualToString:creditCard.ccv])
        {
            exist = 1;
            item.primaryCard = 1;
        }
        else
        {
            item.primaryCard = 0;
        }
        
        
        NSData *newEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:item];
        [newCreditCardList addObject:newEncodedObject];
    }
    
    
    
    
    
    
    UserAccount *userAccount = [UserAccount getCurrentUserAccount];
    NSMutableDictionary *dicCreditCard = [[[NSUserDefaults standardUserDefaults] objectForKey:@"creditCard"] mutableCopy];
    if(!dicCreditCard)
    {
        dicCreditCard = [[NSMutableDictionary alloc]init];
    }
    [dicCreditCard setObject:newCreditCardList forKey:userAccount.username];
    [[NSUserDefaults standardUserDefaults] setObject:[dicCreditCard copy] forKey:@"creditCard"];
    
    
    return exist;
}


-(id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    
    if (copy)
    {
        [copy setFirstName:self.firstName];
        [copy setLastName:self.lastName];
        [copy setCreditCardNo:self.creditCardNo];
        [copy setCcv:self.ccv];
        
        ((CreditCard *)copy).month = self.month;
        ((CreditCard *)copy).year = self.year;
        ((CreditCard *)copy).saveCard = self.saveCard;
        ((CreditCard *)copy).primaryCard = self.primaryCard;
    }
    
    return copy;
}

@end
