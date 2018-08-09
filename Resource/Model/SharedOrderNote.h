//
//  SharedOrderNote.h
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/13/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedOrderNote : NSObject
@property (retain, nonatomic) NSMutableArray *orderNoteList;

+ (SharedOrderNote *)sharedOrderNote;
@end
