//
//  Pic.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 19/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pic : NSObject
@property (nonatomic) NSInteger picID;
@property (retain, nonatomic) NSString * url;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;



-(Pic *)initWithUrl:(NSString *)url;
+(NSInteger)getNextID;
+(void)addObject:(Pic *)pic;
+(void)removeObject:(Pic *)pic;
+(void)addList:(NSMutableArray *)picList;
+(void)removeList:(NSMutableArray *)picList;
+(Pic *)getPic:(NSInteger)picID;
-(BOOL)editPic:(Pic *)editingPic;
+(Pic *)copyFrom:(Pic *)fromPic to:(Pic *)toPic;



@end
