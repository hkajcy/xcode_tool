//
//  txtPageInfo.m
//  docinBookReader
//
//  Created by 黄柯 on 12-3-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "txtPageInfo.h"
#import "txtStringStream.h"
#import "txtRowInfo.h"
#import "macros_for_IOS_hk.h"
#import "Constants.h"
#import "txtLocation.h"
#import "accessibilityElement.h"
#import "NSString ++.h"
@implementation txtPageInfo

@synthesize drawStr;
@synthesize string = _string;
@synthesize startIndex = _startIndex;
@synthesize isValide = _isValide;
@synthesize stopIndex = _stopIndex;
@synthesize startPlayingIndex = _startPlayingIndex;
@synthesize stopPlayingIndex = _stopPlayingIndex;
@synthesize isPlaying = _isPlaying;

@synthesize drawColor = _drawColor;
@synthesize drawOriginalX = _drawOriginalX;
@synthesize drawOriginalY = _drawOriginalY;
@synthesize drawTextWidth = _drawTextWidth;
@synthesize drawTextHeight = _drawTextHeight;
@synthesize drawViewWidth = _drawViewWidth;
@synthesize drawViewHeight = _drawViewHeight;
@synthesize drawFont = _drawFont;
@synthesize lineSpacing = _lineSpacing;
@synthesize paragraphSpacing = _paragraphSpacing;

@synthesize preRowInfoArray;
@synthesize tempRowInfoArray;
@synthesize nextRowInfoArray;

@synthesize preStr;
@synthesize nextStr;

@synthesize selectStopLocation;
@synthesize selectStartLocation;
@synthesize isSelecting;

@synthesize startSelectingElement;
@synthesize stopSelectingElement;

@synthesize didCreateAccessbility;

#pragma mark - 
#pragma mark 计算一页可以画多少字
+ (int) maxLengthInAFrameWithFont:(UIFont*)font_ WithWidth:(int)width_ WithHeight:(int)height_
{
    static UIFont* font = nil;
    static int width = 0;
    static int height = 0;
    static int maxLength = 0;
    
    if ([font.fontName isEqualToString:font_.fontName]
        && font.pointSize == font_.pointSize
        && width == width_
        && height == height_)
    {
    }
    else
    {
        [font release];
        font = [font_ retain];
        width = width_;
        height = height_;
        
        CGFloat iWidth = 0.;
        CGFloat LineHeight = 0.;
        
        // First time here, so use Helvetica 'x' to approximate as described above
        UniChar iChar = 'x';
        CGGlyph iGlyph;
        CTFontRef font_ = CTFontCreateWithName([[font fontName] CFString], [font pointSize], NULL);
        if( CTFontGetGlyphsForCharacters(font_, &iChar, &iGlyph, 1) ) 
        {
            CGRect iBoundRect;
            CTFontGetBoundingRectsForGlyphs(font_, kCTFontHorizontalOrientation, &iGlyph, &iBoundRect, 1);
            iWidth = iBoundRect.size.width;
            CFRelease(font_);
        }
        else
            iWidth = 3.0;	// should have found the glyph width - be conservative and assume something small
        
        LineHeight = CTFontGetAscent(font_) + CTFontGetDescent(font_) + CTFontGetLeading(font_);
        maxLength = (width / iWidth) * (height / LineHeight);//最多能容纳的字符数
    }
    return maxLength;
}

+ (int) maxLengthInALineWithFont:(UIFont*)font_ WithWidth:(int)width_ WithHeight:(int)height_
{
    static UIFont* font = nil;
    static int width = 0;
    static int height = 0;
    static int maxLength = 0;
    
    if ([font.fontName isEqualToString:font_.fontName]
        && font.pointSize == font_.pointSize
        && width == width_
        && height == height_)
    {
        
    }
    else
    {
        [font release];
        font = [font_ retain];
        width = width_;
        height = height_;
        
        CGFloat iWidth = 0.;
        CGFloat LineHeight = 0.;
        
        // First time here, so use Helvetica 'x' to approximate as described above
        UniChar iChar = 'x';
        CGGlyph iGlyph;
        CTFontRef font_ = CTFontCreateWithName([[font fontName] CFString], [font pointSize], NULL);
        if( CTFontGetGlyphsForCharacters(font_, &iChar, &iGlyph, 1) ) 
        {
            CGRect iBoundRect;
            CTFontGetBoundingRectsForGlyphs(font_, kCTFontHorizontalOrientation, &iGlyph, &iBoundRect, 1);
            iWidth = iBoundRect.size.width;
            CFRelease(font_);
        }
        else
            iWidth = 3.0;	// should have found the glyph width - be conservative and assume something small
        
        LineHeight = CTFontGetAscent(font_) + CTFontGetDescent(font_) + CTFontGetLeading(font_);
        maxLength = (width / iWidth);//最多能容纳的字符数
    }
    return maxLength;
}

- (BOOL) isValide
{
    assert(_string);
    if (_isValide == NO)
    {
        if (_startIndex != NSNotFound)
        {
            _isValide = _startIndex < [_string totalCharacters];
        }
        else if (_stopIndex != NSNotFound)
        {
            _isValide = _stopIndex > 0;
        }
    }
    
    return _isValide;
}

