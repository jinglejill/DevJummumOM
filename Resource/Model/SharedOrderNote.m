//
//  SharedOrderNote.m
//  BigHead
//
//  Created by Thidaporn Kijkamjai on 9/13/2560 BE.
//  Copyright © 2560 Appxelent. All rights reserved.
//

#import "SharedOrderNote.h"

@implementation SharedOrderNote
@synthesize orderNoteList;

+(SharedOrderNote *)sharedOrderNote {
    static dispatch_once_t pred;
    static SharedOrderNote *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedOrderNote alloc] init];
        shared.orderNoteList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
