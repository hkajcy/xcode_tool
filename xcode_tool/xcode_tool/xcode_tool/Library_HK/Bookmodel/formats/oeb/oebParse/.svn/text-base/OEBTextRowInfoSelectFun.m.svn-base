//
//  OEBTextRowInfoSelectFun.m
//  DocinBookReader
//
//  Created by  on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OEBTextRowInfoSelectFun.h"
#import "accessibilityElement.h"
#import "OEBLocation.h"
#import "OEBTextModel.h"

#define selectRectSize      (CGSizeMake(-20, -20))

@implementation OEBTextRowInfo(select)

- (void) createAccessbilityWithUIImage
{
    accessibilityElement* element_ = [[[accessibilityElement alloc] init] autorelease];
    element_.contextBounds = CGRectMake(self.drawOriginalX, self.drawOriginalY, self.drawTextWidth, self.drawTextHeight);
    element_.image = self.content;
    [self.accessibilityArray addObject:element_];
}

- (void) createAccessbilityWithNSString
{
    CGFloat secondaryOffset = 0;
    CFRange range = CTLineGetStringRange(lineRef);
    
    for (int i=0; i<range.length; i++)
    {
        CGFloat originalX = 0;
        CGFloat originalY = 0;
        CGFloat width = 0;
        CGFloat height = 0;
        CGFloat ascent;
        CGFloat descent;
        CGFloat leading;
        
        CTLineGetTypographicBounds(lineRef, &ascent, &descent, &leading);
        
        originalX = CTLineGetOffsetForStringIndex(lineRef, range.location + i, &secondaryOffset) + self.drawOriginalX;
        originalY = (self.drawOriginalY + descent + leading);
        
        width = CTLineGetOffsetForStringIndex(lineRef, range.location + i + 1, &secondaryOffset) - originalX + self.drawOriginalX;
        
        height =self.drawTextHeight;
        
        accessibilityElement* element_ = [[[accessibilityElement alloc] init] autorelease];
        element_.contextBounds = CGRectInset(CGRectMake(originalX, originalY, width, height),-1,-1);
        
        element_.startLocation = [self.textModel locationForForward:self.startLoc withLength:i];
        
        if ([element_.startLocation isParagraphEnd])
        {
            element_.startLocation = [element_.startLocation nextParagraphStartLocation];
        }
       
        
        [self.accessibilityArray addObject:element_];
    }
}

- (void) createAccessbility
{
    self.accessibilityArray = nil;
    self.accessibilityArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    if ([self.content isKindOfClass:[NSAttributedString class]])
    {
        [self createAccessbilityWithNSString];
    }
    else
    {
        [self createAccessbilityWithUIImage];
    }
    
    self.contentRect = CGRectMake(self.drawOriginalX, self.drawOriginalY, self.drawTextWidth, self.drawTextHeight);
}

- (id) accessibilityElementWithPoint:(CGPoint)point
{
    for (accessibilityElement* element_ in self.accessibilityArray)
    {
        if (CGRectContainsPoint(element_.contextBounds, point))
        {
            return element_;
        }
    }
    
    return nil;
}

- (id) startLocationWithPoint:(CGPoint)point
{
    id loc = nil;
    for (accessibilityElement* element in self.accessibilityArray)
    {
        CGRect rect = element.contextBounds;
        if (point.x >= rect.origin.x
            && point.x < rect.origin.x + rect.size.width)
        {
            loc = element.startLocation;
            break;
        }
    }
    
    if (loc == nil)
    {
        if (point.x < self.drawOriginalX)
        {
            loc = self.startLoc;
        }
        else
        {
            loc = self.stopLoc;
        }
    }
    
    return loc;
}

- (id) stopLocationWithPoint:(CGPoint)point
{
    if ([self.content isKindOfClass:[NSAttributedString class]])
    {
        return [self startLocationWithPoint:point];
    }
    else
    {
        OEBLocation* loc = [[[OEBLocation alloc] init] autorelease];
        loc.href = self.startLoc.href;
        loc.paragraph = self.startLoc.paragraph;
        loc.postion = 1;
        return loc;
    }
    
    return nil;
}


