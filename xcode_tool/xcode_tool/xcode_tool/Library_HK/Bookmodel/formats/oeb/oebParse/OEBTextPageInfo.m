//
//  OEBTextPageInfo.m
//  docinBookReader
//
//  Created by 黄柯 on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OEBTextModel.h"
#import "OEBTextPageInfo.h"
#import "OEBTextRowInfo.h"
#import "OEBParagraph.h"
#import "OEBLocation.h"
#import "accessibilityElement.h"
#import "macros_for_IOS_hk.h"
#import "UIColor+colorWithName.h"
#import "OEBTextPageInfoSelectFun.h"
#import "OEBTextRowInfoSelectFun.h"
#import "NSString ++.h"
@implementation OEBTextPageInfo

@synthesize textModel;
@synthesize isValide;
@synthesize paragraphArray;
@synthesize startLoc;
@synthesize stopLoc;
@synthesize startPlayingLocx;
@synthesize stopPlayingLoc;

@synthesize drawOriginalX = _drawOriginalX;
@synthesize drawOriginalY = _drawOriginalY;
@synthesize drawTextWidth = _drawTextWidth;
@synthesize drawTextHeight = _drawTextHeight;
@synthesize drawViewWidth = _drawViewWidth;
@synthesize drawViewHeight = _drawViewHeight;

@synthesize scale;
@synthesize drawColor;
@synthesize drawFont;

@synthesize lineSpacing;
@synthesize paragraphSpacing;



@synthesize rowInfoArray;
@synthesize preRowInfoArray;
@synthesize tempRowInfoArray;
@synthesize nextRowInfoArray;
@synthesize tParagraphArray;

@synthesize lastAttributedString;
@synthesize isSpan;
@synthesize isIndent;

@synthesize validLength;

@synthesize didCreateAccessbility;

const NSString* OEBTextPageInfo_indentStr = @"";

- (CTFrameRef) createFrame:(NSAttributedString*)attStr
{
    CTFrameRef              frame;
    CGMutablePathRef        path;
    CTFramesetterRef        frameSetter;
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
    return frame;
}

- (void) paragraphIndex:(int*)pParagraphIndex
               position:(int*)pPositon 