- (void) createFrame:(NSAttributedString*)attStr
{
    //创建frame
    /**************************************************************************************************************************/
    frameSetter = AUTO_RELEASED_CTREF(CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attStr));
    
    NSDictionary* frameAttributes = nil;//[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCTFrameProgressionRightToLeft] forKey:(id)kCTFrameProgressionAttributeName];
    
    CGRect drawRect = CGRectMake(_drawOriginalX, _drawViewHeight - _drawOriginalY - _drawTextHeight, _drawTextWidth, 1000 * _drawTextHeight);
    path = AUTO_RELEASED_CTREF(CGPathCreateMutable());
    CGPathAddRect(path, NULL, drawRect);
    
    frame = AUTO_RELEASED_CTREF(CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, (CFDictionaryRef)frameAttributes));
    
    CFRange visibleRange = CTFrameGetVisibleStringRange(frame);
    CFRange range = CTFrameGetStringRange(frame);
    assert(visibleRange.length == range.length);
    /**************************************************************************************************************************/
}

#pragma mark - 
#pragma mark sytheInFrame
- (void) createTempRowInfoArray:(NSAttributedString*)attStr
{
    [self createFrame:attStr];
    
    //创建array
    /**************************************************************************************************************************/
    NSArray* lineRefArray = (NSArray*) CTFrameGetLines(frame);
    
    
    //确定StartIndex
    int stopIndex = self.stopIndex;
    
    int startIndex;
    
    if (self.startIndex != NSNotFound)
    {
        if ([tempRowInfoArray count])
        {
            startIndex = [[tempRowInfoArray lastObject] stopIndex];
        }
        else
        {
            startIndex = self.startIndex;
        }
    }
    else
    {
        if ([tempRowInfoArray count])
        {
            stopIndex = [[tempRowInfoArray objectAtIndex:0] startIndex];
        }
        
        startIndex = stopIndex - [attStr length];
    }
    

    CGFloat drawOriginalY = 0;
    
    CFRange visibleRange = CTFrameGetVisibleStringRange(frame);
    CFRange range = CTFrameGetStringRange(frame);
    assert(visibleRange.length == range.length);
    
    NSMutableArray* tArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease]; // 存储临时的rowInfo
    txtRowInfo* preRowInfo = nil;
    self.preStr = [[[NSMutableAttributedString alloc] init] autorelease];
    
    for (int i=0; i<[lineRefArray count]; i++)
    {
        CTLineRef lineRef = (CTLineRef)[lineRefArray objectAtIndex:i];
        CFRange range = CTLineGetStringRange(lineRef);
        
        CGFloat height;

        height = self.drawFont.pointSize;
        
        NSAttributedString* attStrInRow = [attStr attributedSubstringFromRange:NSMakeRange(range.location, range.length)];
        
        //如果这一行没有数据的话continue
        if (![[attStrInRow string] isVisible])
        {   
            [preStr appendAttributedString:attStrInRow];
            continue;
        }
        
        CGPoint origins;
        CTFrameGetLineOrigins(frame, CFRangeMake(i, 1), &origins);
        
        txtRowInfo* tRowInfo = [[[txtRowInfo alloc] init] autorelease];
        preRowInfo = tRowInfo;
        tRowInfo.drawColor = self.drawColor;
        
        tRowInfo.visibleStartIndex = startIndex;
        if ([preStr length])
        {
            tRowInfo.visibleStartIndex = startIndex + [preStr length];
            [preStr appendAttributedString:attStrInRow];
            attStrInRow = preStr;
            self.preStr = [[[NSMutableAttributedString alloc] initWithString:@""] autorelease];
        }
        
        tRowInfo.drawStr = [[[NSMutableAttributedString alloc] initWithAttributedString:attStrInRow] autorelease];
        
        //这个地方要多取一点，因为本行的排版和下一行的数据有关系
        if (i+1 < [lineRefArray count])
        {
            CTLineRef lineRef = (CTLineRef)[lineRefArray objectAtIndex:i+1];
            CFRange rangeNext = CTLineGetStringRange(lineRef);
            NSAttributedString* nextStrT = [attStr attributedSubstringFromRange:NSMakeRange(range.location+range.length, rangeNext.length)];
            [tRowInfo.drawStr appendAttributedString:nextStrT];
        }
        
        tRowInfo.drawOriginalX = self.drawOriginalX + origins.x;
        tRowInfo.drawOriginalY = self.drawOriginalY + drawOriginalY;
        tRowInfo.drawFont = self.drawFont;
        tRowInfo.drawTextWidth = self.drawTextWidth;
        tRowInfo.drawTextHeight = height;
        tRowInfo.startPlayingIndex = self.startPlayingIndex;
        tRowInfo.stopPlayingIndex = self.stopPlayingIndex;
        tRowInfo.drawViewHeight = self.drawViewHeight;
        tRowInfo.drawTextWidth = self.drawTextWidth;
        tRowInfo.startIndex = startIndex;
        tRowInfo.stopIndex = tRowInfo.startIndex + [attStrInRow length];
        tRowInfo.length = tRowInfo.stopIndex - tRowInfo.startIndex;
        if (origins.x != 0)
        {
            tRowInfo.isIndent = YES;
        }
        
        tRowInfo.isParagraphEnd = [[attStrInRow string] isEndWithBreakEnd];
        [tRowInfo setCTlineRef:lineRef];
        tRowInfo.isSelecting = self.isSelecting;
        
        startIndex = tRowInfo.stopIndex;
        drawOriginalY += height;
        drawOriginalY += self.lineSpacing* (tRowInfo.isParagraphEnd?0:1);
        drawOriginalY += self.paragraphSpacing * (tRowInfo.isParagraphEnd?1:0);
        
        [tArray addObject:tRowInfo];
    }
    /**************************************************************************************************************************/
    
    if ([preStr length] >1)
    {
        [preRowInfo.drawStr appendAttributedString:preStr];
        preRowInfo.stopIndex += [preStr length];
        self.preStr = [[[NSMutableAttributedString alloc] initWithString:@""] autorelease];
    }
    
    //最后一段话，不应重绘，应该作为一段话的结尾
    txtRowInfo* tRowInfo = [tArray lastObject];
    tRowInfo.isParagraphEnd = YES;
    
    //这里因为有可能不是从一段开始取的，所以有可能没有排版良好，暂时没有处理 huangke
    /**************************************************************************************************************************/
    
    if (self.startIndex != NSNotFound)
    {
        if ([tempRowInfoArray count])
        {
            [tempRowInfoArray addObjectsFromArray:tArray];
        }
        else
        {
            tempRowInfoArray = tArray;
        }
        
        if ([tempRowInfoArray count] == 0)
        {
            self.stopIndex = self.startIndex + [attStr length];
        }
    }
    else
    {
        [tArray addObjectsFromArray:tempRowInfoArray];
        tempRowInfoArray = tArray;
        
        if ([tempRowInfoArray count] == 0)
        {
            self.startIndex = self.stopIndex - [attStr length];
        }
    }
}

