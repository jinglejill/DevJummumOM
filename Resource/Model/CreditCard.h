//
//  CreditCard.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 10/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreditCard : NSObject

@property (retain, nonatomic) NSString * firstName;
@property (retain, nonatomic) NSString * lastName;
@property (retain, nonatomic) NSString * creditCardNo;
@property (nonatomic) NSInteger month;
@property (nonatomic) NSInteger year;
@property (retain, nonatomic) NSString * ccv;
@property (nonatomic) NSInteger primaryCard;
@property (nonatomic) NSInteger saveCard;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;


+(NSMutableArray *)clearPrimaryCard:(NSMutableArray *)creditCardList;
+(CreditCard *)getPrimaryCard:(NSMutableArray *)creditCardList;
+(BOOL)updatePrimaryCard:(CreditCard *)creditCard creditCardList:(NSMutableArray *)creditCardList;
+(BOOL)clearPrimaryCard:(CreditCard *)creditCard creditCardList:(NSMutableArray *)creditCardList;
//+(NSMutableArray *)setPrimaryCard:(CreditCard *)creditCard creditCardList:(NSMutableArray *)creditCardList;
@end
