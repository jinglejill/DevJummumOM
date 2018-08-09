//
//  MenuPic.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 19/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuPic : NSObject
@property (nonatomic) NSInteger menuPicID;
@property (nonatomic) NSInteger menuID;
@property (nonatomic) NSInteger picID;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;



-(MenuPic *)initWithMenuID:(NSInteger)menuID picID:(NSInteger)picID;
+(NSInteger)getNextID;
+(void)addObject:(MenuPic *)menuPic;
+(void)removeObject:(MenuPic *)menuPic;
+(void)addList:(NSMutableArray *)menuPicList;
+(void)removeList:(NSMutableArray *)menuPicList;
+(MenuPic *)getMenuPic:(NSInteger)menuPicID;
-(BOOL)editMenuPic:(MenuPic *)editingMenuPic;
+(MenuPic *)copyFrom:(MenuPic *)fromMenuPic to:(MenuPic *)toMenuPic;


@end