- (void) sytheInFrameBackwardWithTempRowInfoArray
{
    //确定哪些是我们要的。
    /**************************************************************************************************************************/
    CGFloat drawOriginalY = 0;
    for (int i = [tempRowInfoArray count] - 1; i>=0; i--)
    {
        txtRowInfo* tRowInfo = [tempRowInfoArray objectAtIndex:i];
        drawOriginalY += tRowInfo.drawTextHeight;
        
        if (drawOriginalY > _drawTextHeight)
        {
            int startIndex = 0;
            int stopIndex = [tempRowInfoArray indexOfObject:tRowInfo] + 1;//加一的意思是，这个tRowInfo不应该在这一页内
            NSRange range = NSMakeRange(startIndex, stopIndex - startIndex);
            NSAssert(![preRowInfoArray count],@"");
            [preRowInfoArray addObjectsFromArray:[tempRowInfoArray subarrayWithRange:range]];
            
            NSAssert(![rowInfoArray count],@"");
            NSRange rowArrayRange = NSMakeRange(stopIndex, [tempRowInfoArray count] - stopIndex);
            [rowInfoArray addObjectsFromArray:[tempRowInfoArray subarrayWithRange:rowArrayRange]];
            break;
        }

        drawOriginalY += self.lineSpacing* (tRowInfo.isParagraphEnd?0:1);
        drawOriginalY += self.paragraphSpacing * (tRowInfo.isParagraphEnd?1:0);
        
    }
    /**************************************************************************************************************************/
    
    drawOriginalY = 0;
    //确定每一个row画的位置
    /**************************************************************************************************************************/
    for (txtRowInfo* tRowInfo in rowInfoArray) 
    {
        tRowInfo.drawOriginalY = _drawOriginalY + drawOriginalY;
        drawOriginalY += tRowInfo.drawTextHeight;
        drawOriginalY += self.lineSpacing* (tRowInfo.isParagraphEnd?0:1);
        drawOriginalY += self.paragraphSpacing * (tRowInfo.isParagraphEnd?1:0);
    }
    /**************************************************************************************************************************/
    
    //判断选取的段落是否足够
    /**************************************************************************************************************************/
    if ([preRowInfoArray count] == 0 && _stopIndex > 0)
    {
        int oldStopIndex = _stopIndex;
        self.startIndex = 0;
        [self sythe];
        self.stopIndex = oldStopIndex;
        return;
    }
    /**************************************************************************************************************************/
    
    if ([rowInfoArray count])
    {
        _startIndex = [[rowInfoArray objectAtIndex:0] startIndex];
    }
}

- (void) sytheInFrameBackward:(NSAttributedString*)attStr
{
    [self createTempRowInfoArray:attStr];
    [self sytheInFrameBackwardWithTempRowInfoArray];
}

