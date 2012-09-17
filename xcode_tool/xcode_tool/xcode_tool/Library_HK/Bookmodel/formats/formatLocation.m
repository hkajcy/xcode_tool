//
//  FormatSpineTag.m
//  DocinBookReader
//
//  Created by  on 11-11-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "formatLocation.h"

@implementation formatLocation

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (BOOL) isParagraphEnd
{
    return NO;
}
- (id) preParagraphEndLocation
{
    NSAssert(0,@"");
    return nil;
}
- (id) nextParagraphStartLocation
{
    NSAssert(0,@"");
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {  
        
    }  
    
    return self;  
}

@end
