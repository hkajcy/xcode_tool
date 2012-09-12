//
//  FormatSpine.m
//  DocinBookReader
//
//  Created by  on 11-11-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "formatSpine.h"
#import "macros_for_IOS_hk.h"
@implementation formatSpine

@synthesize spineArray = _spineArray;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id) initWithSpineArray:(NSMutableArray*)spineArrayt
{
    self = [super init];
    if (self) {
        // Initialization code here.
        self.spineArray = spineArrayt;
    }
    
    return self;
}

- (void)dealloc
{
    SAFE_RELEASE(_spineArray);
    [super dealloc];
}

@end