WithStartParapraphIndex:(int)startParagraphIndex
          StartPosition:(int)startPosition
                 Length:(int)length
{
    assert([tParagraphArray count]);
    OEBTextParagraph* paragraph = [[tParagraphArray objectAtIndex:0] objectForKey:@"textParagraph"];
    int paragraphIndex = [[[tParagraphArray objectAtIndex:0] objectForKey:@"paragraphIndex"] intValue];
    int positon = startPosition;
    assert(startParagraphIndex == paragraphIndex);
    NSString* str = nil;
    
    if ([paragraph.content length] > startPosition)
    {
        str = [paragraph.content substringFromIndex:startPosition];
    }
    
    
    while (length > 0)
    {
        int tLength = [str length];
        if (tLength >= length)
        {
            *pParagraphIndex = paragraphIndex;
            *pPositon = positon + length;

            break;
        }
        [tParagraphArray removeObjectAtIndex:0];
        validLength -= [str length];
        if ([tParagraphArray count] == 0)
        {
            assert(0);
        }
        
        length -= tLength;
        OEBTextParagraph* paragraph = [[tParagraphArray objectAtIndex:0] objectForKey:@"textParagraph"];
        str = paragraph.content;
        paragraphIndex = [[[tParagraphArray objectAtIndex:0] objectForKey:@"paragraphIndex"] intValue];
        positon = 0;
    }
}
- (void) parseInFrameForward:(NSAttributedString*)attStr
           WithDrawOriginalY:(CGFloat*)pOriginalY
{
    if ([tParagraphArray count] == 0)
    {
        return;
    }
    
    CGFloat drawOriginalY = *pOriginalY;
    CTFrameRef frame = [self createFrame:attStr];
    
    //创建array
    /**************************************************************************************************************************/
    NSArray* lineRefArray = (NSArray*) CTFrameGetLines(frame);
    
    int startIndex = 0;
    int paragraphIndex = [[[tParagraphArray objectAtIndex:0] objectForKey:@"paragraphIndex"] intValue];
    if (paragraphIndex == self.startLoc.paragraph)
    {
        startIndex = self.startLoc.postion;
    }
    
    for (int i=0; i<[lineRefArray count]; i++)
    {
        assert([tParagraphArray count]);
        CTLineRef lineRef = (CTLineRef)[lineRefArray objectAtIndex:i];
        CFRange range = CTLineGetStringRange(lineRef);
        CGFloat ascent;
        CGFloat descent;
        CGFloat leading;
        CGFloat height;
        CGFloat width;
        width = CTLineGetTypographicBounds(lineRef, &ascent, &descent, &leading);
        height = ascent + descent;
        
        NSAttributedString* drawStrInRow = [attStr attributedSubstringFromRange:NSMakeRange(range.location, range.length)];

        //如果这一行没有数据的话continue
        if (![[drawStrInRow string] isVisible])
        {
            if (startIndex == 0 && isIndent)
            {
                if (range.length >= [OEBTextPageInfo_indentStr length])
                {
                    startIndex += range.length - [OEBTextPageInfo_indentStr length];
                }
            }
            else
            {
                startIndex += range.length;
            }
            
            continue;
        }
        
        OEBTextRowInfo* tRowInfo = [[[OEBTextRowInfo alloc] init] autorelease];
        
        OEBLocation* tStartLoc = [[[OEBLocation alloc] initWithHref:self.startLoc.href] autorelease];
        tStartLoc.paragraph = paragraphIndex;
        tStartLoc.postion = startIndex;
        
        OEBLocation* tStopLoc = [[[OEBLocation alloc] initWithHref:self.startLoc.href] autorelease];
        int length = range.length;
        if (startIndex == 0 && isIndent)
        {
            length -= [OEBTextPageInfo_indentStr length];
            tRowInfo.isIndent = YES;
        }
        [self paragraphIndex:&paragraphIndex
                    position:&startIndex
     WithStartParapraphIndex:tStartLoc.paragraph
               StartPosition:tStartLoc.postion
                      Length:length];
        tStopLoc.paragraph = paragraphIndex;
        tStopLoc.postion = startIndex;
        tRowInfo.startLoc = tStartLoc;
        tRowInfo.stopLoc = tStopLoc;
        
        tRowInfo.drawFont = self.drawFont;
        tRowInfo.drawColor = self.drawColor;
        
        //这个地方要多取一点，因为本行的排版和下一行的数据有关系
        if (i+1 < [lineRefArray count])
        {
            CTLineRef lineRef = (CTLineRef)[lineRefArray objectAtIndex:i+1];
            CFRange rangeNext = CTLineGetStringRange(lineRef);
            tRowInfo.content = [attStr attributedSubstringFromRange:NSMakeRange(range.location, range.length + rangeNext.length)];
        }
        else
        {
            tRowInfo.content = drawStrInRow;
        }
        
        
        tRowInfo.textModel = self.textModel;
        
        CGPoint origins;
        CTFrameGetLineOrigins(frame, CFRangeMake(i, 1), &origins);
        
        tRowInfo.drawOriginalX = self.drawOriginalX + origins.x;
        tRowInfo.drawOriginalY = self.drawOriginalY + drawOriginalY;
        tRowInfo.drawTextWidth = self.drawTextWidth;
        tRowInfo.drawTextHeight = height;
        tRowInfo.drawViewHeight = self.drawViewHeight;
        tRowInfo.drawTextWidth = self.drawTextWidth;
        
        [tRowInfo setLine:lineRef];
        
        if (startIndex == 0 && isIndent)
        {
            startIndex -= [OEBTextPageInfo_indentStr length];
        }
        drawOriginalY += height;
        
        
        if (drawOriginalY < self.drawTextHeight)
        {
            self.stopLoc = tRowInfo.stopLoc;
            [rowInfoArray addObject:tRowInfo];
            //debugLog(@"%f,%f",tRowInfo.drawOriginalY,tRowInfo.drawTextHeight);
        }
        else
        {
            tRowInfo.drawOriginalY -= self.lineSpacing;
            [self.nextRowInfoArray addObject:tRowInfo];
        }
        
        
        if (i != [lineRefArray count] - 1)
        {
            drawOriginalY += self.lineSpacing;
        }
    }
    /**************************************************************************************************************************/
    
    
    //nextRowInfoArray的特殊处理
    //因为最后一行，很有可能不是排版良好的。。所以去掉。不要了。 epub 不用做此处理
    /**************************************************************************************************************************/
//    if ([nextRowInfoArray count])
//    {
//        [nextRowInfoArray removeLastObject];
//    }
    /**************************************************************************************************************************/
    
    [tParagraphArray removeAllObjects];
    
    *pOriginalY = drawOriginalY;
}

