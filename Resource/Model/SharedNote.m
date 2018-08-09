//
//  SharedNote.m
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 20/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import "SharedNote.h"

@implementation SharedNote
@synthesize noteList;

+(SharedNote *)sharedNote {
    static dispatch_once_t pred;
    static SharedNote *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[SharedNote alloc] init];
        shared.noteList = [[NSMutableArray alloc]init];
    });
    return shared;
}
@end
