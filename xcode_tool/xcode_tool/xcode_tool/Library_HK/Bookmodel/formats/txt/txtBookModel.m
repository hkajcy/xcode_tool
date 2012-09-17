//
//  txtBookModel.m
//  UniversalCharDet
//
//  Created by  on 11-8-29.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "txtBookModel.h"
#import "txtBookChapter.h"
#import "txtPageStream.h"
#import "txtStringStream.h"
#import "txtLocation.h"
#import "macros_for_IOS_hk.h"
#import "txtRowStream.h"
#import "bookMark.h"
#import "BookSaveFile.h"
#import "book.h"
#import "txtPageInfo.h"
#import "txtDrawer.h"
#import "macros_for_IOS_hk.h"
#import "NSString ++.h"
@interface txtBookModel () 
- (NSString*) chapterTitleWithLocation:(id)location;

@end

@implementation txtBookModel

@synthesize isPlaying = _isPlaying;
@synthesize myChapterArray;
@synthesize bookTitle;
@synthesize font;
@synthesize dicArray;
@synthesize bookId;

#pragma mark -
#pragma mark init
- (id)initWithFileName:(NSString*)fileName CharactorIndex:(int)index BookId:(NSUInteger)bookid
{
    assert(fileName != nil);
    self = [super initWithBookID:bookid];
    if (self) {
        // Initialization code here.
        
        self.bookId = bookid;
        
        page = [[txtPageStream alloc] initWithFileName:fileName];
        
        //获取骨架 开始
        {
            START_TIMER
        NSMutableArray* spineArray = [BookSaveFile readSpineArray:bookid];
        
        sonOfPage = page.string;
        
        sonOfPage.spineArray = spineArray;
        
        if (!spineArray && sonOfPage.spineArray)
        {
            [BookSaveFile writeSpineArray:sonOfPage.spineArray WithBookId:bookid];
        }
            END_TIMER(@"getSpine")
        }
        
        {
            START_TIMER
            if ([[[fileName pathExtension] uppercaseString] isEqualToString:@"TXT"])
            {
                //获取骨架 结束
                myBookChapter = [[txtBookChapter alloc] init];
                [myBookChapter createChapter:sonOfPage WithBookid:self.bookId];
                self.myChapterArray = myBookChapter.chapterArray;
            }
            END_TIMER(@"createChapter")
        }

        
        rows = 0;
        charactorIndex = index;
        
        [self setCharactorIndex:charactorIndex];
        
    }
    return self;  
}

- (id)init
{
    return nil;
}

- (void)createChapter
{
    [sonOfPage strReset];
    [myBookChapter createChapter:sonOfPage WithBookid:self.bookId];
    [sonOfPage strReset];
    self.myChapterArray = myBookChapter.chapterArray;
}


- (int)tottalCharactor
{
    return     sonOfPage.totalCharacters;
}
- (void)reset
{
    [page pageReset];
}

- (void)setCharactorIndex:(int)chIndex
{
    [self reset];

    [page setCharactor:chIndex];
}

- (void) setDrawFont:(UIFont *)drawFont
{
    [super setDrawFont:drawFont];
    page.drawFont = drawFont;
}

- (void) setDrawColor:(UIColor *)drawColor
{
    [super setDrawColor:drawColor];
    page.drawColor = drawColor;
}

- (void) setLineSpacing:(float)lineSpacing
{
    [super setLineSpacing:lineSpacing];
    page.lineSpacing = lineSpacing;
}

- (void) setParagraphSpacing:(float)paragraphSpacing
{
    [super setParagraphSpacing:paragraphSpacing];
    page.paragraphSpacing = paragraphSpacing;
}

- (void) setDrawRect:(CGRect)drawRect
{
    [super setDrawRect:drawRect];
    
    page.drawOriginalX = drawRect.origin.x;
    page.drawOriginalY = drawRect.origin.y;
    page.drawTextWidth = drawRect.size.width;
    page.drawTextHeight = drawRect.size.height;
}

- (void) setDrawViewSize:(CGSize)drawViewSize
{
    [super setDrawViewSize:drawViewSize];
    
    page.drawViewWidth = drawViewSize.width;
    page.drawViewHeight = drawViewSize.height;
}

#pragma mark -
#pragma mark bookMark

- (BOOL) isMarkedAtPageIndex:(int)pageIndex
{
    NSArray* array = [self bookMarkArray];
    for (NSDictionary* dic in array)
    {
        txtLocation* loc = [dic objectForKey:_KEY_BOOKMARKLOCATION];
        if ([page charactor:loc.charactorIndex InPage:pageIndex] == 0)
        {
            return YES;
        }
    }
    return NO;
}