- (CTTextAlignment) alignmentFromOEBTextAlignment:(OEBTextAlignment)alignment
{
    switch (alignment)
    {
        case OEBTextAlignmentNone:
            return kCTJustifiedTextAlignment;
        case OEBTextAlignmentLeft:
            return kCTJustifiedTextAlignment;
        case OEBTextAlignmentCenter:
            return kCTCenterTextAlignment;
        case OEBTextAlignmentRight:
            return kCTRightTextAlignment;
            break;
        default:
            break;
    }
    return 0;
}

- (NSMutableAttributedString*) createAttributedStringWithTextParagraph:(OEBTextParagraph*)textParagraph
                                                     WithStartPosition:(int)startPosition
{
    UIFont* _drawFont = textParagraph.textStyle.textFont;
    CGFloat scale_ = self.scale;
    if (_drawFont == nil)
    {
        _drawFont = self.drawFont;
        scale_ = 1;
    }
    
    OEBCSSStyle* textStyle = textParagraph.textStyle;
    NSString* _drawStr = textParagraph.content;
    
    if (startPosition < [_drawStr length])
    {
        _drawStr = [_drawStr substringFromIndex:startPosition];
    }
    else
    {
        _drawStr = nil;
    }
    
    if (!(_drawStr && [_drawStr length]))
    {
        return nil;
    }
    //如果需要缩进的话，在之前加一个\t
    if (textStyle.textIndent && startPosition == 0 && [tParagraphArray count] == 0)
    {
        _drawStr = [OEBTextPageInfo_indentStr stringByAppendingString:_drawStr];
    }
    
    NSMutableAttributedString* attStr = [[[NSMutableAttributedString alloc] initWithString:_drawStr] autorelease];
    NSRange range = NSMakeRange(0, [_drawStr length]);
    
    CGColorRef drawColor_;
    
    if (CGColorEqualToColor(self.drawColor.CGColor, [UIColor colorWithColorName:@"black"].CGColor)) 
    {
        drawColor_ = [textStyle getUIColor].CGColor;
    }
    else
    {
        drawColor_ = [textStyle getUIColor].CGColor;
        if (CGColorEqualToColor([textStyle getUIColor].CGColor, [UIColor colorWithColorName:@"black"].CGColor))
        {
            drawColor_ = [UIColor whiteColor].CGColor;
        }
    } 
    
    if (textParagraph.type == OEBParagraphTypeHyperlink) 
    {
        drawColor_ = [UIColor blueColor].CGColor;
        
//        kCTUnderlineStyleNone = 0x00,
//        kCTUnderlineStyleSingle = 0x01,
//        kCTUnderlineStyleThick = 0x02,
//        kCTUnderlineStyleDouble = 0x09
        
//        kCTUnderlinePatternSolid = 0x0000,
//        kCTUnderlinePatternDot = 0x0100,
//        kCTUnderlinePatternDash = 0x0200,
//        kCTUnderlinePatternDashDot = 0x0300,
//        kCTUnderlinePatternDashDotDot = 0x0400
        
        [attStr addAttribute:(NSString*)kCTUnderlineColorAttributeName value:(id)drawColor_ range:range];
//        [attStr addAttribute:(NSString*)kCTUnderlineStyleAttributeName 
//                       value:(id)[NSNumber numberWithInt:kCTUnderlineStyleSingle | kCTUnderlinePatternSolid] 
//                       range:range];
    }
    
    [attStr addAttribute:(NSString*)kCTForegroundColorAttributeName
                   value:(id)drawColor_
                   range:range];
    //设置字体 开始
    /**************************************************************************************************************************/
    CFStringRef fontName = AUTO_RELEASED_CTREF(CFStringCreateWithCString(NULL,
                                                                         [[_drawFont fontName] cStringUsingEncoding:NSUTF8StringEncoding], 
                                                                         kCFStringEncodingUTF8));
    
    CTFontRef fontRef = AUTO_RELEASED_CTREF(CTFontCreateWithName(fontName,_drawFont.pointSize * scale_, NULL));
    [attStr addAttribute:(NSString*)kCTFontAttributeName value:(id)fontRef range:range];
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
    
    
    float indet = 0;
    
    if (textStyle.textIndent
        && startPosition == 0)
    {
        indet = _drawFont.pointSize * 2;
    }
    CGFloat value[] = 
    {   indet , //kCTParagraphStyleSpecifierFirstLineHeadIndent;
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
    alignment = [self alignmentFromOEBTextAlignment:textStyle.textAlign];
    settings[settingsIndex].value = &alignment;
    settingsIndex++;
    
    CTParagraphStyleRef style = AUTO_RELEASED_CTREF(CTParagraphStyleCreate((const CTParagraphStyleSetting*) settings, settingsIndex));
    [attStr addAttribute:(NSString*)kCTParagraphStyleAttributeName value:(id)style range:range];
    /**************************************************************************************************************************/
    
    
    return attStr;
}

- (void) parseTextParagraph:(OEBTextParagraph*)textParagraph
         WithParagraphIndex:(int)paragraphIndex
              WithOriginalY:(CGFloat*)pOrginalY
{
    int startPosition = startLoc.postion * (paragraphIndex == startLoc.paragraph ? 1 : 0);
    NSAttributedString* attStr = [self createAttributedStringWithTextParagraph:textParagraph WithStartPosition:startPosition];
    
    if (attStr)
    {
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:textParagraph,@"textParagraph",[NSNumber numberWithInt:paragraphIndex],@"paragraphIndex", nil];
        
        if ([tParagraphArray count] == 0)
        {
            isIndent = textParagraph.textStyle.textIndent;
        }
        [tParagraphArray addObject:dic];
        
        
        [lastAttributedString appendAttributedString:attStr];
    }
}