- (void) sytheInFrameForwardWithTempRowInfoArray
{
    CGFloat drawOriginalY = 0;
    //判断哪些是我们想要的
    /**************************************************************************************************************************/
    /**************************************************************************************************************************/
    
    //判断哪些是我们想要的
    /**************************************************************************************************************************/
    for (txtRowInfo* tRowInfo in tempRowInfoArray)
    {
        drawOriginalY += tRowInfo.drawTextHeight;
        if (drawOriginalY > _drawTextHeight)
        {
            int startIndex = 0;
            int stopIndex = [tempRowInfoArray indexOfObject:tRowInfo];//加一的意思是，这个tRowInfo不应该在这一页内
            
            NSRange rowArrayRange = NSMakeRange(startIndex, stopIndex - startIndex);
            [rowInfoArray addObjectsFromArray:[tempRowInfoArray subarrayWithRange:rowArrayRange]];
            
            NSRange range = NSMakeRange(stopIndex, [tempRowInfoArray count] - stopIndex);
            [nextRowInfoArray addObjectsFromArray:[tempRowInfoArray subarrayWithRange:range]];
            break;
        }
        drawOriginalY += self.lineSpacing* (tRowInfo.isParagraphEnd?0:1);
        drawOriginalY += self.paragraphSpacing * (tRowInfo.isParagraphEnd?1:0);
    }
    /**************************************************************************************************************************/
    
    if ([rowInfoArray count] == 0)
    {
        [rowInfoArray addObjectsFromArray:tempRowInfoArray];
    }
    
    drawOriginalY = 0;
    //确定每一个row画的位置
    /**************************************************************************************************************************/
    for (txtRowInfo* tRowInfo in rowInfoArray) 
    {
        tRowInfo.drawOriginalY = _drawOriginalY + drawOriginalY;
        drawOriginalY += tRowInfo.drawTextHeight;
        drawOriginalY += self.lineSpacing* (tRowInfo.isParagraphEnd?0:1);
        drawOriginalY += self.paragraphSpacing * (tRowInfo.isParagraphEnd?1:0);
    }
    /**************************************************************************************************************************/
    
    if ([rowInfoArray count])
    {
        self.stopIndex = [[rowInfoArray lastObject] stopIndex];
    }
    
    NSAssert(self.stopIndex != NSNotFound,@"");
    NSAssert(self.stopIndex >= self.startIndex,@"");
    
    //因为最后一行不是排版良好的。。 所以要丢弃掉.
    if ([nextRowInfoArray count])
    {
        [nextRowInfoArray removeObjectAtIndex:[nextRowInfoArray count]-1];
    }
}

- (void) sytheInFrameForward:(NSMutableAttributedString*)attStr
{
    [self createTempRowInfoArray:attStr];
    [self sytheInFrameForwardWithTempRowInfoArray];
}

- (BOOL) checkIfNeedReadBackward
{
    CGFloat drawOriginalY = 0;
    for (int i = [tempRowInfoArray count] - 1; i>=0; i--)
    {
        txtRowInfo* tRowInfo = [tempRowInfoArray objectAtIndex:i];
        CGFloat height = tRowInfo.drawTextHeight;
        
        drawOriginalY += height;
        drawOriginalY += self.lineSpacing* (tRowInfo.isParagraphEnd?0:1);
        drawOriginalY += self.paragraphSpacing * (tRowInfo.isParagraphEnd?1:0);
        
        if (drawOriginalY >= self.drawTextHeight)
        {
            return NO;
        }
    }
    return YES;
}

