//
//  SharedNoteType.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 20/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedNoteType : NSObject
@property (retain, nonatomic) NSMutableArray *noteTypeList;

+ (SharedNoteType *)sharedNoteType;
@end
