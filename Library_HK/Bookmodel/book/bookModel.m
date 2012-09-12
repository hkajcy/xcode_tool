//
//  bookModel.m
//  docinBookReader
//
//  Created by  on 11-11-1.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "bookModel.h"
#import "bookMark.h"
#import "macros_for_IOS_hk.h"
@implementation bookModel

@synthesize theBookMark;
@synthesize bookWareHouse;

@synthesize drawRect;
@synthesize drawViewSize;

@synthesize drawFont;
@synthesize lineSpacing;
@synthesize paragraphSpacing;
@synthesize drawColor;

@synthesize bookID;

@synthesize isParsingAll;
@synthesize isStopParse;

@synthesize selectStopLocation;
@synthesize selectStartLocation;
@synthesize isSelecting;

- (id)initWithBookID:(int)bookid
{
    self = [super init];
    if (self) 
    {
        // Initialization code here.
        self.bookID = bookid;
        self.theBookMark = [[[bookMark alloc] initWithID:bookid] autorelease];
    }
    
    return self;
}

- (void) setBookWareHouse:(id)bookWareHouse_
{
    theBookMark.delegate = bookWareHouse_;
}

- (NSMutableArray*) bookMarkArray
{
    return theBookMark.markArray;
}

- (id)bookMark
{
    return theBookMark;
}
- (void) stopParsing
{
    self.isStopParse = YES;
    while (self.isParsingAll) 
    {
        sleep(0);
    }
    self.isStopParse = NO;
}

- (void) dealloc
{
    SAFE_RELEASE(theBookMark)
    SAFE_RELEASE(drawColor)
    SAFE_RELEASE(drawFont)
    SAFE_RELEASE(selectStartLocation)
    SAFE_RELEASE(selectStopLocation)
    [super dealloc];
}
@end