- (void) parseImageParagraph:(OEBImageParagraph*)imageParagraph
         WithParagraphIndex:(int)paragraphIndex
              WithOriginalY:(CGFloat*)pOrginalY
{
    UIImage* image = [textModel imageWithPath:imageParagraph.imagePath];
    if (image)
    {
        OEBTextRowInfo* tRowInfo = [[[OEBTextRowInfo alloc] init] autorelease];
        
        tRowInfo.content = image;
        tRowInfo.drawImage = image;
        OEBLocation* tStartLoc = [[[OEBLocation alloc] initWithHref:self.startLoc.href] autorelease];
        tStartLoc.paragraph = paragraphIndex;
        tStartLoc.postion = 0;
        
        OEBLocation* tStopLoc = [[[OEBLocation alloc] initWithHref:self.startLoc.href] autorelease];
        tStopLoc.paragraph = paragraphIndex;
        tStopLoc.postion = 1;
        
        tRowInfo.startLoc = tStartLoc;
        tRowInfo.stopLoc = tStopLoc;
        
        tRowInfo.drawFont = self.drawFont;
        tRowInfo.drawColor = self.drawColor;
        tRowInfo.content = image;
        tRowInfo.drawOriginalX = self.drawOriginalX;
        tRowInfo.drawOriginalY = self.drawOriginalY + *pOrginalY;
        tRowInfo.drawFont = self.drawFont;
        tRowInfo.drawViewHeight = self.drawViewHeight;
        tRowInfo.drawViewWidth  = self.drawViewWidth;
        
        tRowInfo.drawTextWidth = image.size.width;
        tRowInfo.drawTextHeight = image.size.height;
        
        if ([rowInfoArray count] == 0)
        {
            //计算宽度
            if (tRowInfo.drawTextWidth > self.drawTextWidth)
            {
                float oldDrawTextWidth = tRowInfo.drawTextWidth;
                tRowInfo.drawTextWidth = self.drawTextWidth;
                tRowInfo.drawTextHeight = tRowInfo.drawTextHeight * (tRowInfo.drawTextWidth / oldDrawTextWidth);
            }
            
            //计算高度
            if (tRowInfo.drawTextHeight + *pOrginalY > self.drawTextHeight)
            {
                float oldDrawTextHeight = tRowInfo.drawTextHeight;
                tRowInfo.drawTextHeight = self.drawTextHeight;
                tRowInfo.drawTextWidth = tRowInfo.drawTextWidth * (tRowInfo.drawTextHeight / oldDrawTextHeight);
                *pOrginalY = self.drawTextHeight;
            }
            
            tRowInfo.drawOriginalX = self.drawOriginalX + (self.drawTextWidth - tRowInfo.drawTextWidth) / 2;
            *pOrginalY += tRowInfo.drawTextHeight;
            self.stopLoc = tRowInfo.stopLoc;
            [rowInfoArray addObject:tRowInfo];
        }
        else
        {
            //计算宽度
            if (tRowInfo.drawTextWidth > self.drawTextWidth)
            {
                float oldDrawTextWidth = tRowInfo.drawTextWidth;
                tRowInfo.drawTextWidth = self.drawTextWidth;
                tRowInfo.drawTextHeight = tRowInfo.drawTextHeight * (tRowInfo.drawTextWidth / oldDrawTextWidth);
            }
            
            tRowInfo.drawOriginalX = self.drawOriginalX + (self.drawTextWidth - tRowInfo.drawTextWidth) / 2;
            
            //计算高度
            if (tRowInfo.drawTextHeight + *pOrginalY <= self.drawTextHeight)
            {
                tRowInfo.drawTextHeight = tRowInfo.drawTextHeight;
                *pOrginalY += tRowInfo.drawTextHeight;
                self.stopLoc = tRowInfo.stopLoc;
                [rowInfoArray addObject:tRowInfo];  
            }
        }
    }
}