- (void)addBookMarkWithPageIndex:(int)pageIndex
{

    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    int firstCh = [self firstCharactorIndexOfPage:pageIndex];
    id loc = [txtLocation txtLocationWithIndex:firstCh];
    NSString* title = [page readForwardFromCharactorIndex:firstCh limitCharNum:20];
    NSMutableDictionary* markDic = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
    
    for (int i=0; i<[title length]; i++)
    {
        if([[title substringToIndex:i+1] isEqualToString:@"\n"]
           || [[title substringToIndex:i+1] isEqualToString:@"\r"])
        {
            title = [title substringFromIndex:i+1];
        }
        else
        {
            break;
        }
    }
    
    if (title == nil)
    {
        title = @"";
    }
    
    [markDic setValue:loc forKey:_KEY_BOOKMARKLOCATION];
    [markDic setValue:title forKey:_KEY_BOOKMARKCONTENT];
    
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
        txtLocation* loc = [dic objectForKey:_KEY_BOOKMARKLOCATION];
        if ([page charactor:loc.charactorIndex InPage:pageIndex] == 0)
        {
            [delArray addObject:loc];
        }
    }
    
    for (id delObj in delArray) 
    {
        [self.theBookMark delBookMark:delObj];
    }
}

- (NSMutableArray*) bookSpineArray;
{
    if ([myBookChapter.chapterArray count] == 0)
    {
        [self createChapter];
    }
    
    return self.myChapterArray;
}

- (BOOL) isLastPageIndexOfChapter:(int)pageIndex
{
    return NO;
}

- (BOOL) isFirstPageIndexOfChapter:(int)pageIndex
{
    return NO;
}
- (BOOL) isValidWithPageIndex:(int)pageIndex
{

    return ([[page pageInfoAtIndex:pageIndex] isValide]);

}

#pragma mark -
#pragma mark findLocation
- (int)firstCharactorIndexOfPage:(int)pageIndex
{
    return [page firstCharactorIndexOfPage:pageIndex];
}

- (int)lastCharactorIndexOfPage:(int)pageIndex
{
    return [page lastCharactorIndexOfPage:pageIndex];
}

- (formatLocation*) startLocationOfPageIndex:(int)pageIndex
{
    int startIndex = [self firstCharactorIndexOfPage:pageIndex];
    
    return [txtLocation txtLocationWithIndex:startIndex];
}
- (formatLocation*) stopLocationOfPageIndex:(int)pageIndex
{
    int stopIndex = [self lastCharactorIndexOfPage:pageIndex];
    
    return [txtLocation txtLocationWithIndex:stopIndex];
}

- (id) lastPageLocation
{
    int chIndex = [self tottalCharactor];
    chIndex -= MIN(10,[self tottalCharactor]);
    return [txtLocation txtLocationWithIndex:chIndex];
}

- (formatLocation*) locationForwardLocation:(formatLocation*)location WithStrLength:(int)strLength
{
    if ([location isKindOfClass:[txtLocation class]]) 
    {
        int index = ((txtLocation*)location).charactorIndex + strLength;
        
        return [txtLocation txtLocationWithIndex:index];
    }
    else
    {
        return nil;
    }
}

- (formatLocation*) locationBackwardLocation:(formatLocation*)location WithStrLength:(int)strLength
{
    if ([location isKindOfClass:[txtLocation class]]) 
    {
        int index = ((txtLocation*)location).charactorIndex - strLength;
        
        return [txtLocation txtLocationWithIndex:index];
    }
    else
    {
        return nil;
    }
}

- (id) locationFromPercent:(float)percent withPageIndex:(int)pageIndex
{
    int chIndex = percent * [self tottalCharactor];
    
    if (chIndex == [self tottalCharactor]) 
    {
        chIndex -= MIN(10,[self tottalCharactor]);
    }
    
    NSAssert(chIndex >= 0,nil);
    NSAssert(chIndex <= [self tottalCharactor],nil);
    assert(chIndex >= 0);
    assert(chIndex <= [self tottalCharactor]);
    
    return [txtLocation txtLocationWithIndex:chIndex];
}

- (id) locationInPageIndex:(int)pageIndex WithPoint:(CGPoint)point
{
    int chIndex = [page charactorIndexOfPage:pageIndex WithPoint:point];
    
    if (chIndex != -1)
    {
        return [txtLocation txtLocationWithIndex:chIndex];
    }
    else
    {
        return nil;
    }
}
#pragma mark - 
#pragma mark checkLocation
- (BOOL) isLocation:(txtLocation*)startLoc BackwardFromLocation:(txtLocation*)stopLoc
{
    return startLoc.charactorIndex < stopLoc.charactorIndex;
}