- (BOOL) checkIfNeedReadForward
{
    CGFloat drawOriginalY = 0;
    for (txtRowInfo* tRowInfo in tempRowInfoArray)
    {
        CGFloat height = tRowInfo.drawTextHeight;
        
        drawOriginalY += height;
        drawOriginalY += self.lineSpacing* (tRowInfo.isParagraphEnd?0:1);
        drawOriginalY += self.paragraphSpacing * (tRowInfo.isParagraphEnd?1:0);
        
        if (drawOriginalY >= self.drawTextHeight)
        {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL) checkIfNeedReadMore
{
    if(self.startIndex != NSNotFound)
    {
        return [self checkIfNeedReadForward];
    }
    else
    {
        return [self checkIfNeedReadBackward];
    }
}

- (NSMutableAttributedString*) createrAttr:(NSString*)str
{
    NSMutableString* newStr = [NSMutableString stringWithString:str];
    BOOL firstLineNeedIndent= NO;
    firstLineNeedIndent = [txtRowInfo removeIndentWithString:newStr];
    NSMutableAttributedString* attStr = [[[NSMutableAttributedString alloc] initWithString:newStr] autorelease];
    
    //设置颜色 开始
    /**************************************************************************************************************************/
    [attStr addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)self.drawColor.CGColor range:NSMakeRange(0,[attStr length])];
    NSRange playRange = NSMakeRange(_startPlayingIndex, _stopPlayingIndex - _startPlayingIndex);
    if (NSLocationInRange(_startIndex,playRange) 
        || NSLocationInRange(_startIndex + [drawStr length], playRange)
        || NSLocationInRange(_startPlayingIndex, NSMakeRange(_startIndex, [drawStr length]))
        
        )
    {
        self.isPlaying = YES;
        CGColorRef color = [UIColor redColor].CGColor;
        int start = _startPlayingIndex - _startIndex < 0 ? 0 : _startPlayingIndex - _startIndex;
        int stop =  _stopPlayingIndex - _startIndex - (int)[drawStr length]< 0 ? (_stopPlayingIndex - _startIndex) : [drawStr length];
        
        [attStr addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)color range:NSMakeRange(start,stop - start)];
    }
    /**************************************************************************************************************************/
    
    
    //设置字体 开始
    /**************************************************************************************************************************/
    CFStringRef fontName = AUTO_RELEASED_CTREF(CFStringCreateWithCString(NULL,
                                                                         [[_drawFont fontName] cStringUsingEncoding:NSUTF8StringEncoding], 
                                                                         kCFStringEncodingUTF8));
    
    CTFontRef fontRef = AUTO_RELEASED_CTREF(CTFontCreateWithName(fontName,_drawFont.pointSize , NULL));
    [attStr addAttribute:(NSString*)kCTFontAttributeName value:(id)fontRef range:NSMakeRange(0, [attStr length])];
    /**************************************************************************************************************************/
    
    
    //设置段落属性
    /**************************************************************************************************************************/
    int ParagraphStylesSupported = 10;
    CTParagraphStyleSetting settings[ParagraphStylesSupported];
    CTTextAlignment alignment;
    CGFloat floatValues[ParagraphStylesSupported];
    
    int settingsIndex = 0;
    settings[settingsIndex].spec =     kCTParagraphStyleSpecifierFirstLineHeadIndent;settingsIndex++;
    settings[settingsIndex].spec =     kCTParagraphStyleSpecifierHeadIndent;settingsIndex++;
    settings[settingsIndex].spec =     kCTParagraphStyleSpecifierTailIndent;settingsIndex++;
    settings[settingsIndex].spec =     kCTParagraphStyleSpecifierDefaultTabInterval;settingsIndex++;
    settings[settingsIndex].spec =     kCTParagraphStyleSpecifierLineSpacingAdjustment;settingsIndex++;
    settings[settingsIndex].spec =     kCTParagraphStyleSpecifierParagraphSpacing;settingsIndex++;
    settings[settingsIndex].spec =     kCTParagraphStyleSpecifierParagraphSpacingBefore;settingsIndex++;
    settings[settingsIndex].spec =     kCTParagraphStyleSpecifierLineBreakMode;settingsIndex++;
    
    CGFloat value[] = 
    {   
        self.drawFont.pointSize * 2 , //kCTParagraphStyleSpecifierFirstLineHeadIndent;
        0 , //kCTParagraphStyleSpecifierHeadIndent;
        0 , //kCTParagraphStyleSpecifierTailIndent;
        0 , //kCTParagraphStyleSpecifierDefaultTabInterval;
        0 , //kCTParagraphStyleSpecifierLineSpacingAdjustment;
        0 , //kCTParagraphStyleSpecifierParagraphSpacing;
        0 , //kCTParagraphStyleSpecifierParagraphSpacingBefore;
        0 , //kCTParagraphStyleSpecifierLineBreakMode
        /*
        kCTLineBreakByWordWrapping = 0,
        kCTLineBreakByCharWrapping = 1,
        kCTLineBreakByClipping = 2,
        kCTLineBreakByTruncatingHead = 3,
        kCTLineBreakByTruncatingTail = 4,
        kCTLineBreakByTruncatingMiddle = 5
         */
    };
    
    NSUInteger styleIndex;
    for (styleIndex=0; styleIndex<settingsIndex; styleIndex++) {
        settings[styleIndex].valueSize = sizeof(CGFloat);
        floatValues[styleIndex] = value[styleIndex];
        settings[styleIndex].value = &floatValues[styleIndex];
    }
    
    settings[settingsIndex].spec = kCTParagraphStyleSpecifierAlignment;
    settings[settingsIndex].valueSize = sizeof(CTTextAlignment);
    alignment = kCTJustifiedTextAlignment;
    settings[settingsIndex].value = &alignment;
    settingsIndex++;
    
    CTParagraphStyleRef style = AUTO_RELEASED_CTREF(CTParagraphStyleCreate((const CTParagraphStyleSetting*) &settings, settingsIndex));
    [attStr addAttribute:(NSString*)kCTParagraphStyleAttributeName value:(id)style range:NSMakeRange(0, [attStr length])];
    
    if (!firstLineNeedIndent)
    {
        int ParagraphStylesSupported = 10;
        CTParagraphStyleSetting settings[ParagraphStylesSupported];
        CTTextAlignment alignment;
        CGFloat floatValues[ParagraphStylesSupported];
        
        int settingsIndex = 0;
        settings[settingsIndex].spec =     kCTParagraphStyleSpecifierFirstLineHeadIndent;settingsIndex++;
        settings[settingsIndex].spec =     kCTParagraphStyleSpecifierHeadIndent;settingsIndex++;
        settings[settingsIndex].spec =     kCTParagraphStyleSpecifierTailIndent;settingsIndex++;
        settings[settingsIndex].spec =     kCTParagraphStyleSpecifierDefaultTabInterval;settingsIndex++;
        settings[settingsIndex].spec =     kCTParagraphStyleSpecifierLineSpacingAdjustment;settingsIndex++;
        settings[settingsIndex].spec =     kCTParagraphStyleSpecifierParagraphSpacing;settingsIndex++;
        settings[settingsIndex].spec =     kCTParagraphStyleSpecifierParagraphSpacingBefore;settingsIndex++;
        settings[settingsIndex].spec =     kCTParagraphStyleSpecifierLineBreakMode;settingsIndex++;
        
        CGFloat value[] = 
        {   
            0 , //kCTParagraphStyleSpecifierFirstLineHeadIndent;
            0 , //kCTParagraphStyleSpecifierHeadIndent;
            0 , //kCTParagraphStyleSpecifierTailIndent;
            0 , //kCTParagraphStyleSpecifierDefaultTabInterval;
            0 , //kCTParagraphStyleSpecifierLineSpacingAdjustment;
            0 , //kCTParagraphStyleSpecifierParagraphSpacing;
            0 , //kCTParagraphStyleSpecifierParagraphSpacingBefore;
            0 , //kCTParagraphStyleSpecifierLineBreakMode
            /*
             kCTLineBreakByWordWrapping = 0,
             kCTLineBreakByCharWrapping = 1,
             kCTLineBreakByClipping = 2,
             kCTLineBreakByTruncatingHead = 3,
             kCTLineBreakByTruncatingTail = 4,
             kCTLineBreakByTruncatingMiddle = 5
             */
        };
        
        NSUInteger styleIndex;
        for (styleIndex=0; styleIndex<settingsIndex; styleIndex++) {
            settings[styleIndex].valueSize = sizeof(CGFloat);
            floatValues[styleIndex] = value[styleIndex];
            settings[styleIndex].value = &floatValues[styleIndex];
        }
        
        settings[settingsIndex].spec = kCTParagraphStyleSpecifierAlignment;
        settings[settingsIndex].valueSize = sizeof(CTTextAlignment);
        alignment = kCTJustifiedTextAlignment;
        settings[settingsIndex].value = &alignment;
        settingsIndex++;
        
        CTParagraphStyleRef style = AUTO_RELEASED_CTREF(CTParagraphStyleCreate((const CTParagraphStyleSetting*) &settings, settingsIndex));
        [attStr addAttribute:(NSString*)kCTParagraphStyleAttributeName value:(id)style range:NSMakeRange(0, 1)];
    }
    /**************************************************************************************************************************/
    
    return attStr;
}