- (void) parseControlParagraph:(OEBControlParagraph*)controlParagraph
          WithParagraphIndex:(int)paragraphIndex
               WithOriginalY:(CGFloat*)pOrginalY
{
    if (controlParagraph.isStart)
    {
        if (controlParagraph.lineBreaker)
        {
            [self parseInFrameForward:self.lastAttributedString
                    WithDrawOriginalY:pOrginalY];
            self.lastAttributedString = [[[NSMutableAttributedString alloc] initWithString:@""] autorelease];
        }
    }
    else
    {
        if (controlParagraph.lineBreaker)
        {
            [self parseInFrameForward:self.lastAttributedString
                    WithDrawOriginalY:pOrginalY];
            self.lastAttributedString = [[[NSMutableAttributedString alloc] initWithString:@""] autorelease];
        }
    }
    
    if (*pOrginalY != 0)
    {
        if (controlParagraph.isStart)
        {
            switch (controlParagraph.controlType)
            {
                case ID_P:
                    // 段间距
                    *pOrginalY += self.paragraphSpacing * 1;
                    break;
                    
                case ID_DIV:
                case ID_BR:
                case ID_UL:
                    *pOrginalY += self.paragraphSpacing * 1;
                    break;
                case ID_LI:
                    break;
                case ID_SPAN:
                    break;
                case ID_H1:
                    // 段间距
                    *pOrginalY += self.paragraphSpacing * 1.5;
                    break;
                case ID_H2:
                    // 段间距
                    *pOrginalY += self.paragraphSpacing * 1;
                    break;
                case ID_H3:
                    // 段间距
                    *pOrginalY += self.paragraphSpacing * 1;
                    break;
                case ID_H4:
                    // 段间距
                    *pOrginalY += self.paragraphSpacing * 1;
                    break;
                case ID_H5:
                    // 段间距
                    *pOrginalY += self.paragraphSpacing * 1;
                    break;
                case ID_H6:
                    // 段间距
                    *pOrginalY += self.paragraphSpacing * 1;
                    break;
                    
                default:
                    break;
            }

        }
        else if (controlParagraph.controlType == ID_BR)
        {
            // 段间距
            *pOrginalY += self.paragraphSpacing * 1;
        }
    }
}

