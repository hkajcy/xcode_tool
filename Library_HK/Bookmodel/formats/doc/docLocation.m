//
//  docLocation.m
//  DocinBookReader
//
//  Created by 黄柯 on 11-11-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "docLocation.h"

@implementation docLocation
@synthesize docIndex;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeFloat:docIndex forKey:@"docIndex"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {  
        
        self.docIndex = [aDecoder decodeFloatForKey:@"docIndex"];
    }  
    
    return self;  
}

+ (id) docLocationWithDocIndex:(float) docIndex
{
    docLocation* tDoc = [[[docLocation alloc] init] autorelease];
    
    tDoc.docIndex = docIndex;
    
    return tDoc;
}
@end