- (void) createAccessbility
{
    if (!didCreateAccessbility)
    {
        for (txtRowInfo* tRowInfo in rowInfoArray)
        {
            [tRowInfo createAccessbility];
        }
        
        self.didCreateAccessbility = YES;
    }
}

- (void) sytheInFrame
{
    //初始化
    /**************************************************************************************************************************/
    SAFE_RELEASE(rowInfoArray)
    SAFE_RELEASE(preRowInfoArray)
    SAFE_RELEASE(nextRowInfoArray)
    rowInfoArray = [[NSMutableArray alloc] initWithCapacity:0];
    preRowInfoArray = [[NSMutableArray alloc] initWithCapacity:0];
    nextRowInfoArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.didCreateAccessbility = NO;
    /**************************************************************************************************************************/
    
    if ([self checkIfNeedReadMore])
    {
        //读取字符串
        /**************************************************************************************************************************/
        int _maxLengthInAFrame = 2 * [txtPageInfo maxLengthInAFrameWithFont:_drawFont WithWidth:_drawTextWidth WithHeight:_drawTextHeight];
        
        if(self.startIndex != NSNotFound)
        {
            int startIndex = self.startIndex;
            
            if ([tempRowInfoArray count])
            {
                txtRowInfo* tRowInfo = [tempRowInfoArray lastObject];
                startIndex = tRowInfo.stopIndex;
            }
            
            self.drawStr = [self.string readForwardFromCharactorIndex:startIndex limitCharNum:_maxLengthInAFrame];
        }
        else
        {
            int startIndex = self.stopIndex;
            
            if ([tempRowInfoArray count])
            {
                txtRowInfo* tRowInfo = [tempRowInfoArray objectAtIndex:0];
                startIndex = tRowInfo.startIndex;
            }
            
            self.drawStr = [self.string readBackwardFromCharactorIndex:startIndex limitCharNum:_maxLengthInAFrame];
        }
        /**************************************************************************************************************************/
        
        if (drawStr && [drawStr length])
        {
            NSMutableAttributedString* attStr = [self createrAttr:drawStr];
            if (self.startIndex == NSNotFound)
            {
                [self sytheInFrameBackward:attStr];
            }
            else
            {
                [self sytheInFrameForward:attStr];
            }
        }
        else
        {
            if(self.startIndex == NSNotFound
               && self.stopIndex != NSNotFound)
            {
                [self sytheInFrameBackwardWithTempRowInfoArray];
            }
        }
    }
    else
    {
        if(self.startIndex == NSNotFound)
        {
            [self sytheInFrameBackwardWithTempRowInfoArray];
        }
        else
        {
            [self sytheInFrameForwardWithTempRowInfoArray];
        }
    }
    
    NSAssert(_stopIndex > _startIndex || _stopIndex == NSNotFound || _startIndex == NSNotFound, @"");
    
    self.drawStr = [_string readForwardFromCharactorIndex:self.startIndex limitCharNum:(self.stopIndex - self.startIndex) * 2];
    self.tempRowInfoArray = nil;
}

- (void) sythe
{
    {
        //START_TIMER
        [self sytheInFrame];
        //END_TIMER(@"sytheInFrame")
    }
    
    debugLog(@"startIndex = %d", _startIndex);
    debugLog(@"stopIndex = %d", _stopIndex);
}

#pragma mark - 
#pragma mark drawPage
- (void) reCreateWithStartSpecIndex:(int)startSpecIndex
                  withStopSpecIndex:(int)stopSpecIndex
{
    if (self.startPlayingIndex != startSpecIndex
        || self.stopPlayingIndex != stopSpecIndex)
    {
        self.startPlayingIndex = startSpecIndex;
        self.stopPlayingIndex = stopSpecIndex;
        for (txtRowInfo* tRowInfo in rowInfoArray)
        {
            [tRowInfo reCreateWithStartSpecIndex:startSpecIndex
                               withStopSpecIndex:stopSpecIndex];
        }
    }
    
}

- (void) drawPageInContext:(CGContextRef)context
{
    CGContextSaveGState(context);
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    for (txtRowInfo* rowInfo in rowInfoArray) 
    {
        [rowInfo drawInContext:context];
    }
    CGContextRestoreGState(context);
}