- (BOOL) isLocation:(txtLocation*)startLoc ForwardFromLocation:(txtLocation*)stopLoc
{
    return startLoc.charactorIndex > stopLoc.charactorIndex;
}
- (int) strLengthFromLocation:(formatLocation*)startLocation ToLocation:(formatLocation*)stopLocation
{
    if (!([startLocation isKindOfClass:[txtLocation class]] || [stopLocation isKindOfClass:[txtLocation class]]))
    {
        assert(0);
        return 0;
    }
    
    txtLocation* startTxtLocation = (txtLocation*)startLocation;
    txtLocation* stopTxtLocation = (txtLocation*)stopLocation;
    
    return abs(startTxtLocation.charactorIndex - stopTxtLocation.charactorIndex);
    
}

- (void) setPlayingLocationWithStartLocation:(txtLocation*)startLocation
                                StopLocation:(txtLocation*)stopLocation
{
    startPlayingIndex = startLocation.charactorIndex;
    stopPlayingIndex = stopLocation.charactorIndex;
}

- (void) resetStartLocation:(formatLocation*)location
{
    if (![location isKindOfClass:[txtLocation class]])
    {
        location = nil;
    }
    [self setCharactorIndex:((txtLocation*)location).charactorIndex];
}

- (NSString*) chapterTitleWithPercent:(float)percent withPageIndex:(int)pageIndex
{
    id loc = [self locationFromPercent:percent withPageIndex:pageIndex];
    NSString* chapterTitle = [self chapterTitleWithLocation:loc];
    return chapterTitle;
}

- (NSString*) chapterTitleWithPageIndex:(int)pageIndex
{
    id loc = [self startLocationOfPageIndex:pageIndex];
    return [self chapterTitleWithLocation:loc];
}

- (NSString*) chapterInfoWithPercent:(float)percent withPageIndex:(int)pageIndex
{
    NSString* percentStr = [NSString stringWithFormat:@"位于全书:%.1f%%",100 * percent];
    return percentStr;
}


- (NSString*) chapterInfoWithPageIndex:(int)pageIndex
{
    float percent = [self percentOfBookWithPageIndex:pageIndex];
    NSString* percentStr = [NSString stringWithFormat:@"位于全书:%.1f%%",100 * percent];
    return percentStr;
}

- (int) chapterIndexWithLocation:(id)location
{
    assert([location isKindOfClass:[txtLocation class]]);
    txtLocation* loc = (txtLocation*)location;
    NSArray* chapterArray = myChapterArray;
    
    if ([chapterArray count] == 0)
    {
        return -1;
    }
    
    int checkCharactorIndex = loc.charactorIndex;
    int startIndex = 0;
    int stopIndex = [chapterArray count] - 1;
    int middleIndex = (startIndex + stopIndex) / 2;
    int middleCharactor = ((txtLocation*)[[chapterArray objectAtIndex:middleIndex] objectForKey:SpineLocation_STR]).charactorIndex;
    
    while ((startIndex < stopIndex || stopIndex == 0) && (checkCharactorIndex != middleCharactor))
    {
        if (checkCharactorIndex > middleCharactor)
        {
            startIndex = middleIndex + 1;
            if (startIndex >= [chapterArray count])
            {
                break;
            }
            
            int startCharactor = ((txtLocation*)[[chapterArray objectAtIndex:startIndex] objectForKey:SpineLocation_STR]).charactorIndex;
            if (checkCharactorIndex < startCharactor)
            {
                break;
            }
        }
        
        if (checkCharactorIndex < middleCharactor) 
        {
            stopIndex = middleIndex - 1;
            if (middleIndex <= 0)
            {
                return -1;
            }
            int stopCharactor = ((txtLocation*)[[chapterArray objectAtIndex:stopIndex] objectForKey:SpineLocation_STR]).charactorIndex;
            if (checkCharactorIndex >= stopCharactor)
            {
                middleIndex -= 1;
                break;
            }
        }
        
        middleIndex = (startIndex + stopIndex) / 2;
        
        middleCharactor = ((txtLocation*)[[chapterArray objectAtIndex:middleIndex] objectForKey:SpineLocation_STR]).charactorIndex;
    }
    
#if DEBUG==1 
    if (middleIndex != [chapterArray count] - 1)
    {
        int midCh = ((txtLocation*)[[chapterArray objectAtIndex:middleIndex] objectForKey:SpineLocation_STR]).charactorIndex;
        int midNexCh = ((txtLocation*)[[chapterArray objectAtIndex:middleIndex + 1] objectForKey:SpineLocation_STR]).charactorIndex;
        assert(checkCharactorIndex >= midCh); 
        assert(checkCharactorIndex < midNexCh);
    }
#endif
    return middleIndex;
}