#pragma mark-
#pragma mark draw
- (void) drawSelectElement:(CGContextRef)context
{
    float k = (1.5 - 1.2) / (10 - 24);
    float b = 1.5 - 10 * k;
    
    float height = self.drawFont.pointSize * (self.drawFont.pointSize * k + b);
    
    for (accessibilityElement* element in self.accessibilityArray)
    {
        if ([element.startLocation isEqualLocation:self.selectStartLocation])
        {
            CGRect rect = element.contextBounds;
            rect.size.width = self.drawFont.pointSize / 5;
            rect.origin.x -= self.drawFont.pointSize / 5;
            rect.size.height = height;
            
            CGContextBeginPath(context);
            CGContextAddRect(context, rect);
            CGContextClosePath(context);
            CGContextSetFillColorWithColor(context, kSelectEdgeColor.CGColor);
            CGContextFillPath(context);
            
            //画圆圈
            CGContextBeginPath(context);
            CGContextAddArc(context, rect.origin.x + rect.size.width / 2, rect.origin.y, rect.size.width / 2 + 2, 0, 2*M_PI, YES);
            CGContextStrokePath(context);
            
            //往圆圈内填充颜色
            CGContextBeginPath(context);
            CGContextAddArc(context, rect.origin.x + rect.size.width / 2, rect.origin.y, rect.size.width / 2 + 2, 0, 2*M_PI, YES);
            CGContextClosePath(context);
            CGContextSetFillColorWithColor(context, kSelectCircleColor.CGColor);
            CGContextFillPath(context);
        }
        
        OEBLocation* tLoc = (OEBLocation*)(element.startLocation);
        OEBLocation* loc = [[[OEBLocation alloc] initWithHref:tLoc.href] autorelease];
        loc.paragraph = tLoc.paragraph;
        loc.postion = tLoc.postion + 1;
        
        if ([loc isEqualLocation:self.selectStopLocation])
        {
            CGRect rect = element.contextBounds;
            rect.origin.x += rect.size.width;
            rect.size.width = self.drawFont.pointSize / 5;
            rect.size.height = height;
            
            CGContextBeginPath(context);
            CGContextAddRect(context, rect);
            CGContextClosePath(context);
            CGContextSetFillColorWithColor(context, kSelectEdgeColor.CGColor);
            CGContextFillPath(context);
            
            //画圆圈
            CGContextBeginPath(context);
            CGContextAddArc(context, rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height, rect.size.width / 2 + 2, 0, 2*M_PI, YES);
            CGContextStrokePath(context);
            
            //往圆圈内填充颜色
            CGContextBeginPath(context);
            CGContextAddArc(context, rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height, rect.size.width / 2 + 2, 0, 2*M_PI, YES);
            CGContextClosePath(context);
            CGContextSetFillColorWithColor(context, kSelectCircleColor.CGColor);
            CGContextFillPath(context);
        }
    }

}

- (void) drawSelectAreaInContext:(CGContextRef)context
{
    OEBLocation* startSLoc = (OEBLocation*)self.selectStartLocation;
    OEBLocation* stopSLoc = (OEBLocation*)self.selectStopLocation;
    
    float k = (1.5 - 1.2) / (10 - 24);
    float b = 1.5 - 10 * k;
    
    float height = self.drawFont.pointSize * (self.drawFont.pointSize * k + b);
    
    if (startSLoc == nil
        || stopSLoc == nil)
    {
        return;
    }
    
    if (![startSLoc.href isEqualToString:self.startLoc.href])
    {
        return;
    }
    
    CGContextTranslateCTM(context, 0, self.drawViewHeight);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    NSRange colorRange = NSMakeRange(0, 0);
    if ([startSLoc isBackwardFrom:self.startLoc]
        && [stopSLoc isForwardFrom:self.startLoc]
        && ![stopSLoc isForwardFrom:self.stopLoc]) 
    {
        colorRange.location = 0;
        colorRange.length = [self.textModel stringLengthFromLocation:self.startLoc toLocation:stopSLoc];
    }
    else if (![startSLoc isForwardFrom:self.startLoc]
             && ![stopSLoc isBackwardFrom:self.stopLoc])
    {
        colorRange.location = 0;
        colorRange.length = [self.content length];
    }
    else if (![startSLoc isBackwardFrom:self.startLoc]
             && ![startSLoc isForwardFrom:self.stopLoc]
             && ![stopSLoc isForwardFrom:self.stopLoc])
    {
        colorRange.location = [self.textModel stringLengthFromLocation:self.startLoc toLocation:startSLoc];
        colorRange.length = [self.textModel stringLengthFromLocation:startSLoc toLocation:stopSLoc];
    }
    else if ([stopSLoc isForwardFrom:self.stopLoc]
             && ![startSLoc isBackwardFrom:self.startLoc]
             && [startSLoc isBackwardFrom:self.stopLoc])
    {
        colorRange.location = [self.textModel stringLengthFromLocation:self.startLoc toLocation:startSLoc];
        colorRange.length = [self.textModel stringLengthFromLocation:startSLoc toLocation:self.stopLoc];
    }
    
    
    
    if (self.isSelecting)
    {
        if (colorRange.length != 0)
        {
            
            
            int count = [self.accessibilityArray count];
            NSAssert(count > 0,@"");
            NSAssert(colorRange.location < count,@"");
            
            colorRange.length = (NSMaxRange(colorRange) < count)?colorRange.length:colorRange.length - (NSMaxRange(colorRange)-count);
            NSAssert(NSMaxRange(colorRange) <= count,@"");
            
            NSArray* array = [self.accessibilityArray subarrayWithRange:colorRange];
            accessibilityElement* startElement = [array objectAtIndex:0];
            accessibilityElement* stopElemet = [array lastObject];
            
            CGPoint startPoint = CGPointZero;
            CGPoint stopPoint = CGPointZero;
            
            startPoint = startElement.contextBounds.origin;
            stopPoint = stopElemet.contextBounds.origin;
            stopPoint.x += stopElemet.contextBounds.size.width;
            
            CGRect rect = CGRectMake(startPoint.x, startPoint.y, stopPoint.x - startPoint.x, height);
            
            CGContextBeginPath(context);
            CGContextAddRect(context, rect);
            CGContextClosePath(context);
            CGContextSetFillColorWithColor(context, kSelectColor.CGColor);
            CGContextFillPath(context);
            
            
            
        }
        
        if ((![self.startLoc isForwardFrom:self.selectStartLocation]
             && ![self.stopLoc isBackwardFrom:self.selectStartLocation])
            ||
            (![self.startLoc isForwardFrom:self.selectStopLocation]
             && ![self.stopLoc isBackwardFrom:self.selectStopLocation]))
        {
            [self drawSelectElement:context];
        }

    }
    
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0, -self.drawViewHeight);
}