- (void) drawPageInContext:(CGContextRef)context
              bookDrawMode:(bookDrawMode)drawMode
         StartPlayingIndex:(int)startPlayingIndex
          StopPlayingIndex:(int)stopPlayingIndex;

{
    txtPageInfo* pageInfo = self;
    [pageInfo reCreateWithStartSpecIndex:startPlayingIndex
                       withStopSpecIndex:stopPlayingIndex];
    //START_TIMER;
    [self drawPageInContext:context];
    //END_TIMER(@"drawPageInContext");
}

- (void) setDrawColor:(UIColor *)drawColor
{
    if (![self.drawColor isEqual:drawColor])
    {
        [_drawColor release];
        _drawColor = [drawColor retain];
        
        for (txtRowInfo* rowInfo in rowInfoArray)
        {
            rowInfo.drawColor = drawColor;
        }
    }
}

- (int ) chIndexWithPoint:(CGPoint)point
{
    int chIndex = -1;
    txtRowInfo* preRowInfo = nil;
    for (txtRowInfo* tRowInfo in rowInfoArray)
    {
        if (preRowInfo == nil)
        {
            preRowInfo = tRowInfo;
        }
        
        if ([tRowInfo isPointInTheRow:point])
        {
            chIndex = [tRowInfo chIndexWithPoint:point];
            break;
        }
        
        if (preRowInfo.drawOriginalY < point.y && tRowInfo.drawOriginalY > point.y)
        {
            chIndex = tRowInfo.startIndex;
        }
        preRowInfo = tRowInfo;
    }
    
    if (chIndex == -1)
    {
        txtRowInfo* tRowInfo = [rowInfoArray objectAtIndex:0];
        if (tRowInfo.drawOriginalY > point.y)
        {
            chIndex = tRowInfo.startIndex;
        }
        
        tRowInfo = [rowInfoArray lastObject];
        if (tRowInfo.drawOriginalY < point.y)
        {
            chIndex = tRowInfo.stopIndex;
        }
        
    }
    return chIndex;
}

#pragma mark - 
#pragma mark pointWithChindex
- (id) sentenceStartLocationWithPoint:(CGPoint)point
{
    id loc = nil;
    CGRect preRect = CGRectZero;
    CGRect curRect = CGRectZero;
    id preRowInfo = nil;
    for (txtRowInfo* tRowInfo in rowInfoArray)
    {
        curRect = tRowInfo.contentRect;
        
        //point 正好处于这个row内
        if (point.y >= curRect.origin.y 
            && point.y <= curRect.origin.y + curRect.size.height)
        {
            loc = [txtLocation txtLocationWithIndex:[tRowInfo chIndexWithPoint:point]];
            break;
        }
        else if (point.y > preRect.origin.y + preRect.size.height
                 && point.y < curRect.origin.y)//point between double row。 我们认为这个point是想要选择下一个row
        {
            loc = [txtLocation txtLocationWithIndex:[tRowInfo chIndexWithPoint:point]];
            break;
        }
        
        preRect = curRect;
        preRowInfo = tRowInfo;
    }
    
    //如果选择了屏幕的最下方的话，这个loc 应该为nil。 
    //认为他是想选择最后一行
    if (loc == nil)
    {
        loc = [txtLocation txtLocationWithIndex:[preRowInfo chIndexWithPoint:point]];
    }
    return loc;
}

- (id) sentenceStoptLocationWithPoint:(CGPoint)point
{
    id loc = nil;
    CGRect preRect = CGRectZero;
    CGRect curRect = CGRectZero;
    id preRowInfo = nil;
    for (txtRowInfo* tRowInfo in rowInfoArray)
    {
        curRect = tRowInfo.contentRect;
        
        //point 正好处于这个row内
        if (point.y >= curRect.origin.y
            && point.y <= curRect.origin.y + curRect.size.height)
        {
            loc = [txtLocation txtLocationWithIndex:[tRowInfo chIndexWithPoint:point]];
            break;
        }
        else if (point.y > preRect.origin.y + preRect.size.height
                 && point.y < curRect.origin.y)//point between double row。 我们认为这个point是想要选择下一个row
        {
            loc = [txtLocation txtLocationWithIndex:[tRowInfo chIndexWithPoint:point]];
            break;
        }
        
        preRect = curRect;
        preRowInfo = tRowInfo;
    }
    
    //如果选择了屏幕的最下方的话，这个loc 应该为nil。 
    //认为他是想选择最后一行
    if (loc == nil)
    {
        loc = [txtLocation txtLocationWithIndex:[preRowInfo chIndexWithPoint:point]];
    }
    return loc;
}

- (id) startLocationWithPoint:(CGPoint)point
{
    [self createAccessbility];
    
    id loc = nil;
    CGRect preRect = CGRectZero;
    CGRect curRect = CGRectZero;
    id preRowInfo = nil;
    for (txtRowInfo* tRowInfo in rowInfoArray)
    {
        curRect = tRowInfo.contentRect;
        
        //point 正好处于这个row内
        if (point.y >= curRect.origin.y 
            && point.y <= curRect.origin.y + curRect.size.height)
        {
            loc = [txtLocation txtLocationWithIndex:[tRowInfo chIndexWithPoint:point]];
            break;
        }
        else if (point.y > preRect.origin.y + preRect.size.height
                 && point.y < curRect.origin.y)//point between double row。 我们认为这个point是想要选择下一个row
        {
            if (point.y - (preRect.origin.y + preRect.size.height) < curRect.origin.y - point.y
                && preRowInfo != nil)
            {
                loc = [txtLocation txtLocationWithIndex:[preRowInfo chIndexWithPoint:point]];
            }
            else
            {
                loc = [txtLocation txtLocationWithIndex:[tRowInfo chIndexWithPoint:point]];
            }
            
            break;
        }
        
        preRect = curRect;
        preRowInfo = tRowInfo;
    }
    
    //如果选择了屏幕的最下方的话，这个loc 应该为nil。 
    //认为他是想选择最后一行
    if (loc == nil)
    {
        loc = [txtLocation txtLocationWithIndex:[preRowInfo chIndexWithPoint:point]];
    }
    return loc;
}