- (void) dealWithTempRowInfoWithOriginalY:(CGFloat*)pOrginalY
{
    OEBTextRowInfo* firstRowInfo = [self.tempRowInfoArray objectAtIndex:0];
    CGFloat relativeHeight = firstRowInfo.drawOriginalY - self.drawOriginalY;
    for (OEBTextRowInfo* tRowInfo in self.tempRowInfoArray)
    {
        tRowInfo.drawOriginalY -= relativeHeight;
        if (tRowInfo.drawOriginalY + tRowInfo.drawTextHeight > self.drawOriginalY + self.drawTextHeight)
        {
            tRowInfo.drawOriginalY -= self.lineSpacing;
            [self.nextRowInfoArray addObject:tRowInfo];
        }
        else
        {
            //debugLog(@"%f,%f",tRowInfo.drawOriginalY,tRowInfo.drawTextHeight);
            [self.rowInfoArray addObject:tRowInfo];
            *pOrginalY = tRowInfo.drawOriginalY + tRowInfo.drawTextHeight;
        }
    }
    *pOrginalY -= self.drawOriginalY;
}

#pragma mark-
#pragma mark- prepareForPage
- (void) prepareForPage
{
    SAFE_RELEASE(nextRowInfoArray)
    self.nextRowInfoArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    SAFE_RELEASE(rowInfoArray)
    self.rowInfoArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    SAFE_RELEASE(tParagraphArray)
    self.tParagraphArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    self.lastAttributedString = [[[NSMutableAttributedString alloc] initWithString:@""] autorelease];
    
    self.didCreateAccessbility = NO;
    
    CGFloat drawOriginalY = 0;
    int paragraphIndex = startLoc.paragraph;
    int position = startLoc.postion;
    //没有足够多的退出
    if (paragraphIndex >= [paragraphArray count])
    {
        return;
    }
    
    if ([self.tempRowInfoArray count] != 0)
    {
        [self dealWithTempRowInfoWithOriginalY:&drawOriginalY];
        paragraphIndex = [[self.rowInfoArray lastObject] stopLoc].paragraph+1;
        position = 0;
    }
    
    if ([nextRowInfoArray count] || paragraphIndex >= [paragraphArray count])
    {
        self.stopLoc = [[self.rowInfoArray lastObject] stopLoc];
        isValide = YES;
        return;
    }
    
    while (1)
    {
        OEBParagraph* paragraph = [paragraphArray objectAtIndex:paragraphIndex];
        if (OEBParagraphTypeText == paragraph.type 
            || OEBParagraphTypeHyperlink == paragraph.type) 
        {
            [self parseTextParagraph:(OEBTextParagraph*)paragraph
                  WithParagraphIndex:paragraphIndex
                       WithOriginalY:&drawOriginalY];
        }
        else if (OEBParagraphTypeImage == paragraph.type
                 && position == 0)
        {
            [self parseImageParagraph:(OEBImageParagraph*)paragraph
                   WithParagraphIndex:paragraphIndex
                        WithOriginalY:&drawOriginalY];
        }
        else if (OEBParagraphTypeControl == paragraph.type)
        {
            [self parseControlParagraph:(OEBControlParagraph*)paragraph
                     WithParagraphIndex:paragraphIndex
                          WithOriginalY:&drawOriginalY];
        }
        paragraphIndex++;
        position = 0;
        //有足够的rowInfo退出
        if (drawOriginalY >= self.drawTextHeight)
        {
            break;
        }
        
        //没有足够多的退出
        if (paragraphIndex >= [paragraphArray count])
        {
            break;
        }
    }
    
    if ([rowInfoArray count])
    {
        self.stopLoc = [[self.rowInfoArray lastObject] stopLoc];
        isValide = YES;
    }
}

- (void) reCreateWithStartSpecLoc:(id)startSpecLoc
                  withStopSpecLoc:(id)stopSpecLoc
{
    if (self.startPlayingLocx != startSpecLoc
        || self.stopPlayingLoc != stopSpecLoc)
    {
        self.startPlayingLocx = startSpecLoc;
        self.stopPlayingLoc = stopSpecLoc;
        
        for (OEBTextRowInfo* rowInfo in rowInfoArray) 
        {
            [rowInfo reCreateWithStartSpecLoc:startSpecLoc
                              withStopSpecLoc:stopSpecLoc];
        }
    }
}

