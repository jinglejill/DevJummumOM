//
//  SharedUserAccount.h
//  SaleAndInventoryManagement
//
//  Created by Thidaporn Kijkamjai on 7/30/2558 BE.
//  Copyright (c) 2558 Thidaporn Kijkamjai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedUserAccount : NSObject
@property (retain, nonatomic) NSMutableArray * userAccountList;

+ (SharedUserAccount *)sharedUserAccount;
@end
