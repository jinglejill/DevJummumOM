//
//  FacebookComment.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 26/3/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacebookComment : NSObject
@property (retain, nonatomic) NSString * name;
//@property (retain, nonatomic) NSString * comment;
//@property (retain, nonatomic) NSString * photoPath;
//-(FacebookComment*)initWithName:(NSString *)name comment:(NSString *)comment photoPath:(NSString *)photoPath;
-(FacebookComment*)initWithName:(NSString *)name;
@end