- (id) stopLocationWithPoint:(CGPoint)point
{
    [self createAccessbility];
    
    id loc = nil;
    CGRect preRect = CGRectZero;
    CGRect curRect = CGRectZero;
    id preRowInfo = nil;
    for (txtRowInfo* tRowInfo in rowInfoArray)
    {
        curRect = tRowInfo.contentRect;
        
        //point 正好处于这个row内
        if (point.y >= curRect.origin.y
            && point.y <= curRect.origin.y + curRect.size.height)
        {
            loc = [txtLocation txtLocationWithIndex:[tRowInfo chIndexWithPoint:point]];
            break;
        }
        else if (point.y > preRect.origin.y + preRect.size.height
                 && point.y < curRect.origin.y)//point between double row。 我们认为这个point是想要选择下一个row
        {
            if (point.y - (preRect.origin.y + preRect.size.height) < curRect.origin.y - point.y
                && preRowInfo != nil)
            {
                loc = [txtLocation txtLocationWithIndex:[preRowInfo chIndexWithPoint:point]];
            }
            else
            {
                loc = [txtLocation txtLocationWithIndex:[tRowInfo chIndexWithPoint:point]];
            }
            
            break;
        }
        
        preRect = curRect;
        preRowInfo = tRowInfo;
    }
    
    //如果选择了屏幕的最下方的话，这个loc 应该为nil。 
    //认为他是想选择最后一行
    if (loc == nil)
    {
        loc = [txtLocation txtLocationWithIndex:[preRowInfo chIndexWithPoint:point]];
    }
    return loc;
}

- (id) accessbilityWithPoint:(CGPoint)point
{
    [self createAccessbility];
    
    id ret = nil;
    if (CGRectContainsPoint(self.startSelectingElement.contextBounds, point))
    {
        ret = self.startSelectingElement;
    }
    
    if (CGRectContainsPoint(self.stopSelectingElement.contextBounds, point))
    {
        ret = self.stopSelectingElement;
    }
    return ret;
}

- (id) sentenceStartLocationWithLocation:(id)location  //有可能找到的这个location是visibleIndex，要转化成startIndex
{
    int index = [location charactorIndex];
    for (txtRowInfo* tRowInfo in rowInfoArray) 
    {
        if (index >= tRowInfo.startIndex
            && index < tRowInfo.stopIndex)
        {
            if (index <= tRowInfo.visibleStartIndex)
            {
                return [txtLocation txtLocationWithIndex:tRowInfo.startIndex];
            }
            break;
        }
    }
    
    return location;
}

- (void) setSelectElementWithRowInfo:(txtRowInfo*) rowInfo
{
    if (rowInfo.startSelectingElement)
    {
        self.startSelectingElement = rowInfo.startSelectingElement;
    }
    
    if (rowInfo.stopSelectingElement)
    {
        self.stopSelectingElement = rowInfo.stopSelectingElement;
    }
}

- (void) setSelectStartLocation:(id)selectStartLocation_
{
    [selectStartLocation autorelease];
    selectStartLocation = [selectStartLocation_ retain];
    
    for (txtRowInfo* rowInfo in rowInfoArray)
    {
        rowInfo.selectStartLocation = selectStartLocation_;
        rowInfo.startSelectingElement = nil;
        [self setSelectElementWithRowInfo:rowInfo];
    }
}

- (void) setSelectStopLocation:(id)selectStopLocation_
{
    [selectStopLocation autorelease];
    selectStopLocation = [selectStopLocation_ retain];
    
    for (txtRowInfo* rowInfo in rowInfoArray)
    {
        rowInfo.selectStopLocation = selectStopLocation_;
        rowInfo.stopSelectingElement = nil;
        [self setSelectElementWithRowInfo:rowInfo];
    }
}

- (void) setIsSelecting:(bool)isSelecting_
{
    isSelecting = isSelecting_;
    for (txtRowInfo* rowInfo in rowInfoArray)
    {
        rowInfo.isSelecting = isSelecting_;
    }
}

#pragma mark - 
#pragma mark dealloc
- (void) dealloc
{
    SAFE_RELEASE(drawStr)
    SAFE_RELEASE(_drawFont)
    SAFE_RELEASE(_drawColor)
    SAFE_RELEASE(rowInfoArray)
    SAFE_RELEASE(preRowInfoArray)
    SAFE_RELEASE(nextRowInfoArray)
    
    SAFE_RELEASE(preStr)
    SAFE_RELEASE(nextStr)
    
    self.selectStartLocation = nil;
    self.selectStopLocation = nil;
    
    self.startSelectingElement = nil;
    self.stopSelectingElement = nil;
    [super dealloc];
}
@end
