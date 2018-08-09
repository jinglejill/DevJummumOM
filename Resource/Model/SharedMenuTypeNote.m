//
//  SharedMenuTypeNote.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 20/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedMenuTypeNote.h"

@implementation SharedMenuTypeNote
@synthesize menuTypeNoteList;

+(SharedMenuTypeNote *)sharedMenuTypeNote {
    static dispatch_once_t pred;
    static SharedMenuTypeNote *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedMenuTypeNote alloc] init];
        shared.menuTypeNoteList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
