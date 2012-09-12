//
//  OEBBookModel.m
//  moonBookReader
//
//  Created by heyong on 11-11-3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "OEBBookModel.h"
#import "OEBTextModel.h"
#import "OEBLocation.h"
#import "OEBSpine.h"
#import "bookConfig.h"
#import "Constants.h"
#import "OEBRow.h"
#import "macros_for_IOS_hk.h"
#import "ZipArchive.h"
#import "OEBDrawer.h"
#import "bookMark.h"
#import "OEBConstant.h"
#import "OEBCSSStyle.h"
#import "book.h"

#define pageIndex_STR   (@"pageIndex")
#define textModel_STR   (@"textModel")
#define pageCount_STR   (@"pageCount")

@interface OEBBookModel ()

@property (assign) BOOL    isBackgroundLoading;
@property (nonatomic, retain) ZipArchive *zipArchive;

@property (nonatomic, retain) OEBLocation* startPlayingLocation;
@property (nonatomic, retain) OEBLocation* stopPlayingLocation;

- (NSString*) chapterTitleWithLocation:(OEBLocation*)location;
@end

@implementation OEBBookModel

@synthesize isBackgroundLoading;
@synthesize startPlayingLocation;
@synthesize stopPlayingLocation;
@synthesize bookTitle;
@synthesize zipArchive;
@synthesize mySpine = _mySpine;

@synthesize pageCountStartFromPageHref;
@synthesize tottlePageCount;
@synthesize startPageIndexArray;

