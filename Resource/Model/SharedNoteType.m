//
//  SharedNoteType.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 20/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedNoteType.h"

@implementation SharedNoteType
@synthesize noteTypeList;

+(SharedNoteType *)sharedNoteType {
    static dispatch_once_t pred;
    static SharedNoteType *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedNoteType alloc] init];
        shared.noteTypeList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
