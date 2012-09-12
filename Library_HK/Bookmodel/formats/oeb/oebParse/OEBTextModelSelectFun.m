//
//  OEBTextModelSelectFun.m
//  DocinBookReader
//
//  Created by  on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "OEBTextModelSelectFun.h"
#import "OEBTextPageInfo.h"
#import "OEBTextPageInfoSelectFun.h"
#import "OEBLocation.h"
#import "NSString ++.h"

@implementation OEBTextModel (select)

- (id) sentenceStartLocationWithPoint:(CGPoint)point inPageIndex:(int)pageIndex
{
    OEBTextPageInfo* pageInfo = [self pageWithPageIndex:pageIndex];
    id loc = [pageInfo startLocationWithPoint:point];
    
    NSString* str = [self strBackwardWithLocation:loc limitNumber:200];
    int lastSeperatorIndex = [str rFindLastSeperatorIndex];
    
    int length = 0;
    if (lastSeperatorIndex != -1)
    {
        length = [str length] - lastSeperatorIndex - 1;
    }
    else
    {
        length = [str length];
    }
    loc = [self locationForBackward:loc withLength:length];
    
    loc = [pageInfo sentenceStartLocationWithLocation:loc];
    
    OEBLocation* startLocationOfThePage = [[self pageWithPageIndex:pageIndex] startLoc];
    
    if ([startLocationOfThePage isForwardFrom:loc])
    {
        loc = startLocationOfThePage;
    }
    return loc;
}

- (id) sentenceStoptLocationWithPoint:(CGPoint)point inPageIndex:(int)pageIndex
{
    OEBTextPageInfo* pageInfo = [self pageWithPageIndex:pageIndex];
    id loc = [pageInfo stopLocationWithPoint:point];
    
    if ([loc isParagraphEnd])
    {
        return loc;
    }
    
    NSString* str = [self strForwardWithLocation:loc limitNumber:200];
    
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
    
    if (lastSeperatorIndex != -1)
    {
        length += lastSeperatorIndex;
        int include = [[str substringWithRange:NSMakeRange(lastSeperatorIndex , 1)] isVisible]?1:0;
        loc = [self locationForForward:loc withLength:length+include];
    }
    else
    {
        OEBLocation* tLoc = [[[OEBLocation alloc] initWithHref:((OEBLocation*)loc).href] autorelease];
        tLoc.paragraph = ((OEBLocation*)loc).paragraph;
        tLoc.postion = ((OEBLocation*)loc).postion + [str length];
        loc = tLoc;
    }
    
    OEBLocation* stopLocationOfThePage = [[self pageWithPageIndex:pageIndex] stopLoc];
    
    if ([stopLocationOfThePage isBackwardFrom:loc])
    {
        loc = stopLocationOfThePage;
    }
    
    return loc;
}

- (id) startLocationWithPoint:(CGPoint)point inPageIndex:(int)pageIndex
{
    OEBTextPageInfo* pageInfo = [self pageWithPageIndex:pageIndex];
    
    return [pageInfo startLocationWithPoint:point ];
}

- (id) stopLocationWithPoint:(CGPoint)point inPageIndex:(int)pageIndex
{
    OEBTextPageInfo* pageInfo = [self pageWithPageIndex:pageIndex];
    
    return [pageInfo stopLocationWithPoint:point ];
}

- (id) accessbilityWithPoint:(CGPoint)point inPageIndex:(int)pageIndex
{
    OEBTextPageInfo* pageInfo = [self pageWithPageIndex:pageIndex];
    
    return [pageInfo accessbilityWithPoint:point ];
}

- (id) startSelectingElementInPageIndex:(int)pageIndex
{
    OEBTextPageInfo* pageInfo = [self pageWithPageIndex:pageIndex];
    
    return pageInfo.startSelectingElement;
}

- (id) stopSelectingElementInPageIndex:(int)pageIndex
{
    OEBTextPageInfo* pageInfo = [self pageWithPageIndex:pageIndex];
    
    return pageInfo.stopSelectingElement;
}

@end