- (id) startLocationOfChapterWithPageIndex:(int)pageIndex
{
    NSArray* chapterArray = self.myChapterArray;
    id location = [self startLocationOfPageIndex:pageIndex];
    int chapterIndex = [self chapterIndexWithLocation:location];
    
    if (chapterIndex == -1)
    {
        return nil;
    }
    assert(chapterIndex <= [chapterArray count] - 1);
    return [[chapterArray objectAtIndex:chapterIndex] objectForKey:SpineLocation_STR];
}
- (NSString*) chapterTitleWithLocation:(id)location
{
    NSArray* chapterArray = self.myChapterArray;
    int chapterIndex = [self chapterIndexWithLocation:location];
    
    if (chapterIndex == -1)
    {
        return bookTitle;
    }
    
    assert(chapterIndex <= [chapterArray count] - 1);
    return [[chapterArray objectAtIndex:chapterIndex] objectForKey:SpineTittle_STR];
}

- (NSString*) chapterIDWithLocation:(id)location
{
    NSArray* chapterArray = self.myChapterArray;
    int chapterIndex = [self chapterIndexWithLocation:location];

    
    if (chapterIndex == -1)
    {
        return @"";
    }
    assert(chapterIndex <= [chapterArray count] - 1);
    
    return [[chapterArray objectAtIndex:chapterIndex] objectForKey:SpineID_STR];
}

- (float) sliderPercentOfBookWithPageIndex:(int)pageIndex
{
    return [self percentOfBookWithPageIndex:pageIndex];
}

- (float) percentOfBookWithPageIndex:(int)pageIndex
{
    float percent = 0;
    {
        //START_TIMER
        int index = [self firstCharactorIndexOfPage:pageIndex];
        percent = index * 1.0 / [self tottalCharactor];
        //END_TIMER(@"firstCharactorIndexOfPage")
    }
    
    
    if (percent > 1)
    {
        percent = 1;
    }
    
    {
        //START_TIMER
        if (![self isValidWithPageIndex:pageIndex+1])
        {
            percent = 1;
        }
        //END_TIMER(@"isValidWithPageIndex")
    }
    
    return percent;
}

#pragma mark - 
#pragma mark getString

- (NSString*) strForwardWithLocation:(formatLocation*)location limitCharNum:(int)chnum
{    
    return [page readForwardFromCharactorIndex:[(txtLocation*)location charactorIndex] limitCharNum:chnum];
}

- (NSString*) strForwardWithLocation:(formatLocation*)location
{
    txtLocation* loc = (txtLocation*)location;
    return [page readForwardFromCharactorIndex:loc.charactorIndex];
}
- (NSString*) strBackwardWithLocation:(formatLocation *)location
{
    txtLocation* loc = (txtLocation*)location;
    return [page readBackwardFromCharactorIndex:loc.charactorIndex];
}

- (NSString*) strBackwardWithLocation:(formatLocation *)location limitCharNum:(int)chnum
{
    txtLocation* loc = (txtLocation*)location;
    return [page readBackwardFromCharactorIndex:loc.charactorIndex limitCharNum:chnum];
}

- (NSString*) strBetweenLocation:(txtLocation*)startLocation andLocation:(txtLocation*)stopLocation
{
    return [page strBetweenLocation:startLocation andLocation:stopLocation];
}
#pragma mark - 
#pragma mark draw
- (void) drawChapterTitleWithPageIndex:(int)pageIndex WithContext:(CGContextRef)context
{
//    [[UIColor grayColor] set];
//    NSString* chapterTitle = [self chapterTitleWithLocation:[self startLocationOfPageIndex:pageIndex]];
//    UIFont* drawFont = [UIFont systemFontOfSize:13];
}

- (void) drawPage:(int)pageIndex drawMode:(bookDrawMode)drawMode WithContext:(CGContextRef)context
{
    @synchronized (self)
    {
        if (drawMode == bookDrawModeNormal)
        {
            startPlayingIndex = NSNotFound;
            stopPlayingIndex = NSNotFound;
        }
        
        float viewHeight = self.drawViewSize.height;
        CGContextTranslateCTM(context, 0, viewHeight);
        CGContextScaleCTM(context, 1.0, -1.0); 
        [txtDrawer drawWithPageInfo:[page pageInfoAtIndex:pageIndex]
                   withBookDrawMode:drawMode
                     StartSpecIndex:startPlayingIndex
                      StopSpecIndex:stopPlayingIndex
                          inContext:context];
        CGContextScaleCTM(context, 1.0, -1.0); 
        CGContextTranslateCTM(context,0,-viewHeight);
    }
}