#pragma mark - 
#pragma mark drawPage
- (void) drawPageInContext:(CGContextRef)context
{
    CGContextSaveGState(context);
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    for (OEBTextRowInfo* rowInfo in rowInfoArray) 
    {
        [rowInfo drawInContext:context];
    }
    CGContextRestoreGState(context);
}

- (void) drawPageInContext:(CGContextRef)context
              bookDrawMode:(int)drawMode
           StartPlayingLoc:(id)startPlayingLoc_
            StopPlayingLoc:(id)stopPlayingLoc_;
{
    [self reCreateWithStartSpecLoc:startPlayingLoc_
                       withStopSpecLoc:stopPlayingLoc_];
    
    //START_TIMER;
    [self drawPageInContext:context];
    //END_TIMER(@"drawPageInContext");
}

- (BOOL) isLocationinThePage:(OEBLocation*)loc ;
{
    if (![startLoc.href isEqualToString:loc.href]) 
    {
        return NO;
    }
    
    if (![startLoc isForwardFrom:loc]
        && [stopLoc isForwardFrom:loc])
    {
        return YES;
    }
    return NO;
}

- (UIImage *)imageWithPoint:(CGPoint)point
{
    [self createAccessbility];
    
    for (OEBTextRowInfo* tRowInfo in rowInfoArray)
    {
        accessibilityElement* element_ =[tRowInfo accessibilityElementWithPoint:point];
        if (element_.image)
        {
            return element_.image;
        }
    }
    return nil;
}

- (void) createAccessbility
{
    if (!self.didCreateAccessbility) 
    {
        for (OEBTextRowInfo* tRowInfo in rowInfoArray)
        {
            [tRowInfo createAccessbility];
        }
        
        self.didCreateAccessbility = YES;
    }
}

@synthesize selectStopLocation;
@synthesize selectStartLocation;
@synthesize isSelecting;

@synthesize startSelectingElement;
@synthesize stopSelectingElement;

#pragma mark-
#pragma mark set
- (void) setSelectStartLocation:(id)selectStartLocation_
{   
    [selectStartLocation autorelease];
    selectStartLocation = [selectStartLocation_ retain];
    
    for (OEBTextRowInfo* tRowInfo in self.rowInfoArray)
    {
        tRowInfo.selectStartLocation = selectStartLocation;
        tRowInfo.startSelectingElement = nil;
        [self setSelectElementWithRowInfo:tRowInfo];
    }
}

- (void) setSelectStopLocation:(id)selectStopLocation_
{
    [selectStopLocation autorelease];
    selectStopLocation = [selectStopLocation_ retain];
    
    for (OEBTextRowInfo* tRowInfo in self.rowInfoArray)
    {
        tRowInfo.selectStopLocation = selectStopLocation;
        tRowInfo.stopSelectingElement = nil;
        [self setSelectElementWithRowInfo:tRowInfo];
    }
}

- (void) setIsSelecting:(bool)isSelecting_
{
    isSelecting = isSelecting_;
    for (OEBTextRowInfo* tRowInfo in self.rowInfoArray)
    {
        tRowInfo.isSelecting = isSelecting;
    }
}

- (void) dealloc
{
    SAFE_RELEASE(paragraphArray)
    SAFE_RELEASE(startLoc)
    SAFE_RELEASE(stopLoc)
    SAFE_RELEASE(startPlayingLocx)
    SAFE_RELEASE(stopPlayingLoc)
    SAFE_RELEASE(drawFont)
    SAFE_RELEASE(drawColor)
    
    SAFE_RELEASE(rowInfoArray);
    
    SAFE_RELEASE(preRowInfoArray);
    SAFE_RELEASE(nextRowInfoArray);
    SAFE_RELEASE(tParagraphArray);
    SAFE_RELEASE(lastAttributedString);
    
    SAFE_RELEASE(startSelectingElement)
    SAFE_RELEASE(stopSelectingElement)
    SAFE_RELEASE(selectStartLocation)
    SAFE_RELEASE(selectStopLocation)
    [super dealloc];
}

@end
