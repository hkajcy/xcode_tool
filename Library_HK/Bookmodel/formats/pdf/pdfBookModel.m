//
//  pdfBookModel.m
//  DocinBookReader
//
//  Created by mac-L on 11-11-22.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "pdfBookModel.h"
#import "PDFLocation.h"
#import "bookMark.h"
@implementation pdfBookModel

@synthesize bookTitle = _bookTitle;
@synthesize bookId = _bookId;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
- (id)initWithFilePath:(NSString*)filePath PageIndex:(int)pageIndex BookId:(NSUInteger)bookid
{
    assert(filePath != nil);
    self = [super initWithBookID:bookid];
    if (self) {
        // Initialization code here.
        
        self.bookId = bookid;
        _pageIndex = pageIndex;
    }
    return self;  
}

- (BOOL) isMarkedAtPageIndex:(int)pageIndex
{
    NSArray* array = [self bookMarkArray];
    for (NSDictionary* dic in array)
    {
        PDFLocation *loc = [dic objectForKey:_KEY_BOOKMARKLOCATION];
        if (loc.pageIndex == pageIndex) 
        {
             return YES;
             
        }
    }
    return NO;
}

- (void)addBookMarkWithPageIndex:(int)pageIndex
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    NSMutableDictionary* markDic = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
    
    [markDic setValue:[PDFLocation pdfLocationWithIndex:pageIndex] forKey:_KEY_BOOKMARKLOCATION];
    [markDic setValue:@"pdf" forKey:_KEY_BOOKMARKCONTENT];
    
    [self.theBookMark addBookMark:markDic];
    
    [pool release];
    return;
}

- (void)removeBookMarkWithPageIndex:(int)pageIndex
{
    NSArray* array = [self bookMarkArray];
    NSMutableArray* delArray = [[[NSMutableArray alloc] init] autorelease];
    for (NSDictionary* dic in array)
    {
        PDFLocation* loc = [dic objectForKey:_KEY_BOOKMARKLOCATION];
        if (loc.pageIndex == pageIndex)
        {
            [delArray addObject:loc];        }
    }
    
    for (id delObj in delArray) 
    {
        [self.theBookMark delBookMark:delObj];
    }
}

@end
