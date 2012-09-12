//
//  OEBTextPageInfoSelectFun.m
//  DocinBookReader
//
//  Created by  on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OEBTextPageInfoSelectFun.h"
#import "OEBTextRowInfo.h"
#import "OEBTextRowInfoSelectFun.h"
#import "accessibilityElement.h"
#import "OEBLocation.h"

@implementation OEBTextPageInfo (select)

- (id) sentenceStartLocationWithLocation:(OEBLocation*)location
{
    return location;
}
- (id) sentenceStoptLocationWithLocation:(id)location
{
    return location;
}

- (id) startLocationWithPoint:(CGPoint)point 
{
    [self createAccessbility];
    
    id loc = nil;
    CGRect preRect = CGRectZero;
    CGRect curRect = CGRectZero;
    id preRowInfo = nil;
    for (OEBTextRowInfo* tRowInfo in self.rowInfoArray)
    {
        curRect = tRowInfo.contentRect;
        
        //point 正好处于这个row内
        if (point.y >= curRect.origin.y 
            && point.y <= curRect.origin.y + curRect.size.height)
        {
            loc = [tRowInfo startLocationWithPoint:point];
            break;
        }
        else if (point.y > preRect.origin.y + preRect.size.height
                 && point.y < curRect.origin.y)//point between double row。 我们认为这个point是想要选择下一个row
        {
            if (point.y - (preRect.origin.y + preRect.size.height) < curRect.origin.y - point.y
                && preRowInfo != nil)
            {
                loc = [preRowInfo startLocationWithPoint:point];
            }
            else
            {
                loc = [tRowInfo startLocationWithPoint:point];
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
        loc = [preRowInfo startLocationWithPoint:point];
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
    for (OEBTextRowInfo* tRowInfo in self.rowInfoArray)
    {
        curRect = tRowInfo.contentRect;
        
        //point 正好处于这个row内
        if (point.y >= curRect.origin.y 
            && point.y <= curRect.origin.y + curRect.size.height)
        {
            loc = [tRowInfo stopLocationWithPoint:point];
            break;
        }
        else if (point.y > preRect.origin.y + preRect.size.height
                 && point.y < curRect.origin.y)//point between double row。 我们认为这个point是想要选择下一个row
        {
            if (point.y - (preRect.origin.y + preRect.size.height) < curRect.origin.y - point.y
                && preRowInfo != nil)
            {
                loc = [preRowInfo stopLocationWithPoint:point];
            }
            else
            {
                loc = [tRowInfo stopLocationWithPoint:point];
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
        loc = [preRowInfo stopLocationWithPoint:point];
    }
    return loc; 
}

- (id) accessbilityWithPoint:(CGPoint)point ;
{
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


- (void) setSelectElementWithRowInfo:(OEBTextRowInfo*) rowInfo
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


@end