- (id)initWithZipArchive:(ZipArchive *)zipFile
         WithOEBLocation:(OEBLocation*)location
            WithOEBSpine:(OEBSpine*)oebSpine
          withFatherPath:(NSString*)fatherPatht
              withBookID:(int)bookid
{
    self = [super initWithBookID:bookid];
    if (self)
    {
        fatherPath = [fatherPatht copy];
        self.mySpine = oebSpine;
        
        self.zipArchive = zipFile;
        
        textModelDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        textModelIndexDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    
    return self;
}

#pragma mark -
#pragma mark -- get oebTextMode --
- (BOOL) checkDic
{
//    @synchronized (textModelDic)
//    {
//        if ([textModelDic count] > 3)
//        {
//            return FALSE;
//        }
//    }
//    @synchronized (textModelIndexDic)
//    {
//        if ([textModelIndexDic count] > 3)
//        {
//            return FALSE;
//        }
//    }
    
//    int textModelDicCount;
//    int textModelIndexDicCount;
//    @synchronized (textModelDic)
//    {
//        textModelDicCount = [textModelDic count];
//    }
//    @synchronized (textModelIndexDic)
//    {
//        textModelIndexDicCount = [textModelIndexDic count];
//    }
//    if (textModelDicCount != textModelIndexDicCount) 
//    {
//        return FALSE;
//    }
    
    return YES;
}

- (void) minimizeWithTextModel:(OEBTextModel*)textModel
{
    if (textModel == nil)
    {
        return;
    }
    
    NSMutableArray* preTextModelArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    NSMutableArray* nextTextModelArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    OEBLocation* loc = [[[OEBLocation alloc] initWithHref:textModel.fileName] autorelease];
    OEBLocation* preLoc = [_mySpine previousChapter:loc];
    OEBLocation* nextLoc = [_mySpine nextChapter:loc];
    
    //删除pre
    /**************************************************************************************************/
    OEBTextModel* preTextModel;
    @synchronized (textModelDic)
    {
        preTextModel  = [textModelDic objectForKey:preLoc.href];
    }
    
    while (preTextModel)
    {
        [preTextModelArray addObject:preTextModel];
        preLoc = [_mySpine previousChapter:preLoc];
        @synchronized (textModelDic)
        {
            preTextModel  = [textModelDic objectForKey:preLoc.href];
        }
    }
    
    int preCount = 0;
    for (OEBTextModel* t in preTextModelArray)
    {
        preCount = [t pageCount];
    }
    
    if (preCount > 10
        && [preTextModelArray count] > 2)
    {
        @synchronized (textModelDic)
        {
            [textModelDic removeObjectForKey:[[preTextModelArray lastObject] fileName]];
        }
        
        @synchronized (textModelIndexDic)
        {
            [textModelIndexDic removeObjectForKey:[[preTextModelArray lastObject] fileName]];
        }
    }
    /**************************************************************************************************/
    
    //删除next
    /**************************************************************************************************/
    OEBTextModel* nextTextModel;
    @synchronized (textModelDic)
    {
        nextTextModel  = [textModelDic objectForKey:nextLoc.href];
    }
    
    while (nextTextModel)
    {
        [nextTextModelArray addObject:nextTextModel];
        nextLoc = [_mySpine nextChapter:nextLoc];
        @synchronized (textModelDic)
        {
            nextTextModel  = [textModelDic objectForKey:nextLoc.href];
        }
    }
    
    int nextCount = 0;
    for (OEBTextModel* t in nextTextModelArray)
    {
        nextCount = [t pageCount];
    }
    
    if (nextCount > 10
        && [nextTextModelArray count] > 2)
    {
        @synchronized (textModelDic)
        {
            [textModelDic removeObjectForKey:[[nextTextModelArray objectAtIndex:0] fileName]];
        }
        
        @synchronized (textModelIndexDic)
        {
            [textModelIndexDic removeObjectForKey:[[nextTextModelArray objectAtIndex:0] fileName]];
        }
    }
    /**************************************************************************************************/
}

- (int) startPageIndexWithTextModel:(OEBTextModel*)textModel
{
    if (textModel == nil)
    {
        return NSNotFound;
    }
    NSNumber* startIndex ;
    @synchronized (textModelIndexDic)
    {
        startIndex = [textModelIndexDic objectForKey:textModel.fileName];
    }
    
    if (startIndex == nil)
    {
        debugLog(@"%@", textModel.fileName);
        assert(startIndex);
    }
    
    return [startIndex intValue];
}

- (void) resetTextModel:(OEBTextModel*)textModel
{
    textModel.drawOriginalX = self.drawRect.origin.x;
    textModel.drawOriginalY = self.drawRect.origin.y;
    textModel.drawTextWidth = self.drawRect.size.width;
    textModel.drawTextHeight = self.drawRect.size.height;
    textModel.drawViewWidth = self.drawViewSize.width;
    textModel.drawViewHeight = self.drawViewSize.height;
    textModel.sacle = self.drawFont.pointSize / 12;
    textModel.lineSpacing = self.lineSpacing;
    textModel.paragraphSpacing = self.paragraphSpacing;
    textModel.drawColor = self.drawColor;
    textModel.drawFont = self.drawFont;
    
    textModel.bookId = self.bookID;
}

- (OEBTextModel*) textModelFromHref:(NSString*)href
{
    @synchronized (href)
    {
        if (href == nil)
        {
            return nil;
        }
        
        OEBTextModel* textModel;
        @synchronized (textModelDic)
        {
            textModel = [textModelDic objectForKey:href];
        }
        if (!textModel)
        {
            textModel = [[[OEBTextModel alloc] initWithBasePath:fatherPath
                                                   withFileName:href
                                                 withZipArchive:zipArchive ] autorelease];    
            
            [self resetTextModel:textModel];
            [textModel parse];
            //这里应该先释放，后设置
        }
        
        return textModel;
    }
}

- (OEBTextModel*) textModelFromLocation:(OEBLocation*)location
{
    OEBTextModel* textModel = [self textModelFromHref:location.href];
    [self minimizeWithTextModel:textModel];
    
    if (textModel)
    {
        @synchronized (textModelDic)
        {
            [textModelDic setValue:textModel forKey:location.href];
        }
    }

    return textModel;
}


- (OEBTextModel*) textModelFromPageIndex:(int)pageIndex
{
    NSString* tHref ;
    @synchronized (textModelIndexDic)
    {
        tHref = [[textModelIndexDic allKeys] objectAtIndex:0];
    }
    int tStartIndex ;
    @synchronized (textModelIndexDic)
    {
        tStartIndex = [[textModelIndexDic objectForKey:tHref] intValue];
    }
    OEBLocation* tLocation = [[[OEBLocation alloc] init] autorelease];
    tLocation.href = tHref;
    OEBTextModel* textModel;
    @synchronized (textModelDic)
    {
        textModel = [textModelDic objectForKey:tHref];
    }
    NSAssert(textModel,@"");
    
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    if (pageIndex >= tStartIndex && pageIndex < tStartIndex + (int)[textModel pageCount])
    {
        SAFE_RELEASE(pool)
        return textModel;
    }
    else if (pageIndex < tStartIndex)
    {
        while (textModel)
        {
            tLocation = [_mySpine previousChapter:tLocation];//去上一章的location 有可能没有上一章
            @synchronized (textModelDic)
            {
                textModel = [textModelDic objectForKey:tLocation.href];
            }
            
            //在这里判断的目的是为了保存上一次的tStartIndex的值
            if (textModel == nil)
            {
                break;
            }
            @synchronized (textModelIndexDic)
            {
                tStartIndex = [[textModelIndexDic objectForKey:tLocation.href] intValue];
            }
            if (pageIndex >= tStartIndex && pageIndex < tStartIndex + (int)[textModel pageCount])
            {
                SAFE_RELEASE(pool)
                return textModel;
            }
        }
        
        //走到这里 说明这个pageIndex的满足需要创建新的textModel
        if (tLocation == nil)
        {
            SAFE_RELEASE(pool)
            return nil;
        }
        else
        {
            textModel = [self textModelFromLocation:tLocation];
            tStartIndex -= [textModel pageCount];
            @synchronized (textModelIndexDic)
            {
                [textModelIndexDic setValue:[NSNumber numberWithInt:tStartIndex] forKey:tLocation.href];
            }
            
            assert([self checkDic]);
            
            if (pageIndex >= tStartIndex && pageIndex < tStartIndex + (int)[textModel pageCount])
            {
                SAFE_RELEASE(pool)
                return textModel;
            }
            
            //尼玛 我都给你新建立了一个textModel， 都还不满足你的要求， 你自己去好好看看自己的输入有没的问题。比如一下子要我给你几千的index啊。我做不到
            // 有可能出现一章只有一页的情况
            SAFE_RELEASE(pool)
            return [self textModelFromPageIndex:pageIndex];
        }
    }
    else
    {
        while (textModel)
        {
            tLocation = [_mySpine nextChapter:tLocation];
            @synchronized (textModelDic)
            {
                textModel = [textModelDic objectForKey:tLocation.href];
            }
            
            //在这里判断的目的是为了保存上一次的tStartIndex的值
            if (textModel == nil)
            {
                break;
            }
            @synchronized (textModelIndexDic)
            {
                tStartIndex = [[textModelIndexDic objectForKey:tLocation.href] intValue];
            }
            
            if (pageIndex >= tStartIndex && pageIndex < tStartIndex + (int)[textModel pageCount])
            {
                SAFE_RELEASE(pool)
                return textModel;
            }
        }
        
        //走到这里 说明这个pageIndex的满足需要创建新的textModel
        if (tLocation == nil)
        {
            SAFE_RELEASE(pool)
            return nil;
        }
        else
        {
            tStartIndex += [[self textModelFromLocation:[_mySpine previousChapter:tLocation]] pageCount];//先算出本章开始的StartIndex
            textModel = [self textModelFromLocation:tLocation];
            @synchronized (textModelIndexDic)
            {
                [textModelIndexDic setValue:[NSNumber numberWithInt:tStartIndex] forKey:tLocation.href];
            }
            assert([self checkDic]);
            if (pageIndex >= tStartIndex && pageIndex < tStartIndex + (int)[textModel pageCount])
            {
                SAFE_RELEASE(pool)
                return textModel;
            }
            
            //尼玛 我都给你新建立了一个textModel， 都还不满足你的要求， 你自己去好好看看自己的输入有没的问题。比如一下子要我给你几千的index啊。我做不到
            // 有可能出现一章只有一页的情况
            SAFE_RELEASE(pool)
            return [self textModelFromPageIndex:pageIndex];
        }
    }
    SAFE_RELEASE(pool)
}

- (BOOL) checkPageIndexInMemoryWithPageIndex:(int)pageIndex
{
    BOOL ret = NO;
    @synchronized (textModelIndexDic)
    {
        for (NSString* key in [textModelIndexDic allKeys])
        {
            OEBTextModel* tModel;
            @synchronized (textModelDic)
            {
                tModel = [textModelDic objectForKey:key];
            }
            int startIndex = [[textModelIndexDic objectForKey:key] intValue];
            if (pageIndex >= startIndex
                && pageIndex < startIndex + (int)[tModel pageCount])
            {
                ret = YES;
                break;
            }
        }
    }
    return ret;
}

- (BOOL) isFirstPageIndexOfChapter:(int)pageIndex
{
    OEBTextModel* textModel = [self textModelFromPageIndex:pageIndex];
    int pageIndexInTextModel = pageIndex - [self startPageIndexWithTextModel:textModel];
    return pageIndexInTextModel == 0;
}
- (BOOL) isLastPageIndexOfChapter:(int)pageIndex
{
    OEBTextModel* textModel = [self textModelFromPageIndex:pageIndex];
    int pageIndexInTextModel = pageIndex - [self startPageIndexWithTextModel:textModel];
    return [textModel startLocationWithPageIndex:pageIndexInTextModel + 1] == nil;
}

- (BOOL) isValidWithPageIndex:(int)pageIndex
{
    int minStartIndex = LINK_MAX;
    int maxStartIndex = -(LINK_MAX - 1);
    OEBTextModel* minStartTextModel;
    OEBTextModel* maxStartTextModel;
    
    @synchronized (textModelIndexDic)
    {
        for (NSString* key in [textModelIndexDic allKeys])
        {
            int tStartIndex = [[textModelIndexDic objectForKey:key] intValue];
            minStartIndex = MIN(minStartIndex, tStartIndex);
            maxStartIndex = MAX(maxStartIndex, tStartIndex);
            
            if (tStartIndex == minStartIndex)
            {
                @synchronized (textModelIndexDic)
                {
                    minStartTextModel = [textModelDic objectForKey:key];
                }
                assert(minStartTextModel);
            }
            
            if (tStartIndex == maxStartIndex)
            {
                @synchronized (textModelIndexDic)
                {
                    maxStartTextModel = [textModelDic objectForKey:key];
                }
                assert(maxStartTextModel);
            }
        }
    }
    
    NSAssert(minStartIndex != LINK_MAX,@"");
    NSAssert(maxStartIndex != -(LINK_MAX - 1),@"");
    NSAssert(minStartTextModel,@"");
    NSAssert(maxStartTextModel,@"");
    
    if (pageIndex >= minStartIndex 
        && pageIndex < maxStartIndex + (int)[maxStartTextModel pageCount])
    {
        return YES;
    }
    
    if (pageIndex == minStartIndex - 1)
    {
        OEBLocation* loc = [[[OEBLocation alloc] initWithHref:minStartTextModel.fileName] autorelease];
        if ([_mySpine previousChapter:loc])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    if (pageIndex == maxStartIndex + (int)[maxStartTextModel pageCount])
    {
        OEBLocation* loc = [[[OEBLocation alloc] initWithHref:maxStartTextModel.fileName] autorelease];
        if ([_mySpine nextChapter:loc])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    if ([self textModelFromPageIndex:pageIndex])
    {
        return YES;
    }
    return NO;
}



#pragma mark - Book Model Protocol
#pragma mark - getString - 
- (NSString*) strForwardWithLocation:(formatLocation*)location {
    return nil;
}

- (NSString*) strBackwardWithLocation:(formatLocation *)location {
    return nil;
}

- (NSString*) strForwardWithLocation:(formatLocation*)location 
                        limitCharNum:(int)chnum 
{
    assert([location isKindOfClass:[OEBLocation class]]);
    NSString* str = [[self textModelFromLocation:(OEBLocation*)location]
                     strForwardWithLocation:(OEBLocation*)location limitNumber:chnum];
    assert([self checkDic]);
    return str;
}

- (NSString*) strBackwardWithLocation:(formatLocation *)location 
                         limitCharNum:(int)chnum {
    return nil;
}

- (formatLocation*) startLocationOfPageIndex:(int)pageIndex
{
    OEBTextModel* textModel = [self textModelFromPageIndex:pageIndex];
    int pageIndexInTextModel = pageIndex - [self startPageIndexWithTextModel:textModel];
    //[self pageIndexInTextModel:pageIndex WithTextModelPageCount:[textModel pageCount]];
    return [textModel startLocationWithPageIndex:pageIndexInTextModel];
}

- (formatLocation*) stopLocationOfPageIndex:(int)pageIndex 
{
    OEBTextModel* textModel = [self textModelFromPageIndex:pageIndex];
    int pageIndexInTextModel = pageIndex - [self startPageIndexWithTextModel:textModel];
    //[self pageIndexInTextModel:pageIndex WithTextModelPageCount:[textModel pageCount]];
    return [textModel endLocationWithPageIndex:pageIndexInTextModel];
}

- (NSString*) strBetweenLocation:(id)startLocation andLocation:(id)stopLocation
{
    NSAssert([[startLocation href] isEqualToString:[stopLocation href]],@"");
    
    return [[textModelDic objectForKey:[startLocation href]] strBetweenLocation:startLocation andLocation:stopLocation];
}

#pragma mark -
#pragma mark -- get Location --
- (OEBLocation*) locationForwardLocation:(OEBLocation*)location 
                           WithStrLength:(int)strLength
{
    id loc = [[self textModelFromLocation:location] locationForForward:location withLength:strLength];
    assert([self checkDic]);
    return loc;
}

- (OEBLocation*) locationBackwardLocation:(OEBLocation*)location 
                            WithStrLength:(int)strLength
{
    id loc = [[self textModelFromLocation:location] locationForBackward:location withLength:strLength];
    assert([self checkDic]);
    return loc;
}

- (int) strLengthFromLocation:(OEBLocation*)startloc
                   ToLocation:(OEBLocation*)stoploc 
{
    assert([startloc.href isEqualToString:stoploc.href]);
    
    OEBTextModel*   textModel = [self textModelFromLocation:startloc];
    assert([self checkDic]);
    return [textModel stringLengthFromLocation:startloc toLocation:stoploc];
}

- (BOOL) isLocation:(OEBLocation*)startLoc BackwardFromLocation:(OEBLocation*)stopLoc
{
    if([startLoc.href isEqualToString:stopLoc.href])
    {
        if (startLoc.paragraph < stopLoc.paragraph)
        {
            return YES;
        }
        else if (stopLoc.paragraph == startLoc.paragraph && startLoc.postion < stopLoc.postion)
        {
            return YES;
        }
    }
    else
    {
        NSNumber* startNumber = [_mySpine.hrefDic objectForKey:startLoc.href];
        NSNumber* stopNumber = [_mySpine.hrefDic objectForKey:stopLoc.href];
        
        assert(startNumber);
        assert(stopNumber);
        int startIndex = [startNumber intValue];
        int stopIndex = [stopNumber intValue];
        
        if (startIndex < stopIndex)
        {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL) isLocation:(OEBLocation*)startLoc ForwardFromLocation:(OEBLocation*)stopLoc
{
    if([startLoc.href isEqualToString:stopLoc.href])
    {
        if (startLoc.paragraph > stopLoc.paragraph)
        {
            return YES;
        }
        else if (stopLoc.paragraph == startLoc.paragraph && startLoc.postion > stopLoc.postion)
        {
            return YES;
        }  
    }
    else
    {
        int startIndex = [[_mySpine.hrefDic objectForKey:startLoc.href] intValue];
        int stopIndex = [[_mySpine.hrefDic objectForKey:stopLoc.href] intValue];
        
        if (startIndex > stopIndex)
        {
            return YES;
        }
    }
    
    
    return NO;
}

- (BOOL) isLocation:(OEBLocation*)checkLoc
    BetweenLocation:(OEBLocation*)startLoc
        andLocation:(OEBLocation*)stopLoc
{
    if (![checkLoc.href isEqualToString:startLoc.href] 
        || ![checkLoc.href isEqualToString:startLoc.href]) {
        return NO;
    }
    
    if ([self isLocation:startLoc ForwardFromLocation:stopLoc])
    {
        id temp;
        temp = startLoc;
        startLoc = stopLoc;
        stopLoc = temp;
    }
    
    if ([checkLoc isEqualLocation:startLoc])
    {
        return YES;
    }
    else
    {
        if ([self isLocation:checkLoc ForwardFromLocation:startLoc] && [self isLocation:checkLoc BackwardFromLocation:stopLoc])
        {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark -
#pragma mark -- set --
- (void) clearExcept:(OEBTextModel*)textModel
{
    @synchronized (self)
    {
        [[textModel retain] autorelease];
        
        for (OEBTextModel* textModel_ in [textModelDic allValues])
        {   
            if (textModel != textModel_) 
            {
                [OEBLocation clearWithHref:textModel_.fileName];
            }
            
        }
        
        SAFE_RELEASE(textModelDic)
        SAFE_RELEASE(textModelIndexDic)
        textModelDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        textModelIndexDic = [[NSMutableDictionary alloc] initWithCapacity:0];
        if (textModel)
        {
            [textModelDic setValue:textModel forKey:textModel.fileName];
        }
    }
    
}

- (void) setDrawColor:(UIColor *)drawColor
{
    [super setDrawColor:drawColor];
}

- (void) setDrawFont:(UIFont *)drawFont
{
    [super setDrawFont:drawFont];
}

- (void) setLineSpacing:(float)lineSpacing
{
    [super setLineSpacing:lineSpacing];
}

- (void) setParagraphSpacing:(float)paragraphSpacing
{
    [super setParagraphSpacing:paragraphSpacing];
}

- (void) setDrawRect:(CGRect)drawRect
{
    [super setDrawRect:drawRect];
}

- (void) setDrawViewSize:(CGSize)drawViewSize
{
    [super setDrawViewSize:drawViewSize];
}

- (void) resetStartLocation:(OEBLocation*)location 
{
    if (![location isKindOfClass:[OEBLocation class]])
    {
        location = nil;
    }
    
    [textModelIndexDic removeAllObjects];
    
    [[location retain] autorelease];
    OEBTextModel* textModel;
    @synchronized (self)
    {
        
        textModel = [self textModelFromLocation:location];
        [self clearExcept:textModel];
        if (!textModel)
        {            
            if (!location)
            {
                location = (OEBLocation*)[_mySpine firstChapter];
            }
            
            assert(location);
            
            // 设置初始化的pageIndex 开始
            textModel = [self textModelFromLocation:location];
        }
        
        [self resetTextModel:textModel];
        startPageIndex = 0 - [textModel pageIndexWithLocation:location];
        if (startPageIndex == 1 && location != nil)
        {
            //如果出现问题的话， 应该把这个textModel释放掉。
            @synchronized (textModelDic)
            {
                [textModelDic removeObjectForKey:textModel.fileName];
            }
            
            @synchronized (textModelIndexDic)
            {
                [textModelIndexDic removeObjectForKey:textModel.fileName];
            }
            
            [self resetStartLocation:nil];
        }
        else
        {
            @synchronized (textModelIndexDic)
            {
                [textModelIndexDic setValue:[NSNumber numberWithInt:startPageIndex] forKey:textModel.fileName];
                debugLog(@"%@ startPageIndex: %d", textModel.fileName,startPageIndex);
            }
        }
        
        assert(startPageIndex != 1);
        // 设置初始化的pageIndex 结束
    }
}

- (void) setPlayingLocationWithStartLocation:(id)startloc
                                StopLocation:(id)stoploc
{
    self.startPlayingLocation = startloc;
    self.stopPlayingLocation = stoploc;
    return;
}

#pragma mark -
#pragma mark -- bookModel information --
#pragma mark -
#pragma mark -- bookModel information --
- (int) tottalCountWithPageIndex:(int)pageIndex
{
    int chapterCount = [_mySpine.spineArray count];
    OEBTextModel* textModel = [self textModelFromPageIndex:pageIndex];
    int pageCount = [textModel pageCount];
    int tottalCount = chapterCount + pageCount - 1;
    
    return tottalCount;
}

- (int) curChapterIndexWithPageIndex:(int)pageIndex
{
    OEBTextModel* textModel = [self textModelFromPageIndex:pageIndex];
    
    if (textModel == nil)
    {
        return NSNotFound;
    }
    
    int curChapterIndex = -1;
    for (NSDictionary* dic in _mySpine.spineArray)
    {
        if ([textModel.fileName isEqualToString:((OEBLocation*)[dic objectForKey:SpineLocation_STR]).href])
        {
            curChapterIndex = [_mySpine.spineArray indexOfObject:dic];
            break;
        }
    }
    NSAssert(curChapterIndex != -1,@"");
    
    return curChapterIndex;
}

- (float) sliderPercentOfBookWithPageIndex:(int)pageIndex
{
    int tottalCount = [self tottalCountWithPageIndex:pageIndex];
    int curChapterIndex = [self curChapterIndexWithPageIndex:pageIndex];
    OEBTextModel* textModel = [self textModelFromPageIndex:pageIndex];
    OEBLocation* lastLocation = [_mySpine lastChapter];
    int pageIndexInTextModel = (pageIndex - [self startPageIndexWithTextModel:textModel]);
    
    //濡��������椤��规�澶��
    if ([textModel.fileName isEqualToString:lastLocation.href])
    {
        if (pageIndexInTextModel == [textModel pageCount] - 1)
        {
            return 1;
        }
    }
    
    float sliderPercent = (curChapterIndex + pageIndexInTextModel) * 1.0 / tottalCount;
    return sliderPercent;
}

- (float) percentOfBookWithPageIndex:(int)pageIndex
{
    int curChapterIndex = [self curChapterIndexWithPageIndex:pageIndex];
    OEBTextModel* textModel = [self textModelFromPageIndex:pageIndex];
    OEBLocation* lastLocation = [_mySpine lastChapter];
    int pageIndexInTextModel = (pageIndex - [self startPageIndexWithTextModel:textModel]);
    
    //濡��������椤��规�澶��
    if ([textModel.fileName isEqualToString:lastLocation.href])
    {
        if (pageIndexInTextModel == [textModel pageCount] - 1)
        {
            return 1;
        }
    }
    
    float percentInBook ;
    
    if ([_mySpine.spineArray count])
    {
        float oneChapterPercent = 1.0 / [_mySpine.spineArray count];
        int pageIndexInTextModel = (pageIndex - [self startPageIndexWithTextModel:textModel]);
        float percentInChapter = pageIndexInTextModel * 1.0 / [textModel pageCount] * oneChapterPercent;
        float previousPercent = curChapterIndex * 1.0 / [_mySpine.spineArray count];
        percentInBook = previousPercent + percentInChapter;
    }
    else
    {
        percentInBook = 0;
    }
    
    return percentInBook;
}

- (float) percentFromPercent:(float)percent WithPageIndex:(int)pageIndex
{
    OEBTextModel* textModel = [self textModelFromPageIndex:pageIndex];
    int tottalCount = [self tottalCountWithPageIndex:pageIndex];
    
    //杩�����浜�ercent == 1 ��������� 
    if (ABS(percent - 1) < 0.0001)
    {
        return 1;
        
    }
    int tottalIndex = tottalCount * percent;
    int curChapterIndex = [self curChapterIndexWithPageIndex:pageIndex];
    int stopIndex = curChapterIndex + [textModel pageCount];
    
    float percentInBook = 0;
    if (tottalIndex < curChapterIndex)
    {
        if ([_mySpine.spineArray count])
        {
            percentInBook = tottalIndex * 1.0 / [_mySpine.spineArray count];
        }
        
    }
    else if (tottalIndex >= curChapterIndex && tottalIndex < stopIndex)
    {
        if ([_mySpine.spineArray count])
        {
            float oneChapterPercent = 1.0 / [_mySpine.spineArray count];
            int pageIndexInTextModel = (tottalIndex - curChapterIndex);
            float percentInChapter = pageIndexInTextModel * 1.0 / [textModel pageCount] * oneChapterPercent;
            float previousPercent = curChapterIndex * 1.0 / [_mySpine.spineArray count];
            percentInBook = previousPercent + percentInChapter;
        }
    }
    else// tottalIndex >= stopIndex
    {
        int spineIndex = tottalIndex - [textModel pageCount] + 1;
        spineIndex = spineIndex == [_mySpine.spineArray count] ? spineIndex - 1 : spineIndex;
        if ([_mySpine.spineArray count])
        {
            percentInBook = spineIndex * 1.0 / [_mySpine.spineArray count];
        }
    }
    
    return percentInBook;
}

- (id) lastPageLocation
{
    OEBLocation* lastPage = [_mySpine lastChapter];
    OEBTextModel* textModel = [self textModelFromLocation:lastPage];
    OEBLocation* lastLocation = [textModel startLocationWithPageIndex:[textModel pageCount] - 1];
    assert(lastLocation);
    return lastLocation;
}

- (id) locationFromPercent:(float)percent withPageIndex:(int)pageIndex
{
    OEBTextModel* textModel = [self textModelFromPageIndex:pageIndex];
    int tottalCount = [self tottalCountWithPageIndex:pageIndex];
    
    //杩�����浜�ercent == 1 ��������� 
    if (ABS(percent - 1) < 0.0001)
    {
        percent -= 0.0001;
    }
    int tottalIndex = tottalCount * percent;
    int startIndex = [self curChapterIndexWithPageIndex:pageIndex];
    int stopIndex = startIndex + [textModel pageCount];
    
    id location = nil;
    if (tottalIndex < startIndex)
    {
        location = [[_mySpine.spineArray objectAtIndex:tottalIndex] objectForKey:SpineLocation_STR];
    }
    else if (tottalIndex >= startIndex && tottalIndex < stopIndex)
    {
        location = [textModel startLocationWithPageIndex:tottalIndex - startIndex];
    }
    else// tottalIndex >= stopIndex
    {
        int spineIndex = tottalIndex - [textModel pageCount] + 1;
        spineIndex = spineIndex == [_mySpine.spineArray count] ? spineIndex - 1 : spineIndex;
        location = [[_mySpine.spineArray objectAtIndex:spineIndex] objectForKey:SpineLocation_STR];
    }
    
    return location;
}

- (NSMutableArray*) bookSpineArray
{
    return _mySpine.spineArray;
}

- (NSString*) chapterTitleWithLocation:(OEBLocation*)location
{
    NSString* chapterTitle = @"无章节信息";
    
    for (NSDictionary* dic in _mySpine.spineArray)
    {
        if ([location.href isEqualToString:((OEBLocation*)[dic objectForKey:SpineLocation_STR]).href])
        {
            chapterTitle = [dic objectForKey:SpineTittle_STR];
            break;
        }
    }
    return chapterTitle;
}

- (NSString*) pageStrFromTextModel:(OEBTextModel*)textModel withLocatoion:(OEBLocation*)location
{
    NSString* pageStr = nil;
    int tottalPageCount = [textModel pageCount];
    
    for (int i = 0; i<tottalPageCount; i++)
    {
        OEBLocation* tLocation = [textModel startLocationWithPageIndex:i];
        if ([tLocation isEqualLocation:location])
        {
            pageStr = [NSString stringWithFormat:@"位于本章:%d/%d",i+1,tottalPageCount];
            break;
        }
    }
    
    return pageStr;
}


- (NSString*) chapterPageIndexWithLocation:(OEBLocation*)location
                               inPageIndex:(int)pageIndex
{
    assert([self checkPageIndexInMemoryWithPageIndex:pageIndex]);
    OEBTextModel* textModel = [self textModelFromPageIndex:pageIndex];
    if ([textModel.fileName isEqualToString:location.href])
    {
        return [self pageStrFromTextModel:textModel withLocatoion:location];
    }
    else
    {
        return nil;
    }
}

//黄柯

//- (float) percentOfBookWithPageIndex:(int)pageIndex
//{
//    OEBTextModel* textModel = [self textModelFromPageIndex:pageIndex];
//    NSAssert(textModel,@"");
//    
//    int startPageIndexOfTextModel = [[self.pageCountStartFromPageHref objectForKey:textModel.fileName] intValue];
//    int curPageIndexOfTextModel = [[textModelIndexDic objectForKey:textModel.fileName] intValue];
//    
//    int pageIndexInBook = startPageIndexOfTextModel + pageIndex - curPageIndexOfTextModel;//+1是因为从1开始数的
//    
//    if (pageIndexInBook == self.tottlePageCount - 1)
//    {
//        pageIndexInBook = self.tottlePageCount;
//    }
//    
//    return  pageIndexInBook * 1.0 / self.tottlePageCount;
//}

- (int) chapterIndexWithPercent:(float)percent
{
    int spineIndex = 0;
    NSNumber* lastPageIndex = nil;
    int curPageIndex = 0;
    BOOL isCheck = NO;
    if (percent > 1)
    {
        percent = 1;
        spineIndex = [_mySpine.spineArray count] - 1;
    }
    
    else if (percent < 0)
    {
        percent = 0;
    }
    else 
    {
        curPageIndex = tottlePageCount * percent;
        
        for (id sPageIndex in startPageIndexArray)
        {
            if ([sPageIndex intValue] > curPageIndex)
            {
                spineIndex = [startPageIndexArray indexOfObject:lastPageIndex];
                isCheck = YES;
                break;
            }
            lastPageIndex = sPageIndex;
        }
        
        if (!isCheck)
        {
            spineIndex = [_mySpine.spineArray count] - 1;
        }
    }

    return spineIndex;
}

- (NSString*) chapterTitleWithPercent:(float)percent withPageIndex:(int)pageIndex
{
    id loc = [self locationFromPercent:percent withPageIndex:pageIndex];
    return [self chapterTitleWithLocation:loc];
}

- (NSString*) chapterInfoWithPercent:(float)percent withPageIndex:(int)pageIndex
{
    NSAssert([self checkPageIndexInMemoryWithPageIndex:pageIndex],@"");
    OEBLocation* location = [self locationFromPercent:percent withPageIndex:pageIndex];
    OEBTextModel* textModel = [self textModelFromPageIndex:pageIndex];
    
    NSString* pageStr = nil;
    if ([textModel.fileName isEqualToString:location.href])
    {
        pageStr =  [[self pageStrFromTextModel:textModel withLocatoion:location] stringByAppendingString:@"  "];
    }
    else
    {
        pageStr =  @"位于";;
    }
    
    float percentB = [self percentFromPercent:percent WithPageIndex:pageIndex];
    NSString* percentStr = [NSString stringWithFormat:@"全书:%.1f%%",100 * percentB];
    NSString* chapterInfo = [pageStr stringByAppendingString:percentStr];
    
    return chapterInfo;
}
- (NSString*) chapterTitleWithPercent:(float)percent
{
    int spineIndex = [self chapterIndexWithPercent:percent];
    
    OEBLocation* loc = [[_mySpine.spineArray objectAtIndex:spineIndex] objectForKey:SpineLocation_STR];
    
    NSString* chapterTitle = [self chapterTitleWithLocation:loc];
    return chapterTitle;
}

- (NSString*) chapterInfoWithPercent:(float)percent
{
    NSString* chapterPageIndex;
    if (percent >= 1)
    {
        percent = 1;
        chapterPageIndex = [NSString stringWithFormat:@"%d/%d",tottlePageCount,tottlePageCount];
    }
    else if (percent <= 0)
    {
        percent = 0;
        chapterPageIndex = [NSString stringWithFormat:@"1/%d",tottlePageCount];
    }
    else 
    {
        int curPageIndex = (tottlePageCount) * percent + 1;
        chapterPageIndex = [NSString stringWithFormat:@"%d/%d",curPageIndex,tottlePageCount];
    }   
    return chapterPageIndex;
}

- (NSString*) chapterTitleWithPageIndex:(int)pageIndex
{
    NSString* chapterTitle = [self chapterTitleWithLocation:[self startLocationOfPageIndex:pageIndex]];
    return chapterTitle;
}

- (NSString*) chapterInfoWithPageIndex:(int)pageIndex
{
    NSAssert([self checkPageIndexInMemoryWithPageIndex:pageIndex],@"");
    OEBTextModel* textModel = [self textModelFromPageIndex:pageIndex];
    
    int startIndex = [[textModelIndexDic objectForKey:textModel.fileName] intValue];
    
    NSString* pageStr = nil;

    int tottalPageCount = [textModel pageCount];
    
    pageStr = [NSString stringWithFormat:@"位于本章:%d/%d",pageIndex - startIndex +1,tottalPageCount];
    
    pageStr = [pageStr stringByAppendingString:@"  "];
    
    float percentB = [self percentOfBookWithPageIndex:pageIndex];
    
    NSString* percentStr = [NSString stringWithFormat:@"全书:%.1f%%",100 * percentB];
    
    NSString* chapterInfo = [pageStr stringByAppendingString:percentStr];
    
    return chapterInfo;
}
//- (NSString*) chapterInfoWithPageIndex:(int)pageIndex
//{
//    OEBTextModel* textModel = [self textModelFromPageIndex:pageIndex];
//    NSAssert(textModel,@"");
//    
//    int startPageIndexOfTextModel = [[self.pageCountStartFromPageHref objectForKey:textModel.fileName] intValue];
//    int curPageIndexOfTextModel = [[textModelIndexDic objectForKey:textModel.fileName] intValue];
//    
//    int pageIndexInBook = startPageIndexOfTextModel + pageIndex - curPageIndexOfTextModel + 1;//+1是因为从1开始数的
//    
//    return [NSString stringWithFormat:@"%d/%d",pageIndexInBook,tottlePageCount];
//}

- (id) startLocationOfChapterWithPageIndex:(int)pageIndex
{
    id startLocation = nil;
    OEBLocation* location = [self startLocationOfPageIndex:pageIndex];
    for (NSDictionary* dic in _mySpine.spineArray)
    {
        if ([location.href isEqualToString:((OEBLocation*)[dic objectForKey:SpineLocation_STR]).href])
        {
            startLocation = [dic objectForKey:SpineLocation_STR];
            break;
        }
    }
    return startLocation;
}

- (id) locationFromPercent:(float)percent
{
    int curPageIndex = tottlePageCount * percent;
    curPageIndex = MAX(curPageIndex, 0);
    
    int chapterIndex = [self chapterIndexWithPercent:percent];
    OEBLocation* chapterLoc = [[_mySpine.spineArray objectAtIndex:chapterIndex] objectForKey:SpineLocation_STR];
    OEBTextModel* textModel = [self textModelFromLocation:chapterLoc];
    int curChapterStartPageIndex = [[self.pageCountStartFromPageHref objectForKey:chapterLoc.href] intValue];
    
    NSAssert(curPageIndex>=curChapterStartPageIndex,@"");
    NSAssert(curPageIndex-curChapterStartPageIndex<[textModel pageCount],@"");
    int curPageInde = curPageIndex - curChapterStartPageIndex;
    id location = [textModel startLocationWithPageIndex:curPageInde];
    
    return location;
}

- (UIImage *)imageWithPoint:(CGPoint)point withPageIndex:(NSInteger)index {
    OEBTextModel *textModel = [self textModelFromPageIndex:index];
    if (nil == textModel) {
        return nil;
    }
    return [textModel imageWithPoint:point withPageIndex:index - [self startPageIndexWithTextModel:textModel]];
}
#pragma mark -
#pragma mark drawPage

- (void) drawChapterTitleWithPageIndex:(int)pageIndex WithContext:(CGContextRef)context
{
    [[UIColor grayColor] set];
    NSString* chapterTitle = [self chapterTitleWithLocation:[self startLocationOfPageIndex:pageIndex]];
    UIFont* drawFont = [UIFont systemFontOfSize:13];
//    [chapterTitle drawAtPoint:CGPointMake(kReaderTitleOriginalX, kReaderTitleOriginalY) withFont:drawFont];
}

- (void) drawWithPageIndex:(int)pageIndex
         withBookDrawMode:(bookDrawMode)drawMode
          StartPlayingLoc:(id)startPlayingLoc
           StopPlayingLoc:(id)stopPlayingLoc
                inContext:(CGContextRef)context
{
    OEBTextModel* textModel = [[self textModelFromPageIndex:pageIndex] retain];
    
    int relativePageIndex = pageIndex - [self startPageIndexWithTextModel:textModel];
    
    [textModel drawPage:relativePageIndex
               drawMode:drawMode
        StartPlayingLoc:startPlayingLoc
         StopPlayingLoc:stopPlayingLoc
            WithContext:context];
    
    [textModel release];
}
- (void) drawPage:(int)pageIndex
         drawMode:(bookDrawMode)drawMode 
      WithContext:(CGContextRef)context
{
    float viewHeight = self.drawViewSize.height;
    CGContextTranslateCTM(context, 0, viewHeight);
    CGContextScaleCTM(context, 1.0, -1.0); 
    [self drawWithPageIndex:pageIndex
           withBookDrawMode:drawMode
            StartPlayingLoc:self.startPlayingLocation
             StopPlayingLoc:self.stopPlayingLocation
                  inContext:context];
    CGContextScaleCTM(context, 1.0, -1.0); 
    CGContextTranslateCTM(context,0,-viewHeight);
    
    if (drawMode == bookDrawModeNormal)
    {
        self.startPlayingLocation = nil;
        self.stopPlayingLocation = nil;
    }
}
#pragma mark - 
#pragma mark -- BookMark --
- (void) addBookMarkWithPageIndex:(int)pageIndex
{
    OEBTextModel* textModel = [self textModelFromPageIndex:pageIndex];
    OEBLocation* location = [[self textModelFromPageIndex:pageIndex] startLocationWithPageIndex:pageIndex - [self startPageIndexWithTextModel:textModel]];
    assert(location);
    NSString*    content = [[self textModelFromPageIndex:pageIndex] strForwardWithLocation:location limitNumber:30];
    
    NSMutableDictionary* markDic = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
    
    [markDic setValue:location forKey:_KEY_BOOKMARKLOCATION];
    [markDic setValue:content forKey:_KEY_BOOKMARKCONTENT];
    
    [self.theBookMark addBookMark:markDic];
}
- (void) removeBookMarkWithPageIndex:(int)pageIndex
{
    OEBTextModel* textModel = [self textModelFromPageIndex:pageIndex];
    OEBLocation* startLocationt = [[self textModelFromPageIndex:pageIndex] startLocationWithPageIndex:pageIndex - [self startPageIndexWithTextModel:textModel]];
    OEBLocation* stopLocationt = [[self textModelFromPageIndex:pageIndex] endLocationWithPageIndex:pageIndex - [self startPageIndexWithTextModel:textModel]];
    
    NSArray* array = self.theBookMark.markArray;
    NSMutableArray* delArray = [[[NSMutableArray alloc] init] autorelease];
    
    for (NSDictionary* dic in array)
    {
        OEBLocation* checkLocation = [dic objectForKey:_KEY_BOOKMARKLOCATION];
        
        if ([self isLocation:checkLocation BetweenLocation:startLocationt andLocation:stopLocationt])
        {
            [delArray addObject:checkLocation];
        }
    }
    
    for (id delObj in delArray)
    {
        [self.theBookMark delBookMark:delObj];
    }
    
    
}
- (BOOL) isMarkedAtPageIndex:(int)pageIndex
{
    OEBTextModel* textModel = [self textModelFromPageIndex:pageIndex];
    OEBLocation* startLocationt = [[self textModelFromPageIndex:pageIndex] startLocationWithPageIndex:pageIndex - [self startPageIndexWithTextModel:textModel]];
    OEBLocation* stopLocationt = [[self textModelFromPageIndex:pageIndex] endLocationWithPageIndex:pageIndex - [self startPageIndexWithTextModel:textModel]];
    
    NSArray* array = self.theBookMark.markArray;
    
    for (NSDictionary* dic in array)
    {
        OEBLocation* checkLocation = [dic objectForKey:_KEY_BOOKMARKLOCATION];
        
        if ([self isLocation:checkLocation BetweenLocation:startLocationt andLocation:stopLocationt])
        {
            return YES;
        }
    }
    return NO;
}

- (void) clearAllCach
{
    for (id textModel in [textModelDic allValues])
    {
        [textModel clearCach];
        [self resetTextModel:textModel];
    }
}

- (void) parseAll
{
    self.isParsingAll = YES;
    tottlePageCount = 0;
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    self.pageCountStartFromPageHref = [[NSMutableDictionary alloc] init];
    self.startPageIndexArray = [[NSMutableArray alloc] init];
    
    START_TIMER
    for (NSDictionary* dic in _mySpine.spineArray)
    {
        SAFE_RELEASE(pool)
        pool = [[NSAutoreleasePool alloc] init];
        if (self.isStopParse)
        {
            break;
        }
        
        OEBLocation* loc = [dic objectForKey:SpineLocation_STR];
        OEBTextModel* textModel = [[[OEBTextModel alloc] initWithBasePath:fatherPath
                                                            withFileName:loc.href
                                                          withZipArchive:self.zipArchive] autorelease];
        [self resetTextModel:textModel];
        
        
        [pageCountStartFromPageHref setValue:[NSNumber numberWithInt:tottlePageCount] forKey:loc.href];
        [startPageIndexArray addObject:[NSNumber numberWithInt:tottlePageCount]];
        tottlePageCount += [textModel pageCount];
    }
    END_TIMER(@"parseAll")
    
    self.isParsingAll = NO;
    SAFE_RELEASE(pool)
}

- (void)dealloc 
{
    [OEBLocation clear];

    SAFE_RELEASE(zipArchive)
    SAFE_RELEASE(bookTitle)
    SAFE_RELEASE(fatherPath)
    SAFE_RELEASE(_mySpine)
    SAFE_RELEASE(startPlayingLocation)
    SAFE_RELEASE(stopPlayingLocation)
    SAFE_RELEASE(textModelDic)
    SAFE_RELEASE(textModelIndexDic)
    SAFE_RELEASE(pageCountStartFromPageHref)
    SAFE_RELEASE(startPageIndexArray)
    [super dealloc];
}

@end
