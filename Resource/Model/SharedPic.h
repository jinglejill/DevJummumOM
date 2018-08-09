//
//  SharedPic.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 19/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedPic : NSObject
@property (retain, nonatomic) NSMutableArray *picList;

+ (SharedPic *)sharedPic;
@end