#pragma mark - 
#pragma mark chose
- (NSArray*) acessArrayWithPoint:(CGPoint)pointA
                        andPoint:(CGPoint)pointB
                      inPageInde:(int)pageIndex
{
    return nil;
}

- (id) sentenceStartLocationWithPoint:(CGPoint)point inPageIndex:(int)pageIndex
{
    txtPageInfo* pageInfo = [page pageInfoAtIndex:pageIndex];
    txtLocation* loc = [pageInfo startLocationWithPoint:point];
    
    NSString* str = [page readBackwardFromCharactorIndex:[loc charactorIndex]];
    int lastSeperatorIndex = [str rFindLastSeperatorIndex];
    
    if (lastSeperatorIndex != -1)
    {
        int length = [str length] - lastSeperatorIndex - 1;
        loc = [txtLocation txtLocationWithIndex:[loc charactorIndex] - length];
    }
    else
    {
        int length = [str length];
        loc = [txtLocation txtLocationWithIndex:[loc charactorIndex] - length];
    }
    
    loc = [pageInfo sentenceStartLocationWithLocation:loc];
    return loc;
}

- (id) sentenceStoptLocationWithPoint:(CGPoint)point inPageIndex:(int)pageIndex
{
    txtPageInfo* pageInfo = [page pageInfoAtIndex:pageIndex];
    txtLocation* loc = [pageInfo stopLocationWithPoint:point];
    
    NSString* str = [page readForwardFromCharactorIndex:[loc charactorIndex]];
    
    int lastSeperatorIndex = [str fingFirstSeperatorIndex];
    int length = 0;
    
    while (lastSeperatorIndex == 0)
    {
        if ([str length] == 0)
        {
            break;
        }
        
        str = [str substringFromIndex:1];
        lastSeperatorIndex = [str fingFirstSeperatorIndex];
        length++;
    }
    
    length += lastSeperatorIndex;
    
    if (lastSeperatorIndex != -1)
    {
        int include = [[str substringWithRange:NSMakeRange(lastSeperatorIndex , 1)] isVisible]?1:0;
        loc = [txtLocation txtLocationWithIndex:[loc charactorIndex] + length + include];
    }
    
    return loc;
}

- (id) startLocationWithPoint:(CGPoint)point inPageIndex:(int)pageIndex
{
    txtPageInfo* pageInfo = [page pageInfoAtIndex:pageIndex];
    return [pageInfo startLocationWithPoint:point];
}

- (id) stopLocationWithPoint:(CGPoint)point inPageIndex:(int)pageIndex
{
    txtPageInfo* pageInfo = [page pageInfoAtIndex:pageIndex];
    return [pageInfo stopLocationWithPoint:point];
}

- (void) clearAllCach
{}
- (void) parseAll
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    SAFE_RELEASE(pool)
}
#pragma mark-
#pragma mark select
- (void) setSelectStartLocation:(id)selectStartLocation
{
    [super setSelectStartLocation:selectStartLocation];
    page.selectStartLocation = selectStartLocation;
}

- (void) setSelectStopLocation:(id)selectStopLocation
{
    [super setSelectStopLocation:selectStopLocation];
    page.selectStopLocation = selectStopLocation;
}

- (void) setIsSelecting:(bool)isSelecting
{
    [super setIsSelecting:isSelecting];
    page.isSelecting = isSelecting;
}

- (id) accessbilityWithPoint:(CGPoint)point inPageIndex:(int)pageIndex
{
    txtPageInfo* pageInfo = [page pageInfoAtIndex:pageIndex];
    return [pageInfo accessbilityWithPoint:point];
}

- (id) startSelectingElementInPageIndex:(int)pageIndex
{
    txtPageInfo* pageInfo = [page pageInfoAtIndex:pageIndex];
    return pageInfo.startSelectingElement;
}

- (id) stopSelectingElementInPageIndex:(int)pageIndex
{
    txtPageInfo* pageInfo = [page pageInfoAtIndex:pageIndex];
    return pageInfo.stopSelectingElement;
}

- (void)dealloc
{
    SAFE_RELEASE(myChapterArray)
    SAFE_RELEASE(myBookChapter)
    SAFE_RELEASE(page)
    SAFE_RELEASE(bookTitle)
    [super dealloc];
}
@end
