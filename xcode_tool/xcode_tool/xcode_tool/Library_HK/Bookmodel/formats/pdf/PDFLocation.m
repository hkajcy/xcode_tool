//
//  PDFLocation.m
//  DocinBookReader
//
//  Created by mac-L on 11-11-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PDFLocation.h"

@implementation PDFLocation
@synthesize pageIndex;

- (id)init
{
    self = [super init];
    if (self)
    {
        // Initialization code here.
    }
    
    return self;
}

+ (PDFLocation*) pdfLocationWithIndex:(int)index
{
    PDFLocation* pdfLocationt = [[[PDFLocation alloc] init] autorelease];
    pdfLocationt.pageIndex = index;
    
    return pdfLocationt;
}

- (void)encodeWithCoder:(NSCoder *)aCoder 
{  
    [aCoder encodeInt:pageIndex forKey:@"charactorIndex"];
}  

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {  
        
        pageIndex = [aDecoder decodeIntForKey:@"charactorIndex"];
    }  
    
    return self;  
}
@end

