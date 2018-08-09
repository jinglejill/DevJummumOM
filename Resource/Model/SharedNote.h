//
//  SharedNote.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 20/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedNote : NSObject
@property (retain, nonatomic) NSMutableArray *noteList;

+ (SharedNote *)sharedNote;
@end
