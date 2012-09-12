//
//  bookMark.m
//  DocinBookReader
//
//  Created by zhao liang on 11-9-14.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "bookMark.h"
#import "txtLocation.h"
#ifdef DOCINSHELF

#import "DocInStudyEngine.h"

#endif

@implementation bookMark

@synthesize bookid;
@synthesize markArray = _markArray;
@synthesize delegate = _delegate;
- (id)initWithID:(int)bookID
{
    self = [super init];
    if (self) {
        // Initialization code here.
        bookid = bookID;
        _markArray = nil;
    }
    
    return self;
}

- (NSMutableArray*) markArray
{
    if (_markArray)
    {
        
    }
    else
    {
        [self getBookMark];
    }
    return _markArray;
}
- (void)addBookMark:(NSMutableDictionary*) markDic
{
    //    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
    //    NSNumber *tmpIndex;
    //    tmpIndex = [NSNumber numberWithInteger:markIndex];
    //    [tmp setValue:tmpIndex forKey:@"markIndex"];
    NSDate *date = [NSDate date];
    [markDic setValue:date forKey:_KEY_BOOKMARKTIME];
    
    BOOL success;
#ifdef DOCINSHELF
    if ([_delegate respondsToSelector:@selector(addBookMarkToWareHouseFrom:WithBookid:WithAccountId:)]) 
    {
        success = [_delegate addBookMarkToWareHouseFrom:markDic WithBookid:self.bookid WithAccountId:[[[DocInStudyEngine sharedInstance]TagandListHttp] accountID]];
    }
#else
    if ([_delegate respondsToSelector:@selector(addBookMarkToWareHouseFrom:WithBookid:)]) 
    {
        success = [_delegate addBookMarkToWareHouseFrom:markDic WithBookid:self.bookid];
    }
#endif
    if(success)
    {
        [_markArray addObject:markDic];
    }
    else
    {
        assert(0);
    }
    //    [tmp release];
}

- (void)delBookMark:(formatLocation*) location;
{
#ifdef DOCINSHELF
    if ([_delegate respondsToSelector:@selector(delBookMarkFromWareHouseFrom:WithBookid:WithAccountId:)])
    {
        [_delegate delBookMarkFromWareHouseFrom:location WithBookid:self.bookid WithAccountId:[[[DocInStudyEngine sharedInstance]TagandListHttp] accountID]];
    }
#else
    if ([_delegate respondsToSelector:@selector(delBookMarkFromWareHouseFrom:WithBookid:)])
    {
        [_delegate delBookMarkFromWareHouseFrom:location WithBookid:self.bookid];
    }
#endif

    
    NSMutableArray* removeArray = [[[NSMutableArray alloc] init] autorelease];
    
    for (NSDictionary* dic in _markArray)
    {
        if (location == [dic objectForKey:_KEY_BOOKMARKLOCATION])
        {
            [removeArray addObject:dic];
            break;
        }
    }
    
    for (id removeObj in removeArray)
    {
        [_markArray removeObject:removeObj];
    }
    
}

- (void)getBookMark
{
    if(_markArray != nil)
    {
        [_markArray release];
    }
#ifdef DOCINSHELF
    if([_delegate respondsToSelector:@selector(getBooKMarkFromWareHouseWithBookid:WithAccountId:)])
    {
        _markArray = [_delegate getBooKMarkFromWareHouseWithBookid:self.bookid WithAccountId:[[[DocInStudyEngine sharedInstance]TagandListHttp] accountID]];
    }
#else
    if([_delegate respondsToSelector:@selector(getBooKMarkFromWareHouseWithBookid:)])
    {
        _markArray = [_delegate getBooKMarkFromWareHouseWithBookid:self.bookid];
    }
#endif
    [_markArray retain];
    
}

- (void)dealloc
{
    
    [_markArray release];
    [super dealloc];
}
@end
