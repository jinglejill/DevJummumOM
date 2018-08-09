//
//  SharedUserPromotionUsed.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 20/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedUserPromotionUsed : NSObject
@property (retain, nonatomic) NSMutableArray *userPromotionUsedList;

+ (SharedUserPromotionUsed *)sharedUserPromotionUsed;
@end