#pragma mark-
#pragma mark get
- (void) createSelectingElement
{
    OEBLocation* startSLoc = (OEBLocation*)self.selectStartLocation;
    OEBLocation* stopSLoc = (OEBLocation*)self.selectStopLocation;
    
    if (startSLoc == nil
        || stopSLoc == nil)
    {
        return;
    }
    
    if (![startSLoc.href isEqualToString:self.startLoc.href])
    {
        return;
    }
    
    if ((![self.startLoc isForwardFrom:self.selectStartLocation]
         && ![self.stopLoc isBackwardFrom:self.selectStartLocation])
        ||
        (![self.startLoc isForwardFrom:self.selectStopLocation]
         && ![self.stopLoc isBackwardFrom:self.selectStopLocation]))
    {
        for (accessibilityElement* element in self.accessibilityArray)
        {
            //首选位置
            if ([element.startLocation isEqualLocation:self.selectStartLocation])
            {
                CGRect rect = element.contextBounds;
                rect.size.width = self.drawFont.pointSize / 5;
                rect.origin.x -= self.drawFont.pointSize / 5;
                
                CGRect selectRect = CGRectMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height, 0, 0);
                
                self.startSelectingElement = [[[accessibilityElement alloc] init] autorelease];
                self.startSelectingElement.contextBounds = CGRectInset(selectRect, selectRectSize.width, selectRectSize.height);
                self.startSelectingElement.startLocation = [element startLocation];
                self.startSelectingElement.accessibilityHint = @"startSelectingElement";
            }
            
            OEBLocation* tLoc = (OEBLocation*)(element.startLocation);
            OEBLocation* loc = [[[OEBLocation alloc] initWithHref:tLoc.href] autorelease];
            loc.paragraph = tLoc.paragraph;
            loc.postion = tLoc.postion + 1;
            
            //末选位置
            if ([loc isEqualLocation:self.selectStopLocation])
            {
                CGRect rect = element.contextBounds;
                rect.origin.x += rect.size.width;
                rect.size.width = self.drawFont.pointSize / 5;
                
                CGRect selectRect = CGRectMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height, 0, 0);
                
                self.stopSelectingElement = [[[accessibilityElement alloc] init] autorelease];
                self.stopSelectingElement.contextBounds = CGRectInset(selectRect, selectRectSize.width, selectRectSize.height);
                self.stopSelectingElement.startLocation = element.stopLocation;
                self.stopSelectingElement.accessibilityHint = @"stopSelectingElement";
            }
        } 
    }
}


@end
