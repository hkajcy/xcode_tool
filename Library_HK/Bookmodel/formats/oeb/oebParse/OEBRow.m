//
//  OEBRow.m
//  OEBReader
//
//  Created by heyong on 11-10-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "OEBRow.h"

#pragma mark - OEBRow
@implementation OEBRow

@synthesize type;
@synthesize rect;
@synthesize paragraph;

- (id)init
{
    self = [super init];
    if (self) {
        type = OEBRowTypeText;
    }
    
    return self;
}

- (void)dealloc {
    [paragraph release];
    [super dealloc];
}

@end

#pragma mark - OEBTextRow
@implementation OEBTextRow

@synthesize textRange;
//@synthesize paragraph;

- (id)init
{
    self = [super init];
    if (self) {
        type = OEBRowTypeText;
    }
    
    return self;
}

- (void)dealloc {
    //[paragraph release];
    [super dealloc];
}

@end

#pragma mark - OEBImageRow
@implementation OEBImageRow

//@synthesize paragraph;

- (id)init
{
    self = [super init];
    if (self) {
        type = OEBRowTypeImage;
    }
    
    return self;
}

- (void)dealloc {
    //[paragraph release];
    [super dealloc];
}

@end

#pragma mark - OEBHyperlinkRow
@implementation OEBHyperlinkRow

- (id)init
{
    self = [super init];
    if (self) {
        type = OEBRowTypeHyperlink;
    }
    
    return self;
}

- (void)dealloc {
    
    [super dealloc];
}

@end